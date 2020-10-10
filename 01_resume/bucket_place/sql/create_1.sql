USE bucket_place;

-- users table
CREATE TABLE users
(
    id INT PRIMARY KEY AUTO_INCREMENT ,
    email VARCHAR(50) NOT NULL ,
    nickname VARCHAR(10) NOT NULL
) ENGINE=INNODB DEFAULT CHARSET=utf8;

DESCRIBE  users;

DROP TABLE users;

-- scrapbooks table
CREATE TABLE scrapbooks
(
    id INT PRIMARY KEY AUTO_INCREMENT ,
    user_id INT NOT NULL,
    title VARCHAR(50) NOT NULL ,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

DESCRIBE  scrapbooks;

-- cards table
CREATE TABLE cards
(
    id INT PRIMARY KEY AUTO_INCREMENT ,
    user_id INT NOT NULL,
    image_url VARCHAR(50) NOT NULL ,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

DESCRIBE  cards;

-- scraps table
CREATE TABLE scraps
(
    id INT PRIMARY KEY AUTO_INCREMENT ,
    scrapbook_id INT NOT NULL,
    card_id INT NOT NULL ,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (scrapbook_id) REFERENCES scrapbooks (id),
    FOREIGN KEY (card_id) REFERENCES cards (id)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

DESCRIBE  scraps;
