GROUP BY and Aggregate Functions - Exercises

1. Import this file into a database.

```sql
psql -d test1 < films4.sql
```

2. Write SQL statements that will insert the following films into the database:

| title | year | genre | director | duration |
|----|----|----|----|----|
|Wayne's World | 1992 | comedy | Penelope Spheeris | 95 |
|Bourne Identity | 2002 | espionag | Doug Liman | 118 |

```sql
INSERT INTO films (title, year, genre, director, duration) VALUES
  ('Wayne''s World', 1992, 'comedy', 'Penelope Spheeris', 95),
  ('Bourne Identity', 2002, 'espionage', 'Doug Liman', 118);
```

3. Write a SQL query that lists all genres for which there is a movie in the `films` table.

```sql
SELECT DISTINCT genre FROM films;
```

4. Write a SQL query that returns the same results as the answer for #3, but without using `DISTINCT`.

```sql
SELECT genre FROM films GROUP BY genre;
```

5. Write a SQL query that determines the average duration across all the movies in the films table, rounded to the nearest minute.

```sql
SELECT ROUND(avg(duration)) FROM films;
```

6. Write a SQL query that determines the average duration for each genre in the films table, rounded to the nearest minute.

```sql
SELECT genre, ROUND(avg(duration)) FROM films GROUP BY genre;
```

7. Write a SQL query that determines the average duration of movies for each decade represented in the films table, rounded to the nearest minute and listed in chronological order.

```sql
SELECT CASE WHEN year >= 1940 AND year < 1950 THEN 1940
            WHEN year >= 1950 AND year < 1960 THEN 1950
            WHEN year >= 1960 AND year < 1970 THEN 1960
            WHEN year >= 1970 AND year < 1980 THEN 1970
            WHEN year >= 1980 AND year < 1990 THEN 1980
            WHEN year >= 1990 AND year < 2000 THEN 1990
            WHEN year >= 2000 AND year < 2010 THEN 2000
            WHEN year >= 2010 AND year < 2020 THEN 2010
       END
  AS decade,
  ROUND(avg(duration)) FROM films GROUP BY decade ORDER BY decade ASC;
```

LS Solution:

```sql
SELECT year / 10 * 10 as decade, ROUND(AVG(duration)) as average_duration
  FROM films GROUP BY decade ORDER BY decade;
```

8. Write a SQL query that finds all films whose director has the first name `John`.

```sql
SELECT * FROM films WHERE director LIKE 'John %';
```

9. Write a SQL query that will return the following data:

```sql
   genre   | count
-----------+-------
 scifi     |     5
 comedy    |     4
 drama     |     2
 espionage |     2
 crime     |     1
 thriller  |     1
 horror    |     1
 action    |     1
(8 rows)
```

```sql
SELECT genre, count(id) FROM films GROUP BY genre ORDER BY count DESC;
```

10. Write a SQL query that will return the following data:

```sql
 decade |   genre   |                  films
--------+-----------+------------------------------------------
   1940 | drama     | Casablanca
   1950 | drama     | 12 Angry Men
   1950 | scifi     | 1984
   1970 | crime     | The Godfather
   1970 | thriller  | The Conversation
   1980 | action    | Die Hard
   1980 | comedy    | Hairspray
   1990 | comedy    | Home Alone, The Birdcage, Wayne's World
   1990 | scifi     | Godzilla
   2000 | espionage | Bourne Identity
   2000 | horror    | 28 Days Later
   2010 | espionage | Tinker Tailor Soldier Spy
   2010 | scifi     | Midnight Special, Interstellar, Godzilla
(13 rows)
```

```sql
SELECT year / 10 * 10 AS decade, genre, string_agg(title, ', ') AS films FROM films GROUP BY decade, genre ORDER BY decade;
```

11. Write a SQL query that will return the following data:

```sql
   genre   | total_duration
-----------+----------------
 horror    |            113
 thriller  |            113
 action    |            132
 crime     |            175
 drama     |            198
 espionage |            245
 comedy    |            407
 scifi     |            632
(8 rows)
```

```sql
SELECT genre, SUM(duration) AS total_duration FROM films GROUP BY genre ORDER BY total_duration ASC;
```
