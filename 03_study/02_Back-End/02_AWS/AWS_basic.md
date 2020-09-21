# AWS
## AWS?
Amazon 에서 제공하는 ***Cloud Computing Web Service*** 플랫폼

## Cloud Computing?
* 물리적인 형태의 실물 서버 컴퓨팅 환경을 네트워크 기반의 원격 서비스 형태로 제공
* 사용자가 네트워크 상에 있는 서버로 접근하여 리소스를 사용

---

## EC2
### 인스턴스
* 서버 컴퓨터 1대의 개념 서비스

#### EC2 인스턴스 구성(2020.09.08 기준)
* AMI 선택 : Ubuntu Server 18.04 LTS
* 인스턴스 유형 선택 : 프리티어 모드 사용 가능한 인스턴스 유형
* 세부 정보 입력 : default
* 스토리지 추가 : 30GB
* 태그 추가 : Key - "Name", Value - "웹서버" 입력
* 보안 그룹 구성
    * 보안 그룹 이름 : Web Server
    * 규칙 유형 추가 : HTTP
* 키 페어 생성

#### 보안그룹 수정
* Tomcat 외부 접속 가능하도록 설정
    * 유형 : 사용자 지정 TCP
    * 프로토콜 : TCP
    * 포트 범위 : 8080
    * 소스 : 0.0.0.0/0, ::/0

### AWS EC2 환경 구축 참고
* [EC2 Instance 로 Ubuntu 환경 구축하기](https://yoonhoohwang.tistory.com/8)
* [Amazon Linux1 EC2 서버 필수 설정](https://velog.io/@minholee_93/AWS-Amazon-Linux1-EC2-%EC%84%9C%EB%B2%84-%ED%95%84%EC%88%98-%EC%84%A4%EC%A0%95)
* [AWS Spring Boot 배포하기](https://velog.io/@swchoi0329/series/%EC%8A%A4%ED%94%84%EB%A7%81-%EB%B6%80%ED%8A%B8%EC%99%80-AWS%EB%A1%9C-%ED%98%BC%EC%9E%90-%EA%B5%AC%ED%98%84%ED%95%98%EB%8A%94-%EC%9B%B9-%EC%84%9C%EB%B9%84%EC%8A%A4)

---

## RDS
* [AWS DB 환경 구축 참고](https://velog.io/@swchoi0329/AWS-%EB%8D%B0%EC%9D%B4%ED%84%B0%EB%B2%A0%EC%9D%B4%EC%8A%A4-%ED%99%98%EA%B2%BD-%EA%B5%AC%EC%B6%95)

#### 관련 명령어
```bash
# DB 접속
$ mysql -u admin -p -h [DB Host address]
```
