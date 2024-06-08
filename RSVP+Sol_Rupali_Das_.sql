USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT COUNT(*) FROM DIRECTOR_MAPPING;
SELECT COUNT(*) FROM GENRE;
SELECT COUNT(*) FROM MOVIE;
SELECT COUNT(*) FROM NAMES;
SELECT COUNT(*) FROM RATINGS;
SELECT COUNT(*) FROM ROLE_MAPPING;

/*
   Method Used: COUNT Function used to get total number of records in the table
   Observations:
      - DIRECTOR_MAPPING has 3867 rows
      - GENRE has 14662 rows
      - MOVIE has 7997 rows
      - NAMES has 25735 rows
      - RATINGS has 7997 rows
      - ROLE_MAPPINGS has 15615 rows
*/






-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT SUM(CASE WHEN ID IS NULL THEN 1 ELSE 0 END) AS id_nulls, 
       SUM(CASE WHEN TITLE IS NULL THEN 1 ELSE 0 END) AS title_nulls, 
       SUM(CASE WHEN YEAR IS NULL THEN 1 ELSE 0 END) AS year_nulls, 
       SUM(CASE WHEN DATE_PUBLISHED IS NULL THEN 1 ELSE 0 END) AS date_pub_nulls, 
       SUM(CASE WHEN DURATION IS NULL THEN 1 ELSE 0 END) AS duration_nulls, 
       SUM(CASE WHEN COUNTRY IS NULL THEN 1 ELSE 0 END) AS country_nulls, 
       SUM(CASE WHEN WORLWIDE_GROSS_INCOME IS NULL THEN 1 ELSE 0 END) AS worldwide_income_nulls, 
       SUM(CASE WHEN LANGUAGES IS NULL THEN 1 ELSE 0 END) AS language_nulls, 
       SUM(CASE WHEN PRODUCTION_COMPANY IS NULL THEN 1 ELSE 0 END) AS prod_company_nulls 
FROM MOVIE;

/*
   Method Used: Conditional Aggregation with SUM and CASE statements
   Observations:
      - The columns COUNTRY, WORLDWIDE_GROSS_INCOME, LANGUAGES, and PRODUCTION_COMPANY contain NULL values.
*/





-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT YEAR, 
       COUNT(TITLE) AS NUMBER_OF_MOVIES 
FROM MOVIE 
GROUP BY YEAR;

SELECT MONTH(DATE_PUBLISHED) AS MONTH_NUM,
       COUNT(*) AS NUMBER_OF_MOVIES
FROM MOVIE
GROUP BY MONTH_NUM
ORDER BY MONTH_NUM; 

/*
   Method Used: Using GROUP BY for counting movies by year and ORDER BY for trend analysis.
   Observations:
      - The data suggests that the highest number of movies were produced in 2017.
      - Over the past three years, there has been a noticeable increasing trend in movie production annually.
      - The highest movies are produced in the Month of March
*/



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT COUNT(*) AS NUMBER_OF_MOVIES
FROM MOVIE
WHERE YEAR = 2019
      AND (COUNTRY LIKE '%USA%' OR COUNTRY LIKE '%India%');

/*
   Method Used: Filtering data using WHERE clause
   Observations:
      - In 2019, a total of 1059 movies were produced in the USA or India.
*/



/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT(GENRE) AS LIST_OF_THE_GENRES FROM GENRE;

/*
   Method Used: Using DISTINCT to obtain a unique list of genres.
   Observations:
      - The database contains movies categorized into 13 distinct genres.
*/








/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT GENRE,
	  COUNT(M.ID) AS TOTAL_MOVIES
FROM GENRE G
	  INNER JOIN MOVIE M ON G.MOVIE_ID = M.ID
GROUP BY GENRE
ORDER BY TOTAL_MOVIES DESC LIMIT 1; 

/*
   Method Used:
      - Utilized an INNER JOIN operation between the GENRE table and MOVIE table to correlate movies with their genres. 
   Observations:
      - The data suggests that the 'Drama' genre has the highest count of associated movies.
      - A total of 4285 movies were produced under the 'Drama' genre.
*/



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

