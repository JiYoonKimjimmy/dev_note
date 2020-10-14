# 버킷플레이스 홈워크 제출

> **목차**<br>
> [1. SQL Query 문제_1](#sql-query-문제_1)<br>
> [2. SQL Query 문제_2](#sql-query-문제_2)<br>
> [3. DB Modeling 문제](#db-modeling-문제)<br>
> [4. 알고리즘 문제](#알고리즘-문제)<br>

---

## SQL Query 문제_1
***SQL Query 문제는 `MySQL` 기준으로 문제 풀이하였습니다.***

##### A. 전체 사진 리스트를 가져올때, 특정 사용자가 리스팅된 사진을 스크랩 했는지를 함께 알 수 있는 SQL문 작성
```sql
SELECT
    DISTINCT c2.id,
    c2.image_url,
    u.nickname,
    IF(t.id IS NOT NULL, 'TRUE', 'FALSE') as `is_scrap`
FROM cards c2
    LEFT JOIN users u on u.id = c2.user_id
    LEFT JOIN (
        SELECT
            c1.id
        FROM cards c1
            LEFT JOIN scraps s on c1.id = s.card_id
            LEFT JOIN scrapbooks sb on s.scrapbook_id = sb.id
        WHERE sb.user_id = '[특정 사용자 ID]'
    ) t on c2.id = t.id;
```

##### B. 사진 리스트를 스크랩한 사용자 수에 대하여 내림차순으로 정렬 SQL문 작성
```sql
SELECT
    c.id,
    c.image_url,
    u.nickname,
    COUNT(s.card_id) AS `scrapper_count`
FROM cards c
LEFT JOIN users u on c.user_id = u.id
LEFT JOIN scraps s on c.id = s.card_id
GROUP BY s.card_id
ORDER BY scrapper_count DESC;
```

##### C. 특정 사용자의 스크랩북 리스트를 보여줄 때 각각 스크랩북의 대표 이미지와 스크랩 수를 함께 조회 SQL문 작성
```sql
SELECT
    t2.id,
    t2.title,
    t2.image_url,
    t2.scrap_count
FROM (
    SELECT
        *,
        COUNT(*) as `scrap_count`
    FROM (
        SELECT
            sb.*,
            c.image_url
        FROM scrapbooks sb
            LEFT JOIN scraps s on sb.id = s.scrapbook_id
            LEFT JOIN cards c on c.id = s.card_id
        WHERE
            sb.user_id = '[특정 사용자 ID]'
        ORDER BY sb.created_at DESC, s.created_at ASC, s.id DESC, c.id DESC
        LIMIT 18446744073709551615
    ) t1
    GROUP BY t1.id
) t2
ORDER BY t2.created_at DESC;
```

---

## SQL Query 문제_2
***SQL Query 문제는 `MySQL` 기준으로 문제 풀이하였습니다.***

##### A. 브랜드 별 상품 매출데이터(구매횟수, 구매금액) 조회 SQL문 작성
```sql
SELECT
    p.brand_name ,
    COUNT(*) AS `buy_count` ,
    SUM(p.cost * o.count) AS `buy_amount`
FROM orders o
    LEFT JOIN products p on p.id = o.product_id
GROUP BY p.brand_name;
```

##### B. 사용자 리스트를 구매 실적(누적구매횟수, 누적구매금액) 및 다음 등급을 보여주는 SQL문 작성
```sql
SELECT
    *,
    CASE
        WHEN `buy_count` >= 4 AND `buy_amount` >= 1000000 THEN 'Platinum'
        WHEN `buy_count` >= 3 AND `buy_amount` >= 500000 THEN 'VIP'
        WHEN `buy_count` >= 2 AND `buy_amount` >= 300000 THEN 'Friend'
        ELSE 'Normal'
    END AS `rating`
FROM (
    SELECT
        u.id,
        u.nickname,
        COUNT(o.user_id)      AS `buy_count`,
        SUM(p.cost * o.count) AS `buy_amount`
    FROM orders o
        LEFT JOIN users u on u.id = o.user_id
        LEFT JOIN products p on p.id = o.product_id
    WHERE DATE(o.created_at) >= (SELECT DATE(DATE_SUB(NOW(), INTERVAL 6 MONTH)) FROM dual)
    GROUP BY o.user_id
) AS t;
```

##### C. 특정 카테고리 Input이 주어질때 해당 카테고리의 매출데이터(누적구매횟수, 누적구매금액) 조회 SQL문 작성
```sql
SELECT
    COUNT(*) AS `buy_count`,
    SUM(p.cost * o.count) AS `buy_amount`
FROM (
    SELECT pc.product_id
    FROM categories c
        LEFT JOIN product_categories pc on c.id = pc.category_id
    WHERE c.first = '[메인 카테고리명]' AND c.second = '[서브 카테고리명]'
) pcc
    LEFT JOIN products p on p.id = pcc.product_id
    LEFT JOIN orders o on o.product_id = pcc.product_id;
```

##### D. 메인 카테고리 Input이 주어질때 해당 카테고리의 서브 카테고리별 매출데이터(누적구매횟수, 누적구매금액) 조회 SQL문 작성
```sql
SELECT
    p.name,
    COUNT(*) AS `buy_count`,
    SUM(p.cost * o.count) AS `buy_amount`
FROM (
    SELECT pc.product_id
    FROM categories c
        LEFT JOIN product_categories pc on c.id = pc.category_id
    WHERE first = '[메인 카테고리명]'
) pcc
    LEFT JOIN products p on p.id = pcc.product_id
    LEFT JOIN orders o on o.product_id = pcc.product_id
GROUP BY p.id;
```
<br>
----

## DB Modeling 문제
#### 2-1. 이미지 "modeling_1.png" 참고 부탁드립니다.
<iframe width="700" height="400" src='https://dbdiagram.io/embed/5f84182b3a78976d7b77425f'></iframe>

#### 2-1. 이미지 "modeling_2.png" 참고 부탁드립니다.
<iframe width="700" height="400" src='https://dbdiagram.io/embed/5f8424b13a78976d7b7745a4'> </iframe>
<br>

---

## 알고리즘 문제
***알고리즘 문제는 `Python` 언어로 문제 풀이하였습니다.***
### 문제1.
##### 2개의 배열에 있는 수를 한개 뽑아 곱하여 누적한 값들의 `최소 값` 구하기

#### Code
```python
def solution(a, b):
    answer = []

    for _ in range(len(a)):
        total = 0
        for i in list(map(lambda k: k[0] * k[1], zip(a, b))):
            total += i
        answer.append(total)

        # b array 왼쪽으로 shift
        b.append(b.pop(0))

    return min(answer)
```

<br>

### 문제2.
##### 개발자들의 팀대결 순서에 따른 `최대 승리 게임의 수` 정하기

#### Code
```python
def solution(a, b):
    answer = 0
    BEST = -1
    WORST = 0

    a.sort()
    b.sort()

    def get_least_rating(start, end):
        # a의 가장 쎈 상대를 이길 수 있는 선수 중에 가장 약한 선수 찾기
        # 이진 탐색 기법
        while start < end:
            mid = (start + end) // 2
            if b[mid] > a[BEST]:
                end = mid
            else:
                start = mid + 1
        return end

    while a:
        if a[BEST] >= b[BEST]:
            # a의 가장 쎈 선수의 상대에겐 무조건 b의 제일 약한 선수 매칭
            b.pop(WORST)
        else:
            # 현재 가장 약한 선수 찾기
            b_least_rating = get_least_rating(0, len(b) - 1)
            b.pop(b_least_rating)
            answer += 1
        a.pop(BEST)

    return answer
```

---

## 홈워크를 마치며 😃
이번 **버킷플레이스의 홈워크**를 진행하면서 부족한 부분을 많이 느끼고 다시 한번 공부하게 되는 좋은 계기가 되었습니다.<br>첫번째로, SQL Query 과제를 진행하면서,  개발한 Query의 `EXPLAIN` 명령어를 통해서 `Optimizer`의 실행 계획을 확인하여 Query 성능 최적화를 위해 수정을 거듭하게 되었고, 그로 인해 스스로 한단계 더 성장할 수 있던 시간이었습니다.<br>그리고, Database Modeling 과제를 통해서 확장성과 성능을 고려한 DB Table 구성은 어떤 방식으로 접근하고 설계해야 하는지 고민할 수 있었습니다.<br>마지막으로 알고리즘 과제를 진행하면서, 알고리즘 코딩에 적합한 `Python`의 내장함수를 활용하여 알고리즘 문제를 해결하고, 이진 탐색 알고리즘과 큐 자료구조에 대해 다시 한번 공부하고 구현해볼 수 있었던 재밌고 소중한 시간이었습니다.<br><br>아직 개발자로서 부족한 면이 많지만, 부족한만큼 남들보다 더 노력하고 성장할 수 있는 **버킷플레이스의 개발자**이자, 뜨거운 열정과 책임감을 가지고 항상 고객의 입장을 먼저 생각하고 고민하여 세상을 바꿀 수 있는 **버킷플레이스의 일원**이 되도록 하겠습니다. 감사합니다.
