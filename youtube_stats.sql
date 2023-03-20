-- clean the datasets

-- change the date format at the published_at column
UPDATE `video_stats` SET `published_at` = STR_TO_DATE(`published_at`, '%m/%d/%Y');
ALTER TABLE `video_stats` CHANGE COLUMN `published_at` `published_at` DATE;

-- change the data type 
ALTER TABLE `youtube`.`video_stats` 
CHANGE COLUMN `likes` `likes` INT NULL DEFAULT NULL;
ALTER TABLE `youtube`.`video_stats` 
CHANGE COLUMN `comments` `comments` INT NULL DEFAULT NULL, 
CHANGE COLUMN `views` `views` INT NULL DEFAULT NULL;

-- check for empty and null values
SELECT * FROM video_stats
WHERE sno IS NULL;

SELECT * FROM video_stats
WHERE title IS NULL;

SELECT * FROM video_stats
WHERE video_id IS NULL;

SELECT * FROM video_stats
WHERE published_at IS NULL;

SELECT * FROM video_stats
WHERE keyword IS NULL;

SELECT * FROM video_stats
WHERE likes IS NULL;

SELECT * FROM video_stats
WHERE comments IS NULL;

SELECT * FROM video_stats
WHERE views IS NULL;

SELECT * FROM video_stats
WHERE sno = '';
SELECT * FROM video_stats
WHERE title = '';

SELECT * FROM video_stats
WHERE video_id = '';

SELECT * FROM video_stats
WHERE published_at = '';

SELECT * FROM video_stats
WHERE keyword = '';

SELECT * FROM video_stats
WHERE likes = '';

SELECT * FROM video_stats
WHERE comments = '';

SELECT * FROM video_stats
WHERE views = '';


-- drop empty values
DELETE FROM video_stats
WHERE likes = '';

-- identify inconsistent values 
SELECT *
FROM video_stats 
WHERE video_id LIKE '#%';

-- remove inconsistent values
DELETE FROM video_stats
WHERE video_id LIKE '#%';

DELETE FROM comments
WHERE video_id LIKE '#%';



-- perform EDA

-- What is the most commented-upon videos? the most liked?
SELECT 
	video_id,
    title,
    comments,
    likes
FROM video_stats
ORDER BY 3 DESC, 4 DESC;


-- What is the most viewed video ?
SELECT 
	video_id,
	title,
    views
FROM video_stats
ORDER BY 3 DESC
LIMIT 1;


-- What is the total number of views,likes and comments for each category?
SELECT
	keyword AS category,
    SUM(views) AS total_views,
    SUM(likes) AS total_likes,
    SUM(comments) AS total_comments
FROM video_stats
GROUP BY category;

    
-- What are the most-liked comments?
SELECT 
	video_id,
    comments,
    likes
FROM comments
ORDER BY 3 DESC
LIMIT 1;


-- What is the ratio of views/likes per category?
SELECT
keyword AS category,
    (views/likes) as views_per_category
FROM video_stats
GROUP BY category;


-- What is the average sentiment score in each keyword category for a comment?
SELECT
	v.keyword,
    AVG(c.sentiment) AS avg_sentiment_score
FROM comments c
JOIN video_stats v
USING(video_id)
GROUP BY v.keyword;



-- What is the oldest and most recent video posted
SELECT
	video_id,
    title,
    published_at
FROM video_stats
WHERE published_at = (SELECT
							MIN(published_at) 
                            FROM video_stats);


SELECT
	video_id,
    title,
    published_at
FROM video_stats
WHERE published_at = (SELECT
						 MAX(published_at) 
					  FROM video_stats);
           
           

-- What is the comment with the most likes
SELECT 
	video_id,
	comments,
    likes
FROM comments
WHERE likes = (SELECT
					 MAX(likes)
				FROM comments);
                        
    