SELECT COUNT(*) AS COUNT_OF_MOVIES_WITH_ONE_GENRE
FROM (
    SELECT COUNT(GENRE) AS GENRE_COUNT
    FROM GENRE
    GROUP BY MOVIE_ID
    HAVING GENRE_COUNT = 1
) AS SINGLE_GENRE_TABLE;

/*
   Method Used: 
      - Using inner query to group the genres by movie ID and count the number of genres associated with each movie.
      - HAVING clause to filter those movies having exactly one genre associated.
      - Using outer query to then count the number of movies from the filtered result set.
   Observations:
      - There are 3285 movies associated with only one genre.
*/

 






/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT GENRE,AVG(M.DURATION) AS AVG_DURATION 
FROM GENRE G
	INNER JOIN MOVIE M ON M.ID=G.MOVIE_ID
GROUP BY GENRE
ORDER BY AVG_DURATION DESC;

/*
   Method Used: 
   - Utilized an INNER JOIN between the GENRE table and MOVIE table to associate movies with their genres.
   - Applied an aggregate function AVG() to compute the average duration of movies for each genre.
   - Grouped the results by genre and ordered them in descending order based on the average duration.
   Observations:
      - The 'Action' genre movies have the highest average duration of 112.8829 minutes.
      - 'Drama' genre movies, which had the highest production count in 2019, have an average duration of 106.77 minutes.
*/






/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH GENRE_SUB_TABLE AS (
   SELECT GENRE, 
      COUNT(MOVIE_ID) AS MOVIE_COUNT, 
	  RANK() OVER (ORDER BY COUNT(MOVIE_ID) DESC) AS GENRE_RANK 
   FROM GENRE
   GROUP BY GENRE)
SELECT * FROM GENRE_SUB_TABLE WHERE GENRE='THRILLER';

/*
   Method Used:
   - Created a CTE using the WITH clause.
   - Using the RANK() window function for ordering genres by the count of associated movies in descending order.
   - The main query selects data from the CTE specifically for the 'Thriller' genre.
   Observations:
      - Its rank is 3 based on the count of movies associated with the 'Thriller' genre.
*/







/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|max_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT 
    MIN(AVG_RATING) AS MIN_AVG_RATING,
    MAX(AVG_RATING) AS MAX_AVG_RATING,
    MIN(TOTAL_VOTES) AS MIN_TOTAL_VOTES,
    MAX(TOTAL_VOTES) AS MAX_TOTAL_VOTES,
    MIN(MEDIAN_RATING) AS MIN_MEDIAN_RATING,
    MAX(MEDIAN_RATING) AS MAX_MEDIAN_RATING
FROM RATINGS;
 
/*
   Method Used:
      - Aggregating methods like min and max values for the respective columns
   Observations:
      - Avg rating is between 1-10
      - Total Movies vary between 100-725138
      - Median rating varies from 1-10
*/


    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT TITLE, 
      AVG_RATING, 
      DENSE_RANK() OVER (ORDER BY AVG_RATING DESC) AS MOVIE_RANK
FROM RATINGS R
INNER JOIN MOVIE M ON M.ID=R.MOVIE_ID
LIMIT 10;

/*
   Method Used:
      - Using an INNER JOIN between the RATINGS table and MOVIE table
      - Using DENSE_RANK() to rank the movies based on avg rating.      
   Observations:
      - Kirket Movie has topped the AVG RATING with 10.
      - Top 10 movies have avg rating greater than 9
*/






/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT MEDIAN_RATING, 
      COUNT(MOVIE_ID) AS MOVIE_COUNT
FROM RATINGS
GROUP BY MEDIAN_RATING
ORDER BY MOVIE_COUNT DESC;

/*
   Method Used:
      - Utilized GROUP BY to count movies according to their median rating and implemented ORDER BY for trend analysis.
   Observations:
      - The majority of movies have a median rating of 7.
      - A significant number of movies fall within the median rating range of 6 to 8.
*/





