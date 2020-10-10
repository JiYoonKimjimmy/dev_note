# 버킷플레이스 과제 제출

> **목차**
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
    c.id,
    c.image_url,
    u.nickname,
    (
        IF ((SELECT EXISTS(

            SELECT
                s.card_id,
                sb.user_id
            FROM scraps s
                RIGHT JOIN scrapbooks sb on s.scrapbook_id = sb.id
            WHERE sb.user_id in ('[특정 사용자 ID]')
            and s.card_id = c.id
        )) = 0, 'FALSE', 'TRUE')
    ) AS `is_scrap`
FROM cards c
LEFT JOIN users u on c.user_id = u.id;
```

##### B. 사진 리스트를 스크랩한 사용자 수에 대하여 내림차순으로 정렬 SQL문 작성
```sql
SELECT
    c.id,
    c.image_url,
    u.nickname,
    s.scrapper_count
FROM cards c
LEFT JOIN
(
    SELECT
      card_id,
      COUNT(card_id) AS `scrapper_count`
    FROM scraps
    GROUP BY card_id
) s
on c.id = s.card_id
LEFT JOIN users u
on c.user_id = u.id
ORDER BY s.scrapper_count DESC;
```

##### C. 특정 사용자의 스크랩북 리스트를 보여줄 때 각각 스크랩북의 대표 이미지와 스크랩 수를 함께 조회 SQL문 작성
```sql
SELECT
    sb.id,
    sb.title,
    (
        SELECT
            c.image_url
        FROM scraps s
            LEFT JOIN cards c on c.id = s.card_id
        WHERE s.scrapbook_id = sb.id
        ORDER BY s.created_at ASC, s.id DESC, c.id DESC
        LIMIT 1
    ) AS `image_url`,
    s.scrap_count
FROM scrapbooks sb
LEFT JOIN
(
    SELECT
      scrapbook_id, card_id,
      COUNT(scrapbook_id) AS `scrap_count`
    FROM scraps
    GROUP BY scrapbook_id
) s
on sb.id = s.scrapbook_id
WHERE sb.user_id in ('[특정 사용자 ID]')
ORDER BY sb.created_at DESC;
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

----

## DB Modeling 문제
#### 2-1.

#### 2-2.


---

## 알고리즘 문제
***알고리즘 문제는 `Python` 언어로 문제 풀이하였습니다.***
#### 문제1.
##### 2개의 배열에 있는 수를 한개 뽑아 곱하여 누적한 값들의 `최소 값` 구하기
##### 풀이 방법
1. 2개의 배열의 같은 위치에 있는 2개의 수들의 곱셈
2. 곱셈 처리한 값을 누적하여 저장
3. 두번째 배열을 왼쪽으로 `shift` 하면서 배열 크기만큼 `1번, 2번` 반복
4. 누적된 값 중 `최소 값`을 반환

##### Code
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
#### 문제2.
##### 개발자들의 팀대결 순서에 따른 `최대 승리 게임의 수` 정하기
##### 풀이 방법
1. `프론트` 팀의 제일 강한 선수에겐 무조건 `백엔드` 팀의 제일 약한 선수를 배정
2. `백엔드` 팀에서 `프론트` 팀 강한 선수 순서대로 이길 수 있는 제일 약한 선수를 찾아 배정
3. `백엔드` 팀이 승리하는 경우에 `승리 게임의 수 + 1` 처리

##### Code
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
