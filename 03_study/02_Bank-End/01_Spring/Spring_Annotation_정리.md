# Spring Annotation 정리
## Spring 설정 관련
### @Configuration
* 해당 Class 를 Bean 구성 Class 로 Spring IOC Container 에 지정
### @Bean
* 개발자가 직접 제어가 불가능한 외부 라이브러리등을 Bean 등록할 때 사용
* ***Bean? Spring IOC Container 가 관리하는 Java 객체. ApplicationContext 가 객체를 생성하고 관리한다.***
```java
@Configuration
public class ApplicationConfig {
  @Bean
  public ArrayList<String> arrayList() {
    return new ArrayList<String>();
  }
}
/**
 * ArrayList 와 같은 라이브러리를 Bean 등록하기 위해서
 * 해당 라이브러리 객체를 반환하는 Method 를 생성한 후, @Bean Annotation 으로 Bean 등록
 * (이때, Bean id 는 method 명인 "arrayList" 가 된다.)
 */
```
### @Component
* 개발자가 직접 작성한 Class 를 Bean 등록할 때 사용
```java
@Component
public class Student {
  public Student() {
    ...
  }
}
```
### @Autowired
* 등록된 Bean 의 의존성을 자동으로 주입할 때 사용
### @RestControllerAdvice
* ExceptionAdvice 에서 예외 발생시 json 형태의 결과를 반환
### @ExceptionHandler
* 예외 발생시 Exception handler 로 지정
### @ResponseStatus
* 해당 Exception 발생시, http status code 정의
### @PostConstruct
* WAS 구동시, 특정 객체의 init method 를 호출할 때 사용

---

## Jackson 설정 관련
### @JsonIgnoreProperties
* JSON Serializer / Deserialize 할 때 제외시킬 Property 를 지정
* 개별적으로 사용할 땐, **@JsonIgnore** Annotation 사용
### @JsonProperty
* JSON Property 의 속성을 변경할 때 사용
### @JsonInclude
* JSON Serialize 시 동작을 지정할 때 사용

---

## Lombok 설정 관련
### @NoArgsConstructor
* Parameter 가 없는 기본 생성자 생성
### @AllArgsConstructor
* 모든 Parameter 가 있는 생성자 생성
### @RequiredArgsConstructor
* final 이나 @NonNull 인 Field 값만 parameter 로 받는 생성자 생성
### @EqualsAndHashCode
* equals & hashCode method 자동 생성
### @Data
* @Getter, @Setter, @RequiredArgsConstructor, @ToString, @EqualsAndHashCode 자동 생성
### @Builder.Default
* Builder.build() 시, 기본값을 설정할 때 사용
* 설정안할 경우, 0 / null / false 로 설정

---

## Spring JPA 설정 관련
### @ElementCollection
* 단순하거나 내장된 유형을 1:N 관계를 구현할 때 사용
* 주로 Entity 가 아닌 유형을 매핑할 때 사용