/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
WITH SUB_PROD_HOUSE_TABLE AS (
    SELECT 
        PRODUCTION_COMPANY,
        COUNT(M.ID) AS MOVIE_COUNT,
        DENSE_RANK() OVER (ORDER BY COUNT(M.ID) DESC) AS PROD_COMPANY_RANK
    FROM MOVIE M 
    INNER JOIN RATINGS R ON R.MOVIE_ID = M.ID
    WHERE AVG_RATING > 8 
          AND PRODUCTION_COMPANY IS NOT NULL
    GROUP BY PRODUCTION_COMPANY
    ORDER BY MOVIE_COUNT DESC
)
SELECT * 
FROM SUB_PROD_HOUSE_TABLE 
WHERE PROD_COMPANY_RANK = 1;

/*
   Method Used:
      - Using CTE with WITH clause.
      - Inner Join the MOVIE and RATINGS tables and filter movies with an average rating greater than 8.
      - Assigned a ranking using the DENSE_RANK() window function.
      - The main query selects data from the CTE for the production companies which are ranked as number one.
   Observations:
      - Dream Warrior Pictures and National Theatre Live are the top-ranked production houses, having produced the highest number of highly-rated movies (with an average rating greater than 8).
*/



-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT GENRE,COUNT(M.ID) AS MOVIE_COUNT
FROM MOVIE M
INNER JOIN GENRE G ON G.MOVIE_ID=M.ID
INNER JOIN RATINGS R ON R.MOVIE_ID=M.ID
WHERE YEAR = 2017 
      AND MONTH(DATE_PUBLISHED)=3 
      AND COUNTRY LIKE '%USA%' 
      AND TOTAL_VOTES > 1000
GROUP BY GENRE
ORDER BY MOVIE_COUNT DESC;

/*
   Method Used:
      - Using INNER JOIN and GROUP BY, ORDERBY functions to join multiple tables and filter data based on genre.
      - Using where clause to filter the data based on country, total votes, year and month.
   Observations:
      - Based on March 2017 data, the highest number of movies produced belong to the Drama genre.
      - In contrast, the Family genre exhibits the lowest count of movies produced during March 2017.
*/






-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT TITLE,AVG_RATING,GENRE
FROM MOVIE M
    INNER JOIN RATINGS R ON R.MOVIE_ID=M.ID
    INNER JOIN GENRE G ON G.MOVIE_ID=M.ID
WHERE TITLE LIKE 'THE%' 
     AND AVG_RATING > 8
ORDER BY AVG_RATING DESC;

/*
   Method Used:
      - Using INNER JOIN and ORDER BY functions to join multiple tables and filter data based on AVG Rating.
      - Using where clause to filter the data on Avg rating and title pattern match
   Observations:
      - The data rates 'The Brighton Miracle' movie on top with Avg rating 9.5.
      - All movies listed have an average rating greater than 8      
*/





-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT COUNT(M.ID) AS MOVIES_WITH_MEDIAN_RATING_8
FROM MOVIE M
    INNER JOIN RATINGS R ON R.MOVIE_ID=M.ID
WHERE MEDIAN_RATING=8 
     AND DATE_PUBLISHED BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY MEDIAN_RATING;

/*
   Method Used:
      - Using INNER JOIN to join Movie and Ratings tables and filter data based on Median Rating.
      - Using where clause to filter the data based on time frame and median rating > 8.
   Observations:
      - There are 361 movies with median rating greater than eqaul to 8 published between April 2018-April 2019 
*/






-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT COUNT(M.ID) AS MOVIE_COUNT, 
       COUNTRY, 
       SUM(TOTAL_VOTES) AS VOTE_COUNT
FROM MOVIE M
    INNER JOIN RATINGS R ON R.MOVIE_ID=M.ID
WHERE (COUNTRY LIKE '%GERMAN%' OR COUNTRY LIKE '%ITALY%')
GROUP BY COUNTRY;

/*
   Method Used:
      - Using INNER JOIN to join Movie and Ratings tables and filter data based on Total votes.
      - Using where clause to filter the data based on country.
   Observations:
      - Yes, German movies get more votes than Italian movies as per the data.
*/




