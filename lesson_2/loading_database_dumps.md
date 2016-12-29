# Loading Database Dumps - Exercises

1. Load films1.sql into your database.

  a. What does the file do?

  The file contains SQL queries, when imported the queries run.

  b. What is the output of the command? What does each line in this output mean?

```bash
psql -d test1 < films1.sql
NOTICE:  table "films" does not exist, skipping 
DROP TABLE # there is no table called `films` in the `test1` database so this command is skipped 
CREATE TABLE # Creates a table
INSERT 0 1 # Inserts one record into the table
INSERT 0 1 # Inserts one record into the table
INSERT 0 1 # Inserts one record into the table
```
  c. Open up the file and look at its contents. What does the first line do?

  Drops the table `films` if it already exists


There are no solutions for Exercise 1. I would suggest adding something along these lines:

Load this file into your database.

a. What does the file do?

The file contains SQL queries, when imported the queries run.

b. What is the output of the command? What does each line in this output mean?

```bash
psql -d test1 < films1.sql
NOTICE:  table "films" does not exist, skipping 
DROP TABLE # there is no table called `films` in the `test1` database so this command is skipped 
CREATE TABLE # Creates a table
INSERT 0 1 # Inserts one record into a table
INSERT 0 1 # Inserts one record into a table
INSERT 0 1 # Inserts one record into a table
```

c. Open up the file and look at its contents. What does the first line do?

Drops the table `films` if it already exists

2. Write a SQL statement that returns all rows in the **films** table.

```sql
SELECT * FROM films;
```

3. Write a SQL statement that returns all rows in the **films** table with a title shorter than 12 letters.

```sql
SELECT * FROM films WHERE char_length(title) < 12;
```

4. Write the SQL statements needed to add two additional columns to the **films** table: `director`, which will hold a director's full name, and `duration`, which will hold the length of the film in minutes.

```sql
ALTER TABLE films 
  ADD COLUMN director VARCHAR(255),
  ADD COLUMN duration INTEGER;
```

5. Write SQL statements to update the existing rows in the database with values for the new columns:

| title | director | duration |
|----|----|----|
| Die Hard | John McTiernan | 132 |
| Casablanca | Michael Curtiz | 102 |
| The Conversation  | Francis Ford Coppola | 113 |

```sql
UPDATE films SET director = 'John McTiernan', duration = 132 WHERE title = 'Die Hard';
UPDATE films SET director = 'Michael Curtiz', duration = 102 WHERE title = 'Casablanca';
UPDATE films SET director = 'Francis Ford Coppola', duration = 113 WHERE title = 'The Conversation';
```

6. Write SQL statements to insert the following data into the films table:

| title | year | genre | director | duration |
|----|----|----|----|----|
| 1984 | 1956 | scifi |  Michael Anderson | 90 |
| Tinker Tailor Soldier Spy  | 2011 | espionage |  Tomas Alfredson  | 127 |
| The Birdcage | 1996 | comedy | Mike Nichols | 118 |

```sql
INSERT INTO films (title, year, genre, director, duration) VALUES
  ('1984', 1956, 'scifi' , 'Michael Anderson', 90),
  ('Tinker Tailor Soldier Spy', 2011, 'espionage', 'Tomas Alfredson', 127),
  ('The Birdcage', 1996, 'comedy', 'Mike Nichols', 118);
```

7. Write a SQL statement that will return the title and age in years of each movie, with newest movies listed first:

```sql
SELECT title, EXTRACT(YEAR FROM TIMESTAMP 'NOW()') - year AS age FROM films ORDER BY age ASC;
```

8. Write a SQL statement that will return the title and duration of each movie longer than two hours, with the longest movies first.

```sql
SELECT title, duration FROM films WHERE duration > 120 ORDER BY duration DESC;
```

9. Write a SQL statement that returns the title of the longest film.

```sql
SELECT title FROM films WHERE duration = (SELECT MAX(duration) FROM films);
```