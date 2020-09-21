# Spring Boot + Travis CI 연동
> [참고. swchoi.log 블로그 [Travis CI 배포 자동화]](https://velog.io/@swchoi0329/Travis-CI-%EB%B0%B0%ED%8F%AC-%EC%9E%90%EB%8F%99%ED%99%94)

![Travis CI](https://blog.kakaocdn.net/dn/b4Qp4h/btqB6JnDavT/RFaJbfaX9trqfs5B2st9bk/img.png)

## CI & CD
### CI(Continuous Integration) *- 지속적인 통합?*
VCS 시스템을 통해 새로운/변경된 Resource 에 대해 자동으로 테스트 또는 빌드 수행 후 **안정적인 배포 파일을 생성하는 과정**

### CD(Continuous Deployment) *- 지속적인 배포?*
빌드 결과를 자동으로 운영 서버에 **무중단 배포하는 과정**

## why? *Travis CI*?
* Github 와의 상호 연동(혹은 의존성)
* Slack, Mail .. 다양한 메신저 연동 가능

---

## Travis CI 연동 과정
### 1. Travis CI 설정
[https://travis-ci.org/](https://travis-ci.org/)
* Travis CI Web Service 에서 Github 계정 로그인
* Travis Settins 에서 연동할 Github repository 활성화

### 2. 프로젝트 Travis CI 설정
#### `travis.yml` 추가
***! build.gradle 동일한 위치에 추가 !***
```yml
language: java
jdk: openjdk8

# Travis CI 를 어느 branch 가 push 될 때 수행할지 설정
branches:
 only: master

# gradle 통해 의존서을 받게 되면 해당 디렉토리에 cache 하여,
# 같은 의존성은 다음 배포 때부터 받지 않도록 설정
cache:
 directories:
   - '$HOME/.m2/repository'
   - '$HOME/.gradle'

before_install:
 - chmod +x gradlew

# branch 에 push 되었을 때 수행하는 명령어
script: "./gradlew clean build"

# Travis CI 실행 완료 후 자동 알림 설정
notifications:
 email:
   recipients:
     - [메일 주소]
```

### 3. Travis CI + AWS S3 연동
#### AWS S3?
* AWS에서 제공하는 파일 서버로서, 정적 파일 관리 또는 배포 파일 관리 기능 제공 서비스

***AWS 와 Travis CI 연동 프로세스***
![](https://media.vlpt.us/images/swchoi0329/post/785bd93e-b9f0-411c-bbcf-0b0dffe511d0/ttt.PNG)

#### IAM 사용자 만들기
* 사용자 세부 정보 설정
  * 사용자 이름 > `jimmyberg-travis-deploy`
  * AWS 액세스 유형 선택 > 프로그래밍 방식 액세스
* 권한 설정
  * 기존 정책 직접 연결
    * `AmazonS3FullAccess`
    * `AmazonCodeDeployFullAccess`
* 태그 추가
  * 키 : `Name`, 값 : `jimmyberg-travis-deploy`

#### Travis CI에 S3 액세스 키 등록
* 연동한 repository 의 settings 에서 키 등록
  * `AWS_ACCESS_KEY` : 액세스 키
  * `AWS_SECRET_KEY` : 비밀 액세스 키
* .travis.yml 에서 `$AWS_ACCESS_KEY`, `$AWS_SECRET_KEY` 으로 사용

#### S3 버킷 생성
* 버킷 이름 > `jimmyberg-rest-api`

#### `.travis.yml` 수정
```yml
...
script: "./gradlew clean build"

# 수정 start
# deploy 가 실행되기 전에 수행
# CodeDeploy 는 Jar 파일 인식하지 못하므로
# 프로젝트를 압축한 zip 파일로 전달
before_deploy:
  - zip -r rest-api ./*
  - mkdir -p deploy
  - mv rest-api.zip deploy/rest-api.zip

# 외부 서비스와 연동될 명령어 정의
deploy:
    - provider: s3
      access_key_id: $AWS_ACCESS_KEY
      secret_access_key: $AWS_SECRET_KEY

      bucket: jimmyberg-rest-api
      region: ap-northeast-2
      skip_cleanup: true
      acl: private
      local_dir: deploy     # 지정한 위치의 파일들만 S3로 전송
      wait_until_deployed: true
# 수정 end

notifications:
...
```

### 4. Travis CI + S3 + CodeDeploy
#### EC2 에 IAM 역할 추가
* `ec2-codedeploy-role` 역할 만들기
* EC2 > 인스턴스 설정 > IAM 역할 연결/바꾸기
    * `ec2-codedeploy-role` 역할 선택
    * EC2 인스턴스 재부팅

**EC2 에 CodeDeploy agent 설치**
```bash
$ aws s3 cp s3://aws-codedeploy-ap-northeast-2/latest/install ./s3 --resion ap-northeast-2
# 설치 디렉토리 이동
$ cd s3
# 실행 권한 추가
$ chmod +x ./install
# install 파일 설치
$ sudo ./install auto
# CodeDeploy agent 상태 확인
$ sudo service codedeploy-agent status
```

#### CodeDeploy 권한 생성
* IAM 역할
  * `CodeDeploy` 선택
* 정책
  * `AWSCodeDeployRole` 선택
* 태그 추가
  * 키 : `Name`, 값 : `codedeploy-role`

#### CodeDeploy 생성
* 애플리케이션 생성
  * 애플리케이션 구성
    * 애플리케이션 이름 : `rest-api`
    * 컴퓨팅 플랫폼 : `EC2/온프레미스`
  * 배포그룹 생성
    * 배포그룹 이름 : `rest-api-group`
    * 서비스 역할 : `codedeploy-role`
    * 배포 유형 : `현재 위치` 선택(배포할 서비스가 2대 이상이라면 `블루/그린` 선택)
    * 환경 구성 : `Amazon EC2 인스턴스`
    * 태그 추가
      * 키 : `Name`, 값 : `Amazon Linux Web Server`
  * 배포 설정
    * `CodeDeployDefault.AllAtOnce` 선택
  * 로드 밸런서 해제

#### 연동 설정 파일 추가 및 수정
* EC2 에 zip 파일 저장 디렉토리 생성
```bash
$ mkdir /home/ec2-user/s3/zip/rest-api
```
* `appspec.yml` 추가
```yml
version: 0.0
os : linux
files :
  # CodeDeploy 에서 전달해준 파일 중 destination 으로 이동시킬 대상 지정
  - source : /
  # source 에서 지정된 파일을 저장할 위치
  destination: /home/ec2-user/s3/zip/rest-api/
  # 덮어쓰기 여부
  overwrite : yes
```
* `.travis.yml` 수정
```yml
deploy:
  ...

  - provider: codedeploy
    access_key_id: $AWS_ACCESS_KEY
    secret_access_key: $AWS_SECRET_KEY

    bucket: jimmyberg-rest-api
    key: rest-api.zip
    bundle_type: zip
    application: rest-api
    deployment_group: rest-api-group
    region: ap-northeast-2
    wait_until_deployed: true
```
* EC2 에 저장된 zip 디렉토리 확인

### 5. 배포 자동화 구성
#### 프로젝트에 `deploy.sh` 추가
```bash
# project > scripts > deploy.sh
#!/bin/bash

REPOSITORY=/home/ec2-user/apps
DEPLOY_DIRECTORY=/home/ec2-user/deploy
PROJECT_NAME=rest-api

echo "> Build 파일 복사"

cp $DEPLOY_DIRECTORY/$PROJECT_NAME/*.jar $REPOSITORY/$PROJECT_NAME/

echo "> 현재 구동중인 애플리케이션 pid 확인"

CURRENT_PID=$(pgrep -fl $PROJECT_NAME | grep jar | awk '{print $1}')

echo "> 현재 구동 중인 애플리케이션 pid: $CURRENT_PID"

if [ -z "$CURRENT_PID" ]; then
   echo "> 현재 구동 중인 애플리케이션이 없으므로 종료하지 않습니다."
else
   echo "> kill -15 $CURRENT_PID"
   kill -15 $CURRENT_PID
   sleep 5
fi

echo "> 새 애플리케이션 배포"

JAR_NAME=$(ls -tr $REPOSITORY/$PROJECT_NAME/*.jar | tail -n 1)

echo "> JAR Name: $JAR_NAME"

echo "> $JAR_NAME 에 실행권한 추가"

chmod +x $JAR_NAME

echo "> $JAR_NAME 실행"

rm $REPOSITORY/$PROJECT_NAME/nohup.out

nohup java -jar -Dspring.profiles.active=alpha -Dfile.encoding=UTF-8  $JAR_NAME > $REPOSITORY/$PROJECT_NAME/nohup.out 2>&1 &
```
#### `.travis.yml` 수정
```yml
language: java
jdk:
  - openjdk8

branches:
  only:
    - master

cache:
  directories:
    - '$HOME/.m2/repository'
    - '$HOME/.gradle'

before_install:
  - chmod +x gradlew

script: "./gradlew clean build"

before_deploy:
  - echo $(pwd)
  - mkdir -p before-deploy
  - cp scripts/*.sh before-deploy/
  - cp appspec.yml before-deploy/
  - cp build/libs/*.jar before-deploy/
  - cd before-deploy && zip -r before-deploy *
  - cd ../ && mkdir -p deploy
  - mv before-deploy/before-deploy.zip deploy/rest-api.zip

deploy:
  - provider: s3
    access_key_id: $AWS_ACCESS_KEY
    secret_access_key: $AWS_SECRET_KEY
    bucket: jimmyberg-rest-api
    region: ap-northeast-2
    skip_cleanup: true
    acl: private
    local_dir: deploy
    wait-until-deployed: true

  - provider: codedeploy
    access_key_id: $AWS_ACCESS_KEY
    secret_access_key: $AWS_SECRET_KEY
    bucket: jimmyberg-rest-api
    key: rest-api.zip
    bundle_type: zip
    application: rest-api
    deployment_group: rest-api-group
    region: ap-northeast-2
    wait-until-deployed: true

notifications:
  slack: [slack accesss key]
```

#### `appspec.yml` 수정
```yml
version: 0.0
os : linux
files :
  - source : /
    destination: /home/ec2-user/deploy/rest-api
    overwrite : yes

# CodeDeploy 에서 EC2 로 넘겨준 파일 모두 ec2-user 권한 설정
permissions:
  - object: /
    pattern: "**"
    owner: ec2-user
    group: ec2-user

# CodeDeploy 배포 단계에서 실행할 명령어 설정
# ApplicationStart 단계 : ec2-user 권한으로 deploy.sh 실행
hooks:
  ApplicationStart:
    - location: deploy.sh
      timeout: 60
      runas: ec2-user
```

#### 배포 Log 확인 방법
##### CodeDeploy 관련 Log
```bash
$ cd /opt/codedeploy-agent/deploayment-root/
$ vi ./deployment-logs
```

##### 프로젝트 관련 Log
```bash
$ cd ~/apps/rest-api/
$ vi ./nohup.out
```

---

[관련 Github Repository](https://github.com/JiYoonKimjimmy/demo-rest-api)
