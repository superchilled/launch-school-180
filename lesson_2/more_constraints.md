# More Constraints - Exercises

1. Import this file into a PostgreSQL database.

```bash
psql -d test1 < films2.sql
```

2. Modify all of the columns to be `NOT NULL`.

```sql
ALTER TABLE films
  ALTER COLUMN title SET NOT NULL,
  ALTER COLUMN year SET NOT NULL,
  ALTER COLUMN genre SET NOT NULL,
  ALTER COLUMN director SET NOT NULL,
  ALTER COLUMN duration SET NOT NULL;
```

3. How does modifying a column to be `NOT NULL` affect how it is displayed by `\d films`?

`not null` shows in the `Modifiers` column for that column.

4. Add a constraint to the table **films** that ensures that all films have a unique title.

```sql
ALTER TABLE films ADD CONSTRAINT unique_title UNIQUE (title);
```

5. How is the constraint added in #4 displayed by `\d films`?

It is displayed under `Indexes`:

```sql
Indexes:
    "unique_title" UNIQUE CONSTRAINT, btree (title)
```

6. Write a SQL statement to remove the constraint added in #4.

```sql
ALTER TABLE films DROP CONSTRAINT unique_title;
```

7. Add a constraint to films that requires all rows to have a value for title that is at least 1 character long.

```sql
ALTER TABLE films ADD CONSTRAINT title_chars CHECK (length(title) > 0);
```

8. What error is shown if the constraint created in #7 is violated? Write a SQL `INSERT` statement that demonstrates this.

```sql
ERROR:  new row for relation "films" violates check constraint "title_chars"
```

```sql
INSERT INTO films(title, year, genre, director, duration) VALUES ('', 1979, 'horror', 'Ridley Scott', 117);
```

9. How is the constraint added in #7 displayed by `\d` films?

It is listed under `Check constraints`

```sql
Check constraints:
    "title_chars" CHECK (length(title::text) > 0)

```

10. Write a SQL statement to remove the constraint added in #7.

```sql
ALTER TABLE films DROP CONSTRAINT title_chars;
```

11. Add a constraint to the table films that ensures that all films have a year between 1900 and 2100.

```sql
ALTER TABLE films ADD CONSTRAINT year_check CHECK (year BETWEEN 1900 AND 2100);
```

12. How is the constraint added in #11 displayed by \d films?

It is listed under `Check constraints`

```sql
Check constraints:
    "year_check" CHECK (year >= 1900 AND year <= 2100)
```

13. Add a constraint to films that requires all rows to have a value for `director` that is at least 3 characters long and contains at least one space character `()`.

```sql
ALTER TABLE films ADD CONSTRAINT director_format CHECK (length(director) >= 3 AND director LIKE '% %');
```

LS solution uses the `position` String function rather than `LIKE`:

```sql
ALTER TABLE films ADD CONSTRAINT director_name
    CHECK (length(director) >= 3 AND position(' ' in director) > 0);
```

14. How does the constraint created in #13 appear in `\d films`?

It is listed under `Check constraints`

```sql
Check constraints:
    "director_format" CHECK (length(director::text) >= 3 AND director::text ~~ '% %'::text)
    "year_check" CHECK (year >= 1900 AND year <= 2100)
```

15. Write an UPDATE statement that attempts to change the director for "Die Hard" to "Johnny". Show the error that occurs when this statement is executed.

```sql
UPDATE films SET director = 'Johnny' WHERE title = 'Die Hard';
```

Error shows as:

```sql
ERROR:  new row for relation "films" violates check constraint "director_format"
DETAIL:  Failing row contains (Die Hard, 1988, action, Johnny, 132).
```

16. List three ways to use the schema to restrict what values can be stored in a column.

1. You can specify the data type of a column

2. You can set default values (perhaps not exactly a *restricition*)

3. You can add constraints:

  * Check constraints - these allow you to specify that the value must satisfy a Boolean expression.
  * Not-null constraints - specifies that a column mustnot assume a null value.
  * Unique constraints - ensures that data contained in a column, or a group of columns, is unique among all the rows in the table.

17. Is it possible to define a default value for a column that will be considered invalid by a constraint? Create a table that tests this.

You *can* define a column in a way where a default value contradicts a constraint (e.g. a `CHECK` constraint)

```sql
test1=# CREATE TABLE constraint_test (test_col_1 VARCHAR(25), test_col_2 numeric CHECK (test_col_2 > 0) DEFAULT 0);
CREATE TABLE
```
However when you attempt to insert data without specifying a valid value for the column with the constraint then you receive an error:

```sql
test1=# INSERT INTO constraint_test VALUES ('One');
ERROR:  new row for relation "constraint_test" violates check constraint "constraint_test_test_col_2_check"
DETAIL:  Failing row contains (One, 0).
```

```sql
test1=# INSERT INTO constraint_test VALUES ('One', 1);
INSERT 0 1
```

Effectively the constraint acts on the defult in exactly the same way as if you were manually inserting an invalid value.

18. How can you see a list of all of the constraints on a table?

By calling `\d` on the table.
