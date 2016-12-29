# Practice Queries

A fewe practice queries for teh linrary database from the [Introduction to SQL](https://launchschool.com/books/sql) book.

1. Select books that have never been checked out

```SQL
library=# SELECT title FROM books WHERE books.id NOT IN (SELECT book_id FROM users_books);
```

2. Select user that has the most books checked out

```SQL
library=# SELECT y.user FROM (
  SELECT u.username AS user, COUNT(ub.book_id)
  AS loans FROM users u INNER JOIN users_books ub 
  ON u.id = ub.user_id WHERE ub.return_date IS NULL GROUP BY u.username
) y ORDER BY loans DESC LIMIT 1;

    user    
------------
 John Smith
(1 row)
```

3. Select users that are most active

(Not sure what 'active' relates to).

4. Select users with the most books

```SQL
library=# SELECT y.top_5_users FROM (
  SELECT u.username AS top_5_users, COUNT(ub.book_id)
  AS loans FROM users u INNER JOIN users_books ub 
  ON u.id = ub.user_id GROUP BY u.username
) y ORDER BY loans DESC LIMIT 5;

 top_5_users 
-------------
 John Smith
 Jane Smith
(2 rows)
```

5. Select users with the most reviews

```sql
library=# SELECT y.top_5_reviewers, y.review_count FROM (
  SELECT u.username AS top_5_reviewers, COUNT(r.user_id)
  AS review_count FROM users u INNER JOIN reviews r 
  ON u.id = r.user_id GROUP BY u.username
) y ORDER BY review_count DESC LIMIT 5;

 top_5_reviewers | review_count 
-----------------+--------------
 John Smith      |            2
 Jane Smith      |            1
(2 rows)
```

6. Select queries with =, vs in, vs Not IN, vs Like

**=**

Specific select via `id`

```sql
library=# SELECT * FROM books WHERE id = 6;

 id |             title             |  author   |   published_date    | isbn 
----+-------------------------------+-----------+---------------------+------
  6 | Weather Warnings for Watchers | The Clerk | 1887-01-01 00:00:00 |     
```

**IN**

All books with a review.

```sql
library=# SELECT title FROM books WHERE books.id IN (SELECT book_id FROM reviews);

       title        
--------------------
 My First SQL book
 My Second SQL book
(2 rows)
```

**NOT IN**

All books without a review.

```sql
library=# SELECT title FROM books WHERE books.id NOT IN (SELECT book_id FROM reviews);

                       title                       
---------------------------------------------------
 My Third SQL book
 Christmas Stories from French and Spanish writers
 Michael and His Lost Angel
 Weather Warnings for Watchers
 Cronaca della rivoluzione di Milano
 Thomas More
 Poésies de Daniel Lesueur
 Norman Macleod
 Alfried Krupp
 The Intrusions of Peggy
 Private Spud Tamson
 The Philosophy of Natural Theology
 A Treatise on Gunshot Wounds
 The Sanitary Evolution of London
 The Imprudence of Prue
 The Forest Schoolmaster
 Kim
(17 rows)
```

**LIKE**

Select all books with three `'e'`s in the author's name.

```sql
library=# SELECT * FROM books WHERE author LIKE '%e%e%e%';

 id |                       title                       |                author                 |   published_date    | isbn 
----+---------------------------------------------------+---------------------------------------+---------------------+------
  4 | Christmas Stories from French and Spanish writers | Antoinette Ogden                      | 1898-01-01 00:00:00 |     
  7 | Cronaca della rivoluzione di Milano               | Leone Tettoni                         | 1848-01-01 00:00:00 |     
  8 | Thomas More                                       | Henriette Roland Holst van der Schalk | 1921-01-01 00:00:00 |     
 10 | Poésies de Daniel Lesueur                         | Daniel Lesueur                        | 1896-01-01 00:00:00 |     
 17 | The Sanitary Evolution of London                  | Henry Lorenzo Jephson                 | 1907-01-01 00:00:00 |     
 19 | The Forest Schoolmaster                           | Peter Rosegger                        | 1900-01-01 00:00:00 |     
(6 rows)
```

7. SQL queries with wild card search and limit

First five books from the table with an `'a'` in the title.

```sql
library=# SELECT * FROM books WHERE title LIKE '%a%' LIMIT 5;

 id |                       title                       |                author                 |   published_date    | isbn 
----+---------------------------------------------------+---------------------------------------+---------------------+------
  4 | Christmas Stories from French and Spanish writers | Antoinette Ogden                      | 1898-01-01 00:00:00 |     
  5 | Michael and His Lost Angel                        | Henry Arthur Jones                    | 1895-01-01 00:00:00 |     
  6 | Weather Warnings for Watchers                     | The Clerk                             | 1887-01-01 00:00:00 |     
  7 | Cronaca della rivoluzione di Milano               | Leone Tettoni                         | 1848-01-01 00:00:00 |     
  8 | Thomas More                                       | Henriette Roland Holst van der Schalk | 1921-01-01 00:00:00 |     
(5 rows)
```
