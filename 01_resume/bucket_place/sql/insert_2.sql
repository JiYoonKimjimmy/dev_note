use bucket_place;

show tables ;

-- products table
INSERT INTO products(name, brand_name, cost) VALUES ('이케아_의자', '이케아', 50000);
INSERT INTO products(name, brand_name, cost) VALUES ('이케아_책상', '이케아', 100000);
INSERT INTO products(name, brand_name, cost) VALUES ('이케아_침대', '이케아', 1000000);
INSERT INTO products(name, brand_name, cost) VALUES ('이케아_연필', '이케아', 1000);
INSERT INTO products(name, brand_name, cost) VALUES ('이케아_볼펜', '이케아', 2000);

INSERT INTO products(name, brand_name, cost) VALUES ('한샘_의자', '한샘', 100000);
INSERT INTO products(name, brand_name, cost) VALUES ('한샘_책상', '한샘', 200000);
INSERT INTO products(name, brand_name, cost) VALUES ('한샘_침대', '한샘', 2000000);
INSERT INTO products(name, brand_name, cost) VALUES ('한샘_식탁', '한샘',  500000);

SELECT * FROM products;

-- orders table
INSERT INTO orders(user_id, product_id, count) VALUES (1, 1, 2);
INSERT INTO orders(user_id, product_id, count) VALUES (1, 2, 1);
INSERT INTO orders(user_id, product_id, count) VALUES (1, 3, 1);

INSERT INTO orders(user_id, product_id, count) VALUES (2, 4, 20);
INSERT INTO orders(user_id, product_id, count) VALUES (2, 5, 10);
INSERT INTO orders(user_id, product_id, count) VALUES (2, 6, 1);
INSERT INTO orders(user_id, product_id, count) VALUES (2, 7, 1);

INSERT INTO orders(user_id, product_id, count) VALUES (3, 6, 4);
INSERT INTO orders(user_id, product_id, count) VALUES (3, 7, 1);
INSERT INTO orders(user_id, product_id, count) VALUES (3, 8, 1);
INSERT INTO orders(user_id, product_id, count) VALUES (3, 9, 1);

SELECT * FROM orders;

-- categories table
INSERT INTO categories(first, second) VALUES ('가구', '의자');
INSERT INTO categories(first, second) VALUES ('가구', '책상');
INSERT INTO categories(first, second) VALUES ('가구', '침대');
INSERT INTO categories(first, second) VALUES ('가구', '식탁');

INSERT INTO categories(first, second) VALUES ('필기구', '연필');
INSERT INTO categories(first, second) VALUES ('필기구', '볼펜');

SELECT * FROM categories;

-- product_categories
INSERT INTO product_categories(product_id, category_id, position) VALUES (1, 1, 1);
INSERT INTO product_categories(product_id, category_id, position) VALUES (2, 2, 2);
INSERT INTO product_categories(product_id, category_id, position) VALUES (3, 3, 3);
INSERT INTO product_categories(product_id, category_id, position) VALUES (4, 5, 1);
INSERT INTO product_categories(product_id, category_id, position) VALUES (5, 6, 2);
INSERT INTO product_categories(product_id, category_id, position) VALUES (6, 1, 1);
INSERT INTO product_categories(product_id, category_id, position) VALUES (7, 2, 2);
INSERT INTO product_categories(product_id, category_id, position) VALUES (8, 3, 3);
INSERT INTO product_categories(product_id, category_id, position) VALUES (9, 4, 4);

SELECT * FROM product_categories;
