# Spring Boot + Redis
![Redis](https://image.opencart.com/cache/5dd37bf81e70b-resize-710x380.jpg)
## Redis
Redis(**Remote Dictionary Server**)는 메모리 기반의 **Key - Value** 구조의 모든 데이터를 메모리에 저장하기 때문에 Read, Write 성능을 보장하는 데이터 관리 시스템이다.

### Redis 의 특징
* 영속성을 지원하는 **In-Memory** 데이터 저장소이다.
* 메모리에 데이터를 저장하기 때문에 처리 속도가 빠르다.
* 디스크에도 저장되기 때문에 데이터 복구가 가능하다.**(`Memcached` 와 차이점)**
* 만료일을 지정하는 방식으로 데이터 삭제가 가능하다.
* 저장소의 메모리 재사용하지 않는다.
* 다양한 데이터 타입을 지원한다.
> **Redis 가 지원하는 데이터 타입**
> * String
> * Set
> * Sorted Set
> * Hash
> * List

* Read 성능을 위한 Server 의 복제 지원를 지원한다.
  * Master - Slave 구조로 사고 예방
* Write 성능을 위해 Client 에 **Sharding** 을 지원한다.
  * Sharding ? 같은 테이블 스키마를 가진 데이터를 다수의 데이터베이스에 분산하여 저장하는 방법
* **1개의 Single Thread 로 수행**되기 때문에, 서버 하나에 여러개의 서버 운용이 가능하다.

### Redis 유의사항
#### Redis Key
* Redis 의 `Key` 는 문자열이기 때문에 모든 이진 시퀀스를 키로 사용 가능하고, 빈 문자열까지도 `Key` 가 될 수 있다. 최대 `Key` 크기는 512MB 이다.
* Redis 의 `Key` 설계는 매우 중요하며, 설계에 따라 Redis 의 성능 차이가 발생할 수 있다.

#### Exprie
* 적절한 만료일을 지정해야 메모리 부하 조절이 가능하다.

---

>**Redis 관련 다른 Post**
> [AWS ElastiCache For Redis + Spring Boot 연동](/03_study/02_Back-End/02_AWS/AWS_ElastiCache.md)

> **Reference**
> [daddyprogrammer 블로그 [Redis로 api 결과 캐싱(Caching) 처리]](https://daddyprogrammer.org/post/3870/spring-rest-api-redis-caching/)
> [Alic Medium [레디스(Redis)란 무엇인가?]](https://medium.com/@jyejye9201/%EB%A0%88%EB%94%94%EC%8A%A4-redis-%EB%9E%80-%EB%AC%B4%EC%97%87%EC%9D%B8%EA%B0%80-2b7af75fa818)
> [garimoo Medium [Redis 튜토리얼]](https://medium.com/garimoo/%EA%B0%9C%EB%B0%9C%EC%9E%90%EB%A5%BC-%EC%9C%84%ED%95%9C-%EB%A0%88%EB%94%94%EC%8A%A4-%ED%8A%9C%ED%86%A0%EB%A6%AC%EC%96%BC-01-92aaa24ca8cc)
