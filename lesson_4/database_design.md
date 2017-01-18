# Database Design

As we saw in the video, expenses have the following attributes:

  * When the expense was created
  * How much the expense was
  * What the expense was for

In this assignment, we're going to setup a database that we will use throughout the project to persist expense data.

### Requirements

  1. Create a database to store the expenses managed by this project

### Implementation

  1. Design a table called expenses that can hold the data for expenses.
  2. This table should have columns named id, amount, memo, and created_on.
  3. Write the SQL to create that table into a file called schema.sql.
  4. Create a database and use schema.sql to setup the database for the application.

### Solution

```sql
CREATE DATABASE expenses_app;
\c expenses_app
```

`schema.sql` file:

```sql
CREATE TABLE expenses (
  id serial PRIMARY KEY,
  amount decimal NOT NULL,
  memo VARCHAR(100) NOT NULL,
  created_on timestamp DEFAULT now()
);
```

```bash
psql -d expenses_app < schema.sql
```

LS solution applies precision to `numeric`, uses `text` instead of `varchar` and uses `date` instead of `timestamp` with no default:

```sql
CREATE TABLE expenses (
  id serial PRIMARY KEY,
  amount numeric(6,2) NOT NULL,
  memo text NOT NULL,
  created_on date NOT NULL
);
```

### Exercises

1. What is the largest value that can be stored in the `amount` column? Use `psql` to illustrate what it is.

The largest value that can be inserted into the `amount` column is `9999.99`. This is because the column is of type `numeric` with a *precision* of `6` - this relates to the total count of digits in the whole number (that is the number of digits to both sides of the decimal point).

To test this we could try inserting a larger value, say `10000.00` like so:

```sql
INSERT INTO expenses (amount, memo, created_on) VALUES
  (10000.00, 'test', '12/01/17');
```

This returns a `numeric field overflow` error:

```sql
ERROR:  numeric field overflow
DETAIL:  A field with precision 6, scale 2 must round to an absolute value less than 10^4.
```

2. What is the smallest value that can be stored in the `amount` column? Use `psql` to illustrate what it is.

The smallest value is `-9999.99`. We can test this like so:

```sql
INSERT INTO expenses (amount, memo, created_on) VALUES
  (-10000.00, 'test', '12/01/17');
```

3. Add a check constraint to the `expenses` table to ensure that `amount` only holds a positive value.

```sql
ALTER TABLE expenses ADD CHECK (amount >= 0.01);
```