-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT SUM(CASE WHEN ID IS NULL THEN 1 ELSE 0 END) AS ID_NULLS, 
       SUM(CASE WHEN NAME IS NULL THEN 1 ELSE 0 END) AS NAME_NULLS, 
       SUM(CASE WHEN HEIGHT IS NULL THEN 1 ELSE 0 END) AS HEIGHT_NULLS, 
       SUM(CASE WHEN DATE_OF_BIRTH IS NULL THEN 1 ELSE 0 END) AS DATE_OF_BIRTH_NULLS, 
       SUM(CASE WHEN KNOWN_FOR_MOVIES IS NULL THEN 1 ELSE 0 END) AS KNOWN_FOR_MOVIES_NULLS
FROM NAMES;

/*
   Method Used: Conditional Aggregation with SUM and CASE statements
   Observations:
      - The columns HEIGHT, DATE_OF_BIRTH, and KNOWN_FOR_MOVIES contain NULL values.
      - No NUll values found in NAME and ID Columns
*/




/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH GENRE_SUB_TABLE AS (
    SELECT GENRE,
        COUNT(M.ID) AS MOVIE_COUNT,
        DENSE_RANK() OVER (ORDER BY COUNT(M.ID) DESC) AS GENRE_RANK
    FROM MOVIE M
        INNER JOIN GENRE G ON G.MOVIE_ID = M.ID
        INNER JOIN RATINGS R ON R.MOVIE_ID = M.ID
    WHERE AVG_RATING > 8
    GROUP BY GENRE
    LIMIT 3
)
SELECT N.NAME AS DIRECTOR_NAME, COUNT(D.MOVIE_ID) AS MOVIE_COUNT
FROM DIRECTOR_MAPPING D
	INNER JOIN GENRE G USING (MOVIE_ID)
    INNER JOIN NAMES N ON N.ID=D.NAME_ID
    INNER JOIN GENRE_SUB_TABLE USING (GENRE)
    INNER JOIN RATINGS USING (MOVIE_ID)
WHERE AVG_RATING > 8
GROUP BY NAME
ORDER BY MOVIE_COUNT DESC LIMIT 3;

/*
   Method Used:
      - The CTE GENRE_SUB_TABLE selects the top three genres with the highest movie count and an average rating greater than 8.
      - The main query then finds directors associated with these genres
      - Directors are ranked by the count of movies within these top genres and ratings.
   Observations:
      - James Mangold, Anthony Russo, and Soubin Shahir emerge as the top three directors in the top three genres with movies having an average rating greater than 8.
      - James Mangold stands out on top, having directed the highest count of four movies within these genres.
*/






/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT N.NAME AS ACTOR_NAME,
    COUNT(MOVIE_ID) AS MOVIE_COUNT
FROM ROLE_MAPPING RM
	INNER JOIN MOVIE M ON M.ID=RM.MOVIE_ID
	INNER JOIN RATINGS R USING(MOVIE_ID)
	INNER JOIN NAMES N ON N.ID=RM.NAME_ID
WHERE R.MEDIAN_RATING >= 8
    AND CATEGORY='ACTOR'
GROUP BY ACTOR_NAME
ORDER BY MOVIE_COUNT DESC LIMIT 2;

/*
   Method Used:
      - INNER JOIN to join multiple tables and grupby order by to categorise the work done by each Actor.
      - Where clause to filter data based on median rating
   Observations:
      - Mammotty and Mohanlal are the top two actors whose movies have a median rating >= 8.
      - Mammotty tooped having acted in 8 movies.
*/






/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
WITH SUB_PROD_HOUSE_TABLE AS (
    SELECT 
        PRODUCTION_COMPANY,
        SUM(TOTAL_VOTES) AS VOTE_COUNT,
        DENSE_RANK() OVER (ORDER BY SUM(TOTAL_VOTES) DESC) AS PROD_COMP_RANK
    FROM MOVIE M 
        INNER JOIN RATINGS R ON R.MOVIE_ID=M.ID
    WHERE PRODUCTION_COMPANY IS NOT NULL
    GROUP BY PRODUCTION_COMPANY
    ORDER BY VOTE_COUNT DESC
)
SELECT * 
FROM SUB_PROD_HOUSE_TABLE LIMIT 3;

/*
   Method Used:
      - Created CTE SUB_PROD_HOUSE_TABLE to get prod company data based on ratings and votes.
      - Inner join to join movie and ratings table
      - Where clause to filter out the non null values
      - DENSE_RANK to rank based on total votes
   Observations:
      - Marvel Studios, Twentieth Century Fox and Warner V=Bros are the top three production houses based on the number of votes received by their movies
      - Marvel is ranked number ONE with highest votes count of 2656967
*/






