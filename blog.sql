--DROP DATABASE IF EXISTS Blog;
IF NOT EXISTS
(
SELECT name FROM master.dbo.sysdatabases
WHERE name = 'Blog'
)
CREATE DATABASE Blog;
GO
USE Blog;

-----------------------------------------
--Drop all foreign keys if exists
-----------------------------------------
IF EXISTS (SELECT name FROM sys.tables
WHERE name = 'article_comments')
	ALTER TABLE article_comments DROP CONSTRAINT IF EXISTS fk_ac_article_id;

IF EXISTS (SELECT name FROM sys.tables
WHERE name = 'article_comments')
	ALTER TABLE article_comments DROP CONSTRAINT IF EXISTS fk_ac_comment_id;

IF EXISTS (SELECT name FROM sys.tables
WHERE name = 'comments')
	ALTER TABLE comments DROP CONSTRAINT IF EXISTS fk_comments_comment_id;

IF EXISTS (SELECT name FROM sys.tables
WHERE name = 'articles')
	ALTER TABLE articles DROP CONSTRAINT IF EXISTS fk_articles_user_id;
-----------------------------------------
--Articles
-----------------------------------------
DROP TABLE IF EXISTS articles;

CREATE TABLE articles(
	id INT IDENTITY(1,1) NOT NULL,
	create_date DATE DEFAULT(GETDATE()),
	heading VARCHAR(128),
	content	VARCHAR(1000),
	user_id INT
);
-----------------------------------------
--Comments
-----------------------------------------
DROP TABLE IF EXISTS comments;

CREATE TABLE comments(
	id INT IDENTITY(1,1) NOT NULL,
	create_date DATE DEFAULT(GETDATE()),
	comment VARCHAR(1000),
	user_id INT,
	prev_comment INT
);
-----------------------------------------
--Comments
-----------------------------------------
DROP TABLE IF EXISTS users;

CREATE TABLE users(
	id INT IDENTITY(1,1) NOT NULL,
	username VARCHAR(64),
	email VARCHAR(64),
	create_date DATE DEFAULT(GETDATE())
);
-----------------------------------------
--Table connecting artcles & comments
-----------------------------------------
DROP TABLE IF EXISTS article_comments;

CREATE TABLE article_comments(
	article_id INT NOT NULL,
	comment_id INT NOT NULL
);
-----------------------------------------
--Assign primary keys
-----------------------------------------
ALTER TABLE articles
ADD CONSTRAINT pk_articles_id PRIMARY KEY (id);

ALTER TABLE comments
ADD CONSTRAINT pk_comments_id PRIMARY KEY (id);

ALTER TABLE users
ADD CONSTRAINT pk_users_id PRIMARY KEY (id);
-----------------------------------------
--Assign foreign keys
-----------------------------------------
ALTER TABLE articles
ADD CONSTRAINT fk_articles_user_id FOREIGN KEY (user_id) REFERENCES users (id);

ALTER TABLE article_comments
ADD CONSTRAINT fk_ac_article_id FOREIGN KEY (article_id) REFERENCES articles (id);

ALTER TABLE article_comments
ADD CONSTRAINT fk_ac_comment_id FOREIGN KEY (comment_id) REFERENCES comments (id);

ALTER TABLE comments
ADD CONSTRAINT fk_comments_comment_id FOREIGN KEY (prev_comment) REFERENCES comments (id);
-----------------------------------------
--Insert values
-----------------------------------------
INSERT INTO users (username, email)
VALUES ('user1', 'user1@gmail.com')

INSERT INTO users (username, email)
VALUES ('user2', 'user2@gmail.com')

INSERT INTO users (username, email)
VALUES ('user3', 'user3@gmail.com')
-----------------------------------------
INSERT INTO articles (heading, content, user_id)
VALUES ('header1', 'content1', '1')

INSERT INTO articles (heading, content, user_id)
VALUES ('header2', 'content2', '3')
-----------------------------------------
INSERT INTO comments (comment, user_id)
VALUES ('comment1', '1')

INSERT INTO comments (comment, user_id, prev_comment)
VALUES ('comment2', '2', '1')
-----------------------------------------
INSERT INTO article_comments(article_id, comment_id)
VALUES ('1', '1')

/*
select * from users
select * from articles
select * from comments
select * from article_comments
*/