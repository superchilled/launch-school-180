# Working with a Single Table - Exercises

1. Write a SQL statement that will create the following table, **people**:

| name | age |  occupation |
|----|----|----|
| Abby | 34 | biologist |
| Mu'nisah | 26 | NULL |
| Mirabelle  | 40 | contractor |

You could use the following SQL statement:

```sql
CREATE TABLE people (
  name VARCHAR(50),
  age INTEGER,
  occupation VARCHAR(50)
);

2. Write SQL statements to insert the data shown in #1 into the table.

INSERT INTO people (name, age, occupation) VALUES
  ('Abby', 34, 'biologist'),
  ('Mu''nisah', 26, NULL),
  ('Mirabelle', 40, 'contractor');
```

3. Write 3 SQL queries that can be used to retrieve the second row of the table shown in #1 and #2.

```sql
SELECT * FROM people WHERE name = 'Mu''nisah';
SELECT * FROM people WHERE age = 26;
SELECT * FROM people WHERE occupation IS NULL;
```

4. Write a SQL statement that will create a table named `birds` that can hold the following values:

| name | length |  wingspan | family | extinct |
|----|----|----|----|----|
| Spotted Towhee | 21.6 | 26.7 | Emberizidae  | f |
| American Robin | 25.5 | 36.0 | Turdidae | f |
| Greater Koa Finch |  19.0 | 24.0 | Fringillidae | t |
| Carolina Parakeet |  33.0 | 55.8 | Psittacidae  | t |
| Common Kestrel | 35.5 | 73.5 | Falconidae | f |

You could use the following SQL statement:

```sql
CREATE TABLE birds (
  name VARCHAR(255),
  length DECIMAL(3, 1),
  wingspan DECIMAL(3, 1),
  family VARCHAR(255),
  extinct BOOLEAN
);
```

5. Using the table created in #4, write the SQL statements to insert the data as shown in the listing.

```sql
INSERT INTO birds VALUES
  ('Spotted Towhee', 21.6, 26.7, 'Emberizidae', FALSE),
  ('American Robin', 25.5, 36.0, 'Turdidae', FALSE),
  ('Greater Koa Finch', 19.0, 24.0, 'Fringillidae', TRUE),
  ('Carolina Parakeet', 33.0, 55.8, 'Psittacidae', TRUE),
  ('Common Kestrel', 35.5, 73.5, 'Falconidae', FALSE);
```

6. Write a SQL statement that finds the names and families for all birds that are not extinct, in order from longest to shortest (based on the length column's value).

```sql
SELECT name, family FROM birds WHERE extinct = FALSE ORDER BY length DESC;
```

7. Use SQL to determine the average, minimum, and maximum wingspan for the birds shown in the table.

```sql
SELECT ROUND(AVG(wingspan), 1) AS average_wingspan, MAX(wingspan) AS max_wingspan, MIN(wingspan) AS min_wingspan FROM birds;
```

8. Write a SQL statement to create the table shown below, menu_items:

| item | prep_time |  ingredient_cost | sales | menu_price |
|----|----|----|----|----|
| omelette | 10 | 1.50 | 182  | 7.99 |
| tacos | 5 | 2.00 | 254 | 8.99 |
| oatmeal |  1 | 0.50 | 79 | 5.99 |


```sql
CREATE TABLE menu_items (
  item VARCHAR(50),
  prep_time INTEGER,
  ingredient_cost NUMERIC(3,2),
  sales INTEGER,
  menu_price NUMERIC(3,2)
);
```

9. Write SQL statements to insert the data shown in #8 into the table.

```sql
INSERT INTO menu_items VALUES
  ('omelette', 10, 1.50, 182, 7.99),
  ('tacos', 5, 2.00, 254, 8.99),
  ('oatmeal', 1, 0.50, 79, 5.99);
```

10. Using the table and data from #8 and #9, write a SQL query to determine which menu item is the most profitable based on the cost of its ingredients, returning the name of the item and its profit. Keep in mind that prep_time is represented in minutes and ingredient_cost and menu_price are in dollars and cents):

```sql
SELECT item, ROUND((menu_price - ingredient_cost) * sales, 2) AS profit FROM menu_items ORDER BY profit DESC LIMIT 1;
```

LS answer didn't include sales as a profitablity metric:

```sql
SELECT item, menu_price - ingredient_cost AS profit FROM menu_items ORDER BY profit DESC LIMIT 1;
```

11. Write a SQL query to determine how profitable each item on the menu is based on the amount of time it takes to prepare. Assume that whoever is preparing the food is being paid $13 an hour. List the most profitable items first.

```sql
SELECT item, ROUND(menu_price - ((13.0 / 60) * prep_time), 2) as prep_profit FROM menu_items ORDER BY prep_profit DESC;
```

Bonus. Write a SQL query to determine how profitable each item on the menu is based on the amount of time it takes to prepare AND the ingredient cost. List the most profitable items first.

```sql
SELECT item, menu_price, ingredient_cost, ROUND((13.0 / 60) * prep_time, 2) AS labor, ROUND(menu_price - ingredient_cost - ((13.0 / 60) * prep_time), 2) as margin FROM menu_items ORDER BY margin DESC;
```