/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH ACTORS_INDIA AS (
SELECT N.NAME AS ACTOR_NAME, SUM(TOTAL_VOTES) AS TOTAL_VOTES, 
	   COUNT(R.MOVIE_ID) AS MOVIE_COUNT,
       ROUND(SUM(AVG_RATING*TOTAL_VOTES)/SUM(TOTAL_VOTES),2) AS ACTOR_AVG_RATING
FROM NAMES N
    INNER JOIN ROLE_MAPPING RM ON N.ID=RM.NAME_ID
    INNER JOIN MOVIE M ON RM.MOVIE_ID=M.ID
    INNER JOIN RATINGS R ON R.MOVIE_ID=M.ID
WHERE COUNTRY='INDIA' AND CATEGORY='ACTOR'
GROUP BY ACTOR_NAME
HAVING MOVIE_COUNT >= 5)
SELECT *, 
       DENSE_RANK() OVER(ORDER BY ACTOR_AVG_RATING DESC,TOTAL_VOTES DESC) AS ACTOR_RANK 
FROM ACTORS_INDIA;

/*
   Method Used:
      - INNER JOIN to join multiple tables and grupby order by to categorise the work done by each Actor.
      - Where clause to filter data based on country.
      - DENSE_RANK to rank the acteress based on the weighted average and total votes
   Observations:
      - We have Vijay Sethupathi Ranked number ONE topping the AVG Ratings.
*/       
      








-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT NAME AS ACTRESS_NAME, 
	   SUM(R.TOTAL_VOTES) AS TOTAL_VOTES, 
	   COUNT(R.MOVIE_ID) AS MOVIE_COUNT,
       ROUND(SUM(AVG_RATING*TOTAL_VOTES)/SUM(TOTAL_VOTES),2) AS ACTRESS_AVG_RATING,
       DENSE_RANK() OVER(ORDER BY ROUND(SUM(AVG_RATING*TOTAL_VOTES)/SUM(TOTAL_VOTES),2) DESC,SUM(R.TOTAL_VOTES) DESC) AS ACTRESS_RANK
FROM NAMES N
    INNER JOIN ROLE_MAPPING RM ON N.ID=RM.NAME_ID
    INNER JOIN MOVIE M ON RM.MOVIE_ID=M.ID
    INNER JOIN RATINGS R ON R.MOVIE_ID=M.ID
WHERE COUNTRY LIKE '%INDIA%' AND CATEGORY='ACTRESS' AND LANGUAGES LIKE '%HINDI%'
GROUP BY RM.NAME_ID
HAVING MOVIE_COUNT >= 3 LIMIT 5;

/*
   Method Used:
      - INNER JOIN to join multiple tables and grupby order by to categorise the work done by each Actress.
      - Where clause to filter data based on country and language.
      - DENSE_RANK to rank the acteress based on the weighted average
   Observations:
      - We have Tapsee Pannu, Kriti Sanon, Divya Dutta, Shradda Kapoor and Kriti Karbandha in the top five Indian hindi actreeses list.
      - Tapsee Pannu is on top with highest avg rating of 7.74.
*/

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

WITH THRILL_CATEGORY_MOVIES AS (
    SELECT DISTINCT TITLE, AVG_RATING
    FROM MOVIE AS M
    INNER JOIN RATINGS AS R ON R.MOVIE_ID=M.ID
    INNER JOIN GENRE AS G USING (MOVIE_ID)
    WHERE GENRE='THRILLER'
)
SELECT *,
    CASE
        WHEN AVG_RATING > 8 THEN 'SUPERHIT MOVIES'
        WHEN AVG_RATING BETWEEN 7 AND 8 THEN 'HIT MOVIES'
        WHEN AVG_RATING BETWEEN 5 AND 7 THEN 'ONE-TIME-WATCH MOVIES'
        ELSE 'FLOP MOVIES'
    END AS MOVIE_RATING_CATEGORY
FROM THRILL_CATEGORY_MOVIES;


