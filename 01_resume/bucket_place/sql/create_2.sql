USE bucket_place;

-- products table
CREATE TABLE products
(
    id INT PRIMARY KEY AUTO_INCREMENT ,
    name VARCHAR(50) NOT NULL ,
    brand_name VARCHAR(50) NOT NULL ,
    cost INT NOT NULL
) ENGINE=INNODB DEFAULT CHARSET=utf8;

DESCRIBE products;

-- orders table
CREATE TABLE orders
(
    id INT PRIMARY KEY AUTO_INCREMENT ,
    user_id INT NOT NULL ,
    product_id INT NOT NULL ,
    count INT NOT NULL ,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (product_id) REFERENCES products (id)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

DESCRIBE orders;

-- categories table
CREATE TABLE categories
(
    id INT PRIMARY KEY AUTO_INCREMENT ,
    first VARCHAR(50) NOT NULL ,
    second VARCHAR(50) NOT NULL
) ENGINE=INNODB DEFAULT CHARSET=utf8;

DESCRIBE categories;

-- product_categories table
CREATE TABLE product_categories
(
    product_id INT NOT NULL ,
    category_id INT NOT NULL ,
    position INT NOT NULL ,
    FOREIGN KEY (product_id) REFERENCES products (id),
    FOREIGN KEY (category_id) REFERENCES categories (id)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

DESCRIBE product_categories;
