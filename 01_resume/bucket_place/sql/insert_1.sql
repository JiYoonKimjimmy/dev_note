show tables ;

-- users table
INSERT INTO users(email, nickname) VALUES ('user1@test.com', 'user1');
INSERT INTO users(email, nickname) VALUES ('user2@test.com', 'user2');
INSERT INTO users(email, nickname) VALUES ('user3@test.com', 'user3');
INSERT INTO users(email, nickname) VALUES ('user4@test.com', 'user4');
INSERT INTO users(email, nickname) VALUES ('user5@test.com', 'user5');

SELECT * FROM users;

-- scrapbooks table
INSERT INTO scrapbooks(user_id, title) VALUES (1, 'user1\'s book1');
INSERT INTO scrapbooks(user_id, title) VALUES (1, 'user1\'s book2');
INSERT INTO scrapbooks(user_id, title) VALUES (2, 'user2\'s book1');
INSERT INTO scrapbooks(user_id, title) VALUES (3, 'user3\'s book1');
INSERT INTO scrapbooks(user_id, title) VALUES (4, 'user4\'s book1');
INSERT INTO scrapbooks(user_id, title) VALUES (5, 'user5\'s book1');

SELECT * FROM scrapbooks;

-- cards table
INSERT INTO cards(user_id, image_url) VALUES (1, 'user1\'image1.jpg');
INSERT INTO cards(user_id, image_url) VALUES (1, 'user1\'image2.jpg');
INSERT INTO cards(user_id, image_url) VALUES (2, 'user2\'image1.jpg');
INSERT INTO cards(user_id, image_url) VALUES (3, 'user3\'image1.jpg');
INSERT INTO cards(user_id, image_url) VALUES (4, 'user4\'image1.jpg');
INSERT INTO cards(user_id, image_url) VALUES (5, 'user5\'image1.jpg');
INSERT INTO cards(user_id, image_url) VALUES (5, 'user5\'image2.jpg');
INSERT INTO cards(user_id, image_url) VALUES (5, 'user5\'image3.jpg');

SELECT * FROM cards;

-- scraps table
INSERT INTO scraps(scrapbook_id, card_id) VALUES (1, 1);
INSERT INTO scraps(scrapbook_id, card_id) VALUES (1, 2);
INSERT INTO scraps(scrapbook_id, card_id) VALUES (1, 3);
INSERT INTO scraps(scrapbook_id, card_id) VALUES (1, 4);
INSERT INTO scraps(scrapbook_id, card_id) VALUES (1, 5);
INSERT INTO scraps(scrapbook_id, card_id) VALUES (1, 6);
INSERT INTO scraps(scrapbook_id, card_id) VALUES (1, 7);
INSERT INTO scraps(scrapbook_id, card_id) VALUES (1, 8);

INSERT INTO scraps(scrapbook_id, card_id) VALUES (2, 1);
INSERT INTO scraps(scrapbook_id, card_id) VALUES (2, 2);
INSERT INTO scraps(scrapbook_id, card_id) VALUES (2, 3);
INSERT INTO scraps(scrapbook_id, card_id) VALUES (2, 4);
INSERT INTO scraps(scrapbook_id, card_id) VALUES (2, 5);
INSERT INTO scraps(scrapbook_id, card_id) VALUES (2, 6);

INSERT INTO scraps(scrapbook_id, card_id) VALUES (3, 3);
INSERT INTO scraps(scrapbook_id, card_id) VALUES (3, 4);
INSERT INTO scraps(scrapbook_id, card_id) VALUES (3, 5);
INSERT INTO scraps(scrapbook_id, card_id) VALUES (3, 6);

INSERT INTO scraps(scrapbook_id, card_id) VALUES (4, 4);
INSERT INTO scraps(scrapbook_id, card_id) VALUES (4, 5);
INSERT INTO scraps(scrapbook_id, card_id) VALUES (4, 6);
INSERT INTO scraps(scrapbook_id, card_id) VALUES (4, 1);
INSERT INTO scraps(scrapbook_id, card_id) VALUES (4, 2);
INSERT INTO scraps(scrapbook_id, card_id) VALUES (4, 7);

INSERT INTO scraps(scrapbook_id, card_id) VALUES (5, 5);
INSERT INTO scraps(scrapbook_id, card_id) VALUES (5, 6);
INSERT INTO scraps(scrapbook_id, card_id) VALUES (5, 1);
INSERT INTO scraps(scrapbook_id, card_id) VALUES (5, 2);
INSERT INTO scraps(scrapbook_id, card_id) VALUES (5, 7);

INSERT INTO scraps(scrapbook_id, card_id) VALUES (6, 6);
INSERT INTO scraps(scrapbook_id, card_id) VALUES (6, 1);

SELECT * FROM scraps;

delete from scraps where scrapbook_id = 5;
