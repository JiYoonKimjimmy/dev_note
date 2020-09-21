# Spring Boot + Nginx
> [참고. swchoi.log 블로그 [Nginx 무중단 배포]](https://velog.io/@swchoi0329/NGINX-%EB%AC%B4%EC%A4%91%EB%8B%A8-%EB%B0%B0%ED%8F%AC)

![Nginx](https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/8e9e6676-c522-46bb-ae1c-5f043657c186/da45r3v-7754a850-e7c5-4070-867f-bc5e3764e7e7.png/v1/fill/w_1100,h_400,strp/nginx_logo_by_333lars_da45r3v-fullview.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOiIsImlzcyI6InVybjphcHA6Iiwib2JqIjpbW3siaGVpZ2h0IjoiPD00MDAiLCJwYXRoIjoiXC9mXC84ZTllNjY3Ni1jNTIyLTQ2YmItYWUxYy01ZjA0MzY1N2MxODZcL2RhNDVyM3YtNzc1NGE4NTAtZTdjNS00MDcwLTg2N2YtYmM1ZTM3NjRlN2U3LnBuZyIsIndpZHRoIjoiPD0xMTAwIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmltYWdlLm9wZXJhdGlvbnMiXX0._sng0zxtbBT2j9uIAn0xSQJ9L9L6ZXzto1pn39-9xNA)

## Nginx
`Nginx(엔진엑스)` 는 **동시 접속 처리에 특화된** 웹 서버 프로그램
* Apache 보다는 단순하면서, 전달자 역할만 수행하기 때문에 동시 접속 처리에 용이
* 비동기 Event-Driven 기반 구조
* Nginx 의 역할로서,
  * 정적 파일 처리 HTTP 서버 역할
  * Reverse Proxy 서버 역할

>**Revser Proxy 서버?**
>>Client 가 Server 로 요청한 경우, Proxy 서버 ***(NGINX)*** 가 Reverse 서버 ***(Application)*** 로부터 데이터를 가져오는 역할을 한다.

>**Event-Driven 구조?**
>>여러 Connection 을 Event Handler 를 통해 비동기 방식으로 처리
>>![Event-Driven](https://mblogthumb-phinf.pstatic.net/MjAxNzAzMjZfMTM3/MDAxNDkwNDk1NjMxNzgy.OHZ33nerX_6Hc92Mg_xjr51acwwi1P_mq3SIl7Cuhisg.niRsQQVM5CwGpXKcdOxl3bkNsmfBkqGV1ajcBpV6CvQg.GIF.jhc9639/mighttpd_e02.gif.gif?type=w800)

## Nginx 무중단 배포
### 구성
* Nginx 1대
  * HTTP : 80 port
  * HTTPS : 443 port
* Spring Boot Application 2대
  * Spring Boot 1 : 8081 port
  * Spring Boot 2 : 8082 port

### 1. Nginx 설치 및 Spring Boot 연동
#### EC2 에 Nginx 설치
```bash
$ sudo yum install nginx
# nginx 실행
$ sudo service nginx start
```
#### 보안 그룹 추가
* 인바운드 규칙 > `HTTP port 80` 지정 안되어 있는 경우 지정
* EC2 domain 주소 **(port 제외)** 접속 확인

#### Spring Boot + Nginx
**`/etc/nginx/nginx.conf` 수정**
```bash
...
server {
  ...
  location \ {
    # Nginx 로 요청이 들어오면 해당 주소로 전달
    proxy_pass http://localhost:8080;
    # 실제 요청 데이터를 header 의 각 항목에 할당
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
  }
  ...
}
...
```

**Nginx 재시작**
```bash
$ sudo service nginx restart
```

**Spring Boot 연동 확인**
* 프로젝트 Domain **(port 제외)** 접속 확인

### 2. Profile API 추가
* 실행중인 profile 조회하기 위한 API
```java
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/profile")
public class ProfileController {

    private final Environment environment;

    @GetMapping
    public String profile() {
        // .getActiveProfiles() : 현재 실행 중인 Active Profile 목록 조회
        List<String> profiles = Arrays.asList(environment.getActiveProfiles());
        List<String> realProfiles = Arrays.asList("real", "real1", "real2");

        String defaultProfile = profiles.isEmpty() ? "default" : profiles.get(0);

        return profiles.stream()
                .filter(realProfiles::contains)
                .findAny()
                .orElse(defaultProfile);
    }
}
```

#### SecurityConfiguration.java 수정
* `/profile` API security permission 승인 처리
```java
...
.antMatchers("/*/sign/**", "/*/sign/*/**", "/social/**", "/profile").permitAll()
...
```

### 3. Profile 파일 추가 생성
* real1, real2 각각 profile yml 생성
```yml
# application-real1.yml, application-real2.yml
server:
  port: 8081        # real2 인 경우, 8082

spring:
  profiles: real1   # real2 인 경우, real2
  url:
    base: [Application Domain]

logging:
  level:
    root: warn
    com.demo.restapi: info
  file:
    path: /home/ec2-user/logs/rest-api
    max-history: 7
```

### 4. Nginx 설정 수정
#### `/etc/nginx/conf.d/service-url.inc` 생성
```bash
$ sudo vi /etc/nginx/conf.d/service-url.inc

# service=url.inc
set $service_url http://127.0.0.1:8080;
```

#### `/etc/nginx/nginx.conf` 수정
```bash
...
server {
  ...
  location \ {
    # 추가
    include /etc/nginx/conf.d/service-url.inc

    # http://localhost:8080 -> $service_url 로 변경
    proxy_pass $service_url;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
  }
  ...
}
...
```

**Nginx 재시작**
```bash
$ sudo service nginx restart
```

### 5. Deploy Script 추가
#### 추가할 Scrpit 목록
| script | 설정 |
| --- | :---: |
| `profile.sh` | 현재 profile 버전, port 확인 |
| `stop.sh` | 실행 중이던 Spring Boot 종료 |
| `start.sh` | 배포할 Spring Boot 종료 후 `profile.sh` 실행 |
| `health.sh` | `start.sh` 로 실행된 프로젝트 정상 동작 확인 |
| `switch.sh` | Nginx 의 Spring Boot 를 최신 profile 버전으로 변경 |

#### `appspec.yml` 수정
```yml
hooks:
  # Nginx 와 연동된 Spring Boot 프로젝트 종료
  AfterInstall:
    - location: stop.sh
      timeout: 60
      runas: ec2-user
  # Nginx 와 연동안된 profile 버전으로 Spring Boot 실행
  ApplicationStart:
    - location: start.sh
      timeout: 60
      runas: ec2-user
  # 새로 실행된 Spring Boot 정상 동작 확인
  ValidateService:
    - location: health.sh
      timeout: 60
      runas: ec2-user
```

#### `profile.sh`
```bash
#!/usr/bin/env bash

# 쉬고 있는 profile 찾기
function find_idle_profile() {
  # 현재 Nginx 와 연동된 프로젝트가 정상적인지 확인
  # RESPONSE_CODE 는 HTTP status code 로 반환
  RESPONSE_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/profile)

  # 프로젝트 상태가 400 보다 큰 경우, 에러
  if [ ${RESPONSE_CODE} -ge 400 ]
  then
    CURRENT_PROFILE=real2
  else
    CURRENT_PROFILE=$(curl -s http://localhost/profile)
  fi

  if [ ${CURRENT_PROFILE} == real1 ]
  then
    IDLE_PROFILE=real2
  else
    IDLE_PROFILE=real1
  fi

  echo "${IDLE_PROFILE}"
}

# 쉬고 있는 profile 의 port 찾기
function find_idle_port() {
  IDLE_PROFILE=$(find_idle_profile)

  if [ ${IDLE_PROFILE} == real1 ]
  then
    echo "8081"
  else
    echo "8082"
  fi
}
```

#### `stop.sh`
```bash
#!/usr/bin/env bash

ABSPATH=$(readlink -f $0)
ABSDIR=$(dirname $ABSPATH)
source ${ABSDIR}/profile.sh

IDLE_PORT=$(find_idle_port)

echo "> $IDLE_PORT 에서 구동 중인 애플리케이션 pid 확인"
IDLE_PID=$(lsof -ti tcp:${IDLE_PORT})

if [ -z ${IDLE_PID} ]
then
  echo "> 현재 구동 중인 애플리케이션이 없으므로 종료하지 않습니다."
else
  echo "> kill -15 $IDLE_PID"
  kill -15 ${IDLE_PID}
  sleep 5
fi
```

#### `start.sh`
```bash
#!/usr/bin/env bash

ABSPATH=$(readlink -f $0)
ABSDIR=$(dirname $ABSPATH)
source ${ABSDIR}/profile.sh

REPOSITORY=/home/ec2-user/apps
DEPLOY_DIRECTORY=/home/ec2-user/deploy
PROJECT_NAME=rest-api

echo "> old 파일 이동"
mv $REPOSITORY/$PROJECT_NAME/*.jar $REPOSITORY/$PROJECT_NAME/old/

echo "> Build 파일 복사"
cp $DEPLOY_DIRECTORY/$PROJECT_NAME/*.jar $REPOSITORY/$PROJECT_NAME/

echo "> 새 애플리케이션 배포"
JAR_NAME=$(ls -tr $REPOSITORY/$PROJECT_NAME/*.jar | tail -n 1)

echo "> JAR Name: $JAR_NAME"

echo "> $JAR_NAME 에 실행권한 추가"
chmod +x $JAR_NAME

echo "> $JAR_NAME 실행"
IDLE_PROFILE=$(find_idle_profile)

echo "> $JAR_NAME 를 profile=$IDLE_PROFILE 로 실행합니다."
nohup java -jar \
    -Dspring.config.location=classpath:/application.yml,classpath:/application-$IDLE_PROFILE.yml,/home/ec2-user/apps/config/application-db.yml \
    -Dspring.profiles.active=$IDLE_PROFILE \
    -Dfile.encoding=UTF-8 \
    $JAR_NAME > $REPOSITORY/$PROJECT_NAME/nohup.out 2>&1 &
```

#### `health.sh`
```bash
#!/usr/bin/env bash

ABSPATH=$(readlink -f $0)
ABSDIR=$(dirname $ABSPATH)
source ${ABSDIR}/profile.sh
source ${ABSDIR}/switch.sh

IDLE_PORT=$(find_idle_port)

echo "> Health Check Start!"
echo "> IDLE_PORT: $IDLE_PORT"
echo "> curl -s http://localhost:$IDLE_PORT/profile"
sleep 10

for RETRY_COUNT in {1..10}
do
  RESPONSE=$(curl -s http://localhost:${IDLE_PORT}/profile)
  UP_COUNT=$(echo ${RESPONSE} | grep 'real' | wc -l)

  # $UP_COUNT >= 1 ("real" 문자열이 있는지 검증)
  if [ ${UP_COUNT} -ge 1 ]
  then
    echo "> Health check 성공"
    switch_proxy
    break
  else
    echo "> Health check의 응답을 알 수 없거나 혹은 실행 상태가 아닙니다."
    echo "> Health check: ${RESPONSE}"
  fi

  if [ ${RETRY_COUNT} -eq 10 ]
  then
    echo "> Health check 실패. "
    echo "> 엔진엑스에 연결하지 않고 배포를 종료합니다."
    exit 1
  fi

  echo "> Health check 연결 실패. 재시도..."
  sleep 10
done
```

#### `switch.sh`
```bash
#!/usr/bin/env bash

ABSPATH=$(readlink -f $0)
ABSDIR=$(dirname $ABSPATH)
source ${ABSDIR}/profile.sh

function switch_proxy() {
  IDLE_PORT=$(find_idle_port)

  echo "> 전환할 Port: $IDLE_PORT"
  echo "> Port 전환"

  # Nginx 가 변경할 Proxy 주소를 생성 후, service-url.inc 에 over-write
  echo "set \$service_url http://127.0.0.1:${IDLE_PORT};" | sudo tee /etc/nginx/conf.d/service-url.inc

  echo "> 엔진엑스 Reload"

  # Nginx 설정 reload(끊김 없이 다시 불러옴)
  sudo service nginx reload
}
```

### 무중단 배포 확인
#### `build.gradle` 수정
```groovy
version = '0.0.1-SNAPSHOT-' + new Date().format("yyyyMMddHHmmss")
```

#### Log 확인
```bash
# CodeDeploy Log
$ vi /opt/codedeploy-agent/deploayment-root/deployment-logs
# Spring Boot log
$ vi nohup.out
# Java application 실행 여부 확인
$ ps -ef | grep java
```

---

[관련 Github Repository](https://github.com/JiYoonKimjimmy/demo-rest-api)