/*
   Method Used:
      - A CTE THRILL_CATEGORY_MOVIES retrieves distinct titles of movies categorized as 'Thriller' along with their average ratings.
      - The main query employs a CASE statement to categorize these movies into different rating categories based on their average ratings.
   Observations:
      - SAFE is a Super HIT movie with highest avg rating of 9.5
      - ROOFIED is the Flop movie with least avg rating of 1.1
*/





/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT GENRE,
    ROUND(AVG(DURATION), 2) AS AVG_DURATION,
    SUM(AVG(DURATION)) OVER (ORDER BY GENRE) AS RUNNING_TOTAL_DURATION,
    AVG(AVG(DURATION)) OVER (ORDER BY GENRE) AS MOVING_AVG_DURATION
FROM MOVIE M
INNER JOIN GENRE G ON M.ID = G.MOVIE_ID
GROUP BY GENRE;

/*
   Method Used:
      - The query joins the MOVIE and GENRE tables to calculate the average duration per genre.
      - Utilizes aggregation functions (AVG, SUM) along with window functions (SUM and AVG) to compute different metrics such as average duration, running total duration, and moving average duration per genre.
   Observations:
      - Action movies exhibit the highest average duration, standing at 112.88, and maintain a moving average duration.
      - Thriller movies showcase the highest running total duration, accumulating up to 1341.04 minutes.
*/








-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH TOP_HIGHEST_GROSSING_MOVIES AS ( 
    SELECT GENRE, 
        COUNT(MOVIE_ID) AS MOVIE_COUNT, 
        RANK() OVER(ORDER BY COUNT(MOVIE_ID) DESC) RANK_MOVIE_BY_COUNT
    FROM GENRE 
    GROUP BY GENRE LIMIT 3),
RANK_MOVIE_ON_INCOME AS ( 
    SELECT GENRE, 
        YEAR, 
        TITLE AS MOVIE_NAME, 
        WORLWIDE_GROSS_INCOME, 
        RANK() OVER(ORDER BY WORLWIDE_GROSS_INCOME DESC) AS MOVIE_RANK
    FROM MOVIE AS M
    INNER JOIN GENRE AS G ON M.ID=G.MOVIE_ID 
    WHERE GENRE IN (SELECT GENRE FROM TOP_HIGHEST_GROSSING_MOVIES))
SELECT * FROM RANK_MOVIE_ON_INCOME WHERE MOVIE_RANK <= 5;

/*
   Method Used:
      - Using CTE to first identify the top 3 genres based on movie count and then ranks movies within those genres by their worldwide gross income.
      - Where clause to filter the result to include only movies ranked within the top 5
   Observations:
      - In 2017, Drama movies garnered the highest gross income, making it the standout year for the Drama genre.
      - Thriller movies dominated in 2018, with the highest-grossing movie of the year falling within this genre.
      - Notably, 'The Villian,' a Thriller movie, ranks among the top 5 highest-grossing movies for each year, belonging to the top three genres identified earlier.
*/








-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
WITH SUB_PROD_HOUSE_TABLE AS (
    SELECT 
        PRODUCTION_COMPANY,
        COUNT(M.ID) AS MOVIE_COUNT
    FROM MOVIE M 
    INNER JOIN RATINGS R ON R.MOVIE_ID = M.ID
    WHERE MEDIAN_RATING >= 8 
          AND PRODUCTION_COMPANY IS NOT NULL
          AND POSITION(',' IN LANGUAGES) > 0
    GROUP BY PRODUCTION_COMPANY
    ORDER BY MOVIE_COUNT DESC
)
SELECT *, DENSE_RANK() OVER (ORDER BY MOVIE_COUNT DESC) AS PROD_COMP_RANK 
FROM SUB_PROD_HOUSE_TABLE LIMIT 2;

/*
   Method Used:
      - Using CTE to identify top genres based on movie counts and ranks movies within these genres by worldwide gross income, focusing on the top 5 movies per year.
      - Using DENSE_RANK to rank based on movie count
      - Where clause to filter multilingual movies from languages column
   Observations:
      - 'Start Cinema' emerges as the top-ranked production company with the highest multilingual movie count of 7, meeting the specified criteria.
*/




