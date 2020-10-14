# 공공 데이터 포털 API

## Open API 신청 방법
##### 1. 공공 데이터 포털 [(https://www.data.go.kr)](https://www.data.go.kr/) 접속
![image1](./images/image1.png)
##### 2. 회원 가입 및 로그인
![image2](./images/image2.png)
##### 3. 이용하고자 하는 공공 API 표준데이터 **(전국주차장표준데이터 or 전국세차장표준데이터)** 검색
![image3](./images/image3.png)
##### 4. 표준데이터 Open API 활용 신청
![image4](./images/image4.png)
##### 5. 활용목적만 작성하면 쉽게 신청 완료
![image5](./images/image5.png)

---

## Open API 활용 방법
##### 1. 신청한 활용 공공 데이터 확인 (마이페이지에서 확인 가능)
![image6](./images/image6.png)
##### 2. Open API 정보 확인
![image7](./images/image7.png)
##### 3. API 조회 테스트
* 요청시 주의사항
    * `serviceKey`도 `url param`에 담아줘야 조회 가능
    * 필수 `request param`
        * serviceKey
        * pageNo
        * numOfRows
        * type
* ex) 전국세차장표준데이터 조회 요청 URL : http://api.data.go.kr/openapi/tn_pubr_public_carwsh_api?pageNo=0&numOfRows=100&type=xml&serviceKey=LGg12%2B%2BRNPBk4ZoSIVuownxLrJ74ELJDhzOnqYDNuBuxr1I4eQdRcAaAhOk8awaeveye8QG5TTVhIr19psJrQw%3D%3D
* 특이사항
    * **전국주차장표준데이터**는 조회가 `페이징` 처리가 되지 않아 유선으로 수정 요청한 상태입니다.
    * **전국세차장표준데이터**는 `페이징` 처리 및 조회가 정상 동작하지만, 조건 검색이 `LIKE` 검색이 아닙니다.
* [마이페이지 > 활용 Open API 상세 페이지] 에서 `미리보기` 기능으로 테스트 가능

![image8](./images/image8.png)

---

## 추가
### 위도, 경도로 주변 정보 조회 Query
```sql
SELECT
    *,
    (6371 * acos(cos(radians(`:@현재위치 위도`))
            * cos(radians(latitude))
            * cos(radians(longitude)
            - radians(`:@현재위치 경도`))
            + sin(radians(`:@현재위치 위도`))
            *sin(radians(latitude))
    )) AS distance
FROM car_wash
HAVING distance <= 1    # 거리 단위 : 1 = 1km
ORDER BY distance;
```
