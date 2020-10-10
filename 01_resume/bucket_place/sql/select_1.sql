SELECT * FROM users;
SELECT * FROM scrapbooks;
SELECT * FROM cards;
SELECT * FROM scraps;

-- A. 전체 사진 리스트를 가져올때,
-- 특정 사용자가 리스팅된 사진을 스크랩 했는지를 함께 알 수 있는 SQL 문 작성
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
            RIGHT JOIN scrapbooks sb ON s.scrapbook_id = sb.id
            WHERE sb.user_id in (4)
            and s.card_id = c.id
        )) = 0, 'FALSE', 'TRUE')
    ) as `is_scrap`
FROM cards c
LEFT JOIN users u ON c.user_id = u.id;

-- B. 사진 리스트를 스크랩한 사용자 수에 대하여 내림차순으로 정렬 SQL 문 작성
SELECT
    c.id,
    c.image_url,
    u.nickname,
    s.scrapper_count
FROM cards c
LEFT JOIN
(
    SELECT card_id, COUNT(card_id) as `scrapper_count`
    FROM scraps
    GROUP BY card_id
) s
ON c.id = s.card_id
LEFT JOIN users u
ON c.user_id = u.id
ORDER BY s.scrapper_count DESC;

-- C. 특정 사용자의 스크랩북 리스트를 보여줄 때,
-- 각각 스크랩북의 대표 이미지와 스크랩 수를 함께 조회 SQL 문 작성
SELECT
    sb.id,
    sb.title,
    (
        SELECT
            c.image_url
        FROM scraps s
        LEFT JOIN cards c ON c.id = s.card_id
        WHERE s.scrapbook_id = sb.id
        ORDER BY s.created_at ASC, s.id DESC, c.id DESC
        LIMIT 1
    ) as `image_url`,
    s.scrap_count
FROM scrapbooks sb
LEFT JOIN
(
    SELECT scrapbook_id, card_id, COUNT(scrapbook_id) as `scrap_count`
    FROM scraps
    GROUP BY scrapbook_id
) s
ON sb.id = s.scrapbook_id
WHERE sb.user_id in (4)
ORDER BY sb.created_at DESC;