-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT NAME AS ACTRESS_NAME, 
	   SUM(TOTAL_VOTES) AS TOTAL_VOTES, 
	   COUNT(RM.MOVIE_ID) AS MOVIE_COUNT,
       ROUND(SUM(AVG_RATING*TOTAL_VOTES)/SUM(TOTAL_VOTES),2) AS ACTRESS_AVG_RATING,
       DENSE_RANK() OVER(ORDER BY COUNT(RM.MOVIE_ID) DESC) AS ACTRESS_RANK
FROM NAMES N
    INNER JOIN ROLE_MAPPING RM ON N.ID=RM.NAME_ID
    INNER JOIN RATINGS R ON R.MOVIE_ID=RM.MOVIE_ID
    INNER JOIN GENRE G ON R.MOVIE_ID=G.MOVIE_ID
WHERE G.GENRE='DRAMA' AND CATEGORY='ACTRESS' AND AVG_RATING > 8
GROUP BY NAME
ORDER BY ACTRESS_RANK LIMIT 3;

/*
   Method Used:
      - The query joins various tables (NAMES, ROLE_MAPPING, RATINGS, GENRE) to collect data on actresses' appearances in 'Super Hit' Drama movies.
      - Utilizes aggregation functions to calculate the total votes, movie counts, and actress average ratings.
      - Implements DENSE_RANK() to rank the actresses based on the number of 'Super Hit' movies they've appeared in.
   Observations:
      - Parvathy Thiruvothu, Susan Brown, and Amanda Lawrence emerge as the top 3 actresses based on their appearances in 'Super Hit' Drama movies (average rating > 8).
      - Among them, Parvathy Thiruvothu has the highest total number of votes.
*/




/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH DIR_DATE_SUMMARY AS ( 
    SELECT 
        D.NAME_ID, 
        NAME, 
        D.MOVIE_ID, 
        DURATION, 
        R.AVG_RATING, 
        TOTAL_VOTES, 
        M.DATE_PUBLISHED, 
        LEAD(DATE_PUBLISHED, 1) OVER (PARTITION BY D.NAME_ID ORDER BY DATE_PUBLISHED, MOVIE_ID) AS NEXT_DATE_PUBLISHED 
    FROM 
        DIRECTOR_MAPPING AS D 
        INNER JOIN NAMES AS N ON N.ID = D.NAME_ID 
        INNER JOIN MOVIE AS M ON M.ID = D.MOVIE_ID 
        INNER JOIN RATINGS AS R ON R.MOVIE_ID = M.ID 
), 
TOP_DIRECTOR_SUMMARY AS ( 
    SELECT *, DATEDIFF(NEXT_DATE_PUBLISHED, DATE_PUBLISHED) AS DATE_DIFFERENCE 
    FROM DIR_DATE_SUMMARY
) 
SELECT  
    NAME_ID AS DIRECTOR_ID, 
    NAME AS DIRECTOR_NAME, 
    COUNT(MOVIE_ID) AS NUMBER_OF_MOVIES, 
    ROUND(AVG(DATE_DIFFERENCE), 2) AS AVG_INTER_MOVIE_DAYS, 
    ROUND(AVG(AVG_RATING), 2) AS AVG_RATING, 
    SUM(TOTAL_VOTES) AS TOTAL_VOTES, 
    MIN(AVG_RATING) AS MIN_RATING, 
    MAX(AVG_RATING) AS MAX_RATING, 
    SUM(DURATION) AS TOTAL_DURATION 
FROM TOP_DIRECTOR_SUMMARY 
GROUP BY DIRECTOR_ID 
ORDER BY COUNT(MOVIE_ID) DESC LIMIT 9;

/*
   Method Used:
      - The query uses CTE to gather data on directors, their movies, ratings, and dates published, calculating the difference in days between movie releases for each director.
      - Utilizes aggregation functions to summarize statistics per director, such as movie count, average inter-movie duration, average rating, total votes, minimum and maximum ratings, and total movie duration.
   Observations:
      - The query retrieves data for the top 9 directors based on movie-related metrics.
      - Steven Soderbergh stands out as a highly-rated director with the highest vote count among the selected directors.
*/



