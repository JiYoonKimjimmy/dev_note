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

## Spring Boot + Redis
**Redis 관련 의존성 추가**
```groovy
implementation 'org.springframework.boot:spring-boot-starter-data-redis'
implementation 'it.ozimov:embedded-redis:0.7.2'
```

### Redis 설정
#### application.yml 수정
```yml
spring:
  redis:
    host: localhost
    port: 6379
```
#### Embedded Redis Config 추가
```java
// @Profile : 사용할 profile 설정(local test를 위해서 "local" 로 지정)ㅃ
@Profile("local")
@Configuration
public class EmbeddedRedisConfiguration {

    @Value("${spring.redis.port}")
    private int redisPort;

    private RedisServer redisServer;

    @PostConstruct
    public void startRedis() {
        redisServer = new RedisServer(redisPort);
        redisServer.start();
    }

    @PreDestroy
    public void stopRedis() {
        if (redisServer != null) {
            redisServer.stop();
        }
    }

}
```

#### Redis Config 추가
```java
@RequiredArgsConstructor
@EnableCaching
@Configuration
public class RedisConfiguration {

    @Bean(name = "cacheManager")
    public RedisCacheManager cacheManager(RedisConnectionFactory connectionFactory) {
        /**
         * Cache 기본 설정
         */
        RedisCacheConfiguration configuration = RedisCacheConfiguration.defaultCacheConfig()
                .disableCachingNullValues()                                 // Null Value 는 Cache 사용하지 않음
                .entryTtl(Duration.ofSeconds(CacheKey.DEFAULT_EXPIRE_SEC))  // Cache 의 기본 유효시간 설정(60sec)
                .computePrefixWith(CacheKeyPrefix.simple())                 // Cache Key 의 Prefix 설정(name + "::")
                // Redis Cache 데이터 저장방식을 StringSerializer 로 설정
                .serializeKeysWith(RedisSerializationContext.SerializationPair.fromSerializer(new StringRedisSerializer()));

        /**
         * Cache 상세 설정
         * - Cache default expire 시간 설정
         */
        Map<String, RedisCacheConfiguration> cacheConfigurations = new HashMap<>();
        cacheConfigurations.put(CacheKey.USER, RedisCacheConfiguration.defaultCacheConfig().entryTtl(Duration.ofSeconds(CacheKey.USER_EXPIRE_SEC)));
        cacheConfigurations.put(CacheKey.BOARD, RedisCacheConfiguration.defaultCacheConfig().entryTtl(Duration.ofSeconds(CacheKey.BOARD_EXPIRE_SEC)));

        return RedisCacheManager.RedisCacheManagerBuilder
                .fromConnectionFactory(connectionFactory)
                .cacheDefaults(configuration)
                .withInitialCacheConfigurations(cacheConfigurations)
                .build();

    }

}
```

### Entity Redis 설정
#### Caching 객체 Serializable
##### Caching 객체 Serializable 하는 이유
* `Redis`에 객체를 저장하면 내부적으로 직렬화하여 저장
* `Entity`에 `Serializable`을 선언하지 않으면 오류 발생 가능
```java
@Entity
public class Board implements Serializable {
  ...
}
```
#### Lazy Loading False
##### Lazy Loading false 처리 하는 이유
* Entity 객체내에서 연관관계 Mapping에 의해 Lazy(지연) Loading 되는 경우 오류 발생 가능
```java
@Proxy(lazy = false)
public class User implements Serializable {
  ...
}
```

### CRUD Methods Caching 처리
**Caching 처리 관련 Annotation**
| Annotation | 설명 |
| :---: | --- |
| `@Cacheable` | `Cache`가 존재하면 요청된 `Method`를 실행하지 않고 `Cache`데이터를 반환 처리 |
| `@CachePut` | `Cache`에 데이터를 넣거나 수정시 사용. `Method`의 반환값이 `Cache`에 없으면 저장하고, 있는 경우엔 갱신 처리 |
| `@CacheEvict` | `Cache` 삭제 |
| `@Caching` | 여러개의 `Cache Annotation`을 실행되어야 할 때 사용 |

##### Annotation 옵션 설명
* `value = CacheKey.BOARD` : 저장시 사용되는 Key Name
* `key = "#id"` : `value` 옵션에서 선언된 Key Name 과 결합 ***(ex. 'board::1')***
* `unless = "#result == null"` : 결과가 `null` 이 아닌 경우만 Caching 처리
* `condition = "#id > 10"` : 간단한 조건문에 따라 Caching 처리

### Cache 처리의 또다른 방법. CacheService 추가
* `Caching` 처리해주는 Service
* 왜 `CacheService`가 필요한가?
  * 요청받은 `Method`의 인자값으로 `Cache Key`를 조합할 수 없을 때가 있기 때문
  * `Proxy`의 특성상 같은 객체내에서는 `Caching`처리된 `Method` 호출시 동작하지 않기 때문

### Custom Key Generator
#### CustomKeyGenerator.java
```java
public class CustomKeyGenerator {
    public static Object create(Object o1) {
        return "FRONT:" + o1;
    }
    public static Object create(Object o1, Object o2) {
        return "FRONT:" + o1 + ":" + o2;
    }
}
```

#### CustomKeyGenerator 이용한 Caching
```java
@Cacheable(value = CacheKey.BOARD, key = "T(com.demo.restapi.config.redis.CustomKeyGenerator).create(#id)", unless = "#result == null")
```

---

> **Reference**
> [daddyprogrammer 블로그 [Redis로 api 결과 캐싱(Caching) 처리]](https://daddyprogrammer.org/post/3870/spring-rest-api-redis-caching/)
> [Alic Medium [레디스(Redis)란 무엇인가?]](https://medium.com/@jyejye9201/%EB%A0%88%EB%94%94%EC%8A%A4-redis-%EB%9E%80-%EB%AC%B4%EC%97%87%EC%9D%B8%EA%B0%80-2b7af75fa818)
> [garimoo Medium [Redis 튜토리얼]](https://medium.com/garimoo/%EA%B0%9C%EB%B0%9C%EC%9E%90%EB%A5%BC-%EC%9C%84%ED%95%9C-%EB%A0%88%EB%94%94%EC%8A%A4-%ED%8A%9C%ED%86%A0%EB%A6%AC%EC%96%BC-01-92aaa24ca8cc)
