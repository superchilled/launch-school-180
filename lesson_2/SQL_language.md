# The SQL Language - Exercises

1. What kind of programming language is SQL?

SQL is a **special purpose language**. It has a specific purpose - interacting with a relational database - as opposed to *general purpose* programming languages, such as Ruby, which can be used in a variety of ways.

It is also a **declarative** language, in that it explains *what* needs to be done, but not specifically *how* to do it.

2. What are the three sublanguages of SQL?

The sub-languages of SQL are:

  * DDL - Data Definition Language. This is interested in defining the *schema* of the database. Commands include, `CREATE`, `ALTER`, `DROP`, etc..

  * DML - Data Manipulation Language. This is interested in working with the actual data in the database. Some languages deal with Retreival and Manipulation separately, but the Postgres Documentation combines them as a singel sub-language. Commands include `SELECT`, `UPDATE`, `DELETE`, etc.

  * DCL - Data Control Language. THis is interested in dealing with Access Permissions on a database. Commands include `GRANT`.

3. Write the following values as quoted string values that could be used in a SQL query.

```bash
canoe
a long road
weren't
"No way!"
```

Quoted string values would be:

```sql
'canoe'

'a long road'

'weren''t'
/* or */
E'weren\'t'

'"No way!"'
/* or */
E'\"No way!\"'
```

4. What operator is used to concatenate strings?

The `||` operator can be used to concatenate two strings or a string and a non-string:

```sql
'Car' || 'avan' /* 'Caravan' */

'Number: ' || 42 /* 'NUmber 42' */
```

5. What function returns a lowercased version of a string? Write a SQL statement using it.

The `lower(string)` function returns a lowercased version of a string.

```sql
lower('HELLO') /* 'hello' */
```

6. How does the `psql` console display true and false values?

The values are referenced using `TRUE` and `FALSE` but are displayed as `t` and `f`.

7. The surface area of a sphere is calculated using the formula `A = 4π r2`, where `A` is the surface area and `r` is the radius of the sphere.

Use SQL to compute the surface area of a sphere with a radius of 26.3cm, truncated to return an integer.

To solve this problem you would need to use some of SQL's Mathematical Functions and Operators, such as `*`, `power()`, and `pi`

```sql
SELECT round(4 * pi() * power(26.3, 2));

round 
-------
  8692
(1 row)

/* or LS answer */

SELECT trunc(4 * pi() * 26.3 ^ 2);
 trunc
-------
  8692
(1 row)
```
