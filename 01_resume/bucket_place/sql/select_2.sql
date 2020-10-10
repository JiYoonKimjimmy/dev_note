SELECT * FROM users;
SELECT * FROM products;
SELECT * FROM orders;

-- A. 브랜드 별 상품 매출데이터(구매횟수, 구매금액) 조회 SQL 문 작성
SELECT
    p.brand_name ,
    COUNT(*) AS `buy_count` ,
    SUM(p.cost * o.count) AS `buy_amount`
FROM orders o
LEFT JOIN products p on p.id = o.product_id
GROUP BY p.brand_name;

-- B. 사용자 리스트를 구매 실적(누적구매횟수, 누적구매금액) 및 다음 등급을 보여주는 SQL 문 작성
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

-- C. 특정 카테고리 Input이 주어질때 해당 카테고리의 매출데이터(누적구매횟수, 누적구매금액) 조회 SQL 문 작성
SELECT
    COUNT(*) AS `buy_count`,
    SUM(p.cost * o.count) AS `buy_amount`
FROM (
    SELECT pc.product_id
    FROM categories c
        LEFT JOIN product_categories pc on c.id = pc.category_id
    WHERE first = '필기구' AND second = '연필'
) pcc
    LEFT JOIN products p on p.id = pcc.product_id
    LEFT JOIN orders o on o.product_id = pcc.product_id;

-- D. 메인 카테고리 Input이 주어질때 해당 카테고리의 서브 카테고리별 매출데이터(누적구매횟수, 누적구매금액) 조회 SQL 문 작성
SELECT
    p.name,
    COUNT(*) AS `buy_count`,
    SUM(p.cost * o.count) AS `buy_amount`
FROM (
    SELECT pc.product_id
    FROM categories c
        LEFT JOIN product_categories pc on c.id = pc.category_id
    WHERE first = '가구'
) pcc
    LEFT JOIN products p on p.id = pcc.product_id
    LEFT JOIN orders o on o.product_id = pcc.product_id
GROUP BY p.id;
