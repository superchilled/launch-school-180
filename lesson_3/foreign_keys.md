# Foreign Keys - Exercises

1. Import this file into a new database.

```bash
createdb test3
psql -d test3 < orders_products1.sql
```

2. Use psql to insert the data shown in the following table into the database:

```sql
INSERT INTO products (name) VALUES ('small bolt'), ('large bolt');

SELECT * FROM products;

INSERT INTO orders (product_id, quantity) VALUES
  (1, 10),
  (1, 25),
  (2, 15);
```

3. Write a SQL statement that returns a result like this:

```sql
 quantity |    name
----------+------------
       10 | small bolt
       25 | small bolt
       15 | large bolt
(3 rows)
```

```sql
SELECT o.quantity, p.name
  FROM orders o INNER JOIN products p 
  ON o.product_id = p.id;
```

4. Can you insert a row into `orders` without a `product_id`? Write a SQL statement to prove your answer.

Yes, as there are no constraints on the `product_id` column.

```sql
INSERT INTO orders (quantity) VALUES (10);

SELECT * FROM orders;
 id | product_id | quantity 
----+------------+----------
  1 |          1 |       10
  2 |          1 |       25
  3 |          2 |       15
  4 |            |       10
(4 rows)
```

5. Write a SQL statement that will prevent NULL values from being stored in orders.product_id. What happens if you execute that statement?

```sql
ALTER TABLE orders ALTER COLUMN product_id SET NOT NULL;
```

If you execute the statement without cleaning up the data, spql will not make the change as there is already a row with a null value in that column:

```sql
ERROR:  column "product_id" contains null values
```

6. Make any changes needed to avoid the error message encountered in #5

```sql
UPDATE orders SET product_id = 1 WHERE product_id IS NULL;
```

7. Create a new table called `reviews` to store the data shown below. This table should include a primary key and a reference to the `products` table.

```sql
CREATE TABLE reviews (
  id serial PRIMARY KEY,
  product_id integer REFERENCES products (id),
  review text NOT NULL
);
```

8. Write SQL statements to insert the data shown in the table in #7.

```sql
INSERT INTO reviews (product_id, review) VALUES
  (1, 'a little small'),
  (1, 'very round!'),
  (2, 'could have been smaller');
```

9. **True** or **false**: A foreign key constraint prevents NULL values from being stored in a column.

False. Foreign key columns allow `NULL` values. You have to set them as `NOT NULL`.
