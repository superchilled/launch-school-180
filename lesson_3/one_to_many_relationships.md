# One to Many Relationships - Exercises

1. Write a SQL statement to add the following call data to the database:

| when | duration | first_name | last_name  | number |
|----|----|----|----|----|
|2016-01-18 14:47:00 | 632  | William  | Swift  | 7204890809 |

```sql
SELECT id FROM contacts WHERE
  first_name = 'William' AND
  last_name = 'Swift' AND
  number = '7204890809';
 id 
----
  6
(1 row)

INSERT INTO calls ("when", duration, contact_id) VALUES
  ('2016-01-18 14:47:00', 632, 6);
```

2. Write a SQL statement to retrieve the call times, duration, and first name for all calls **not** made to William Swift.

SELECT cast(cl.when AS time), cl.duration, cn.first_name
  FROM calls cl INNER JOIN contacts cn ON cl.contact_id = cn.id
WHERE cn.first_name != 'William' AND cn.last_name != 'Swift';

3. Write SQL statements to add the following call data to the database:

| when | duration | first_name | last_name  | number |
|----|----|----|----|----|
|2016-01-17 11:52:00  | 175  | Merve  | Elk  | 6343511126 |
|2016-01-18 21:22:00  | 79 | Sawa | Fyodorov | 6125594874 |

```sql
INSERT INTO contacts (first_name, last_name, number) VALUES
  ('Merve', 'Elk', '6343511126'),
  ('Sawa', 'Fyodorov', '6125594874');

SELECT id, first_name, last_name, number FROM contacts WHERE
  (first_name = 'Merve' AND
  last_name = 'Elk' AND
  number = '6343511126') OR
  (first_name = 'Sawa' AND
  last_name = 'Fyodorov' AND
  number = '6125594874');
 id 
----
  6
(2 rows)

INSERT INTO calls ("when", duration, contact_id) VALUES
  ('2016-01-17 11:52:00', 175, 26),
  ('2016-01-18 21:22:00', 79, 27);
```

4. Add a constraint to **contacts** that prevents a duplicate value being added in the column number.

```sql
ALTER TABLE contacts ADD CONSTRAINT unique_number UNIQUE (number);
```

5. Write a SQL statement that attempts to insert a duplicate number for a new contact but fails. What error is shown?

```sql
INSERT INTO contacts (first_name, last_name, number) VALUES
  ('Some', 'Contact', '7204890809');
ERROR:  duplicate key value violates unique constraint "unique_number"
DETAIL:  Key (number)=(7204890809) already exists.
```

6. Why does "when" need to be quoted in many of the queries in this lesson?

`"when"` needs to be contained in double quotes because `WHEN` is a keyword in SQL so if you also have a column called `when` you need to have it in double quotes for PostgreSQL to be able to differentiate it from the keyword (internally, PostgreSQL automatically converts all unquoted commands and parameters to lower case, so wouldn't be able to differentiate between `WHEN` and `when` - they would both appear as `when`. It can differentiate between `"WHEN"` and `"when2"` however, so you could referenve two tables of the same name but different cases as long as you surrounded them with double quote marks when referencing them).

You don't need to use quote marks if you are prepending the column name with a table name or table alias:

```sql
contacts.when, c.when
```
