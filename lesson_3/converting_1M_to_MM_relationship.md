# Converting a 1:M Relationship to a M:M Relationship - Exercises

1. Import this file into a database using `psql`

Answer:

```bash
createdb test7
psql -d test7 < films7.sql
```

2. Write a SQL statement that will add a primary key column to `films`.

Answer:

```sql
ALTER TABLE films ADD COLUMN id serial PRIMARY KEY;
```

3. Write the SQL statement needed to create a join table that will allow a film to have multiple directors, and directors to have multiple films. Include an `id` column in this table, and add foreign key constraints to the other columns.

Answer:

```sql
CREATE TABLE films_directors (
  id serial PRIMARY KEY,
  film_id integer REFERENCES films(id),
  director_id integer REFERENCES directors(id)
);
```

4. Write the SQL statements needed to insert data into the new join table to represent the existing one-to-many relationships.

Answer:

```sql
INSERT INTO films_directors (film_id, director_id) VALUES
  (1, 1),
  (2, 2),
  (3, 3),
  (4, 4),
  (5, 5),
  (6, 6),
  (7, 3),
  (8, 7),
  (9, 8),
  (10, 4);
```

5. Write a SQL statement to remove any unneeded columns from films.

Answer:

```sql
ALTER TABLE films DROP COLUMN director_id;
```

6. Write a SQL statement that will return the following result:

```sql
           title           |         name
---------------------------+----------------------
 12 Angry Men              | Sidney Lumet
 1984                      | Michael Anderson
 Casablanca                | Michael Curtiz
 Die Hard                  | John McTiernan
 Let the Right One In      | Michael Anderson
 The Birdcage              | Mike Nichols
 The Conversation          | Francis Ford Coppola
 The Godfather             | Francis Ford Coppola
 Tinker Tailor Soldier Spy | Tomas Alfredson
 Wayne's World             | Penelope Spheeris
(10 rows)
```

Answer:

```sql
SELECT f.title, d.name 
  FROM films f 
    INNER JOIN films_directors fd ON f.id = fd.film_id 
    INNER JOIN directors d ON fd.director_id = d.id
  ORDER BY f.title;
```

7. Write SQL statements to insert data for the following films into the database:

| Film | Year | Genre  | Duration | Directors |
|----|----|----|----|----|
| Fargo  | 1996 | comedy | 98 | Joel Coen |
| No Country for Old Men | 2007 | western |  122  | Joel Coen, Ethan Coen |
| Sin City | 2005 | crime |  124 |  Frank Miller, Robert Rodriguez |
| Spy Kids | 2001 | scifi |  88 | Robert Rodriguez |

Answer:

```sql
INSERT INTO films (title, year, genre, duration) VALUES
  ('Fargo', 1996, 'comedy', 98),
  ('No Country for Old Men', 2007, 'western', 122),
  ('Sin City', 2005, 'crime', 124),
  ('Spy Kids', 2001, 'scifi', 88);

INSERT INTO directors (name) VALUES
  ('Joel Coen'),
  ('Ethan Coen'),
  ('Frank Miller'),
  ('Robert Rodriguez');

INSERT INTO films_directors (film_id, director_id) VALUES
  (11, 9),
  (12, 9),
  (12, 10),
  (13, 11),
  (13, 12),
  (14, 12);

```

8. Write a SQL statement that determines how many films each director in the database has directed. Sort the results by number of films (greatest first) and then name (in alphabetical order).

Answer:

```sql
SELECT d.name, count(f.id) AS number_of_films
  FROM directors d 
    INNER JOIN films_directors fd ON d.id = fd.director_id
    INNER JOIN films f ON fd.film_id = f.id
  GROUP BY d.name
  ORDER BY number_of_films DESC, d.name;
```

LS Answer (only uses one join - since each entry for a director in the `films_directors` table represents a film, you don't actually need to perform a second join to the `films` table).

```sql
SELECT directors.name AS director, COUNT(directors_films.film_id) AS films
  FROM directors
    INNER JOIN directors_films ON directors.id = directors_films.director_id
  GROUP BY directors.id
  ORDER BY films DESC, directors.name ASC;
```
