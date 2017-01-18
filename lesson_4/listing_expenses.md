# Listing Expenses

Our next step is to connect to the database, execute a query, and print out the results to the screen.

Go ahead and add a few rows to the expenses table using psql so that there will be some data to work with (you can, of course, use whatever expenses you'd like):

```sql
expenses=# INSERT INTO expenses (amount, memo, created_on) VALUES (14.56, 'Pencils', NOW());
INSERT 0 1
expenses=# INSERT INTO expenses (amount, memo, created_on) VALUES (3.29, 'Coffee', NOW());
INSERT 0 1
expenses=# INSERT INTO expenses (amount, memo, created_on) VALUES (49.99, 'Text Editor', NOW());
INSERT 0 1
```

### Requirements

1. Connect to the `expenses` database and print out the information for all expenses in the system.

### Implementation

1. Create a connection to the database using `PG.connect` and assign it to a variable
2. Call the `exec` method on the connection object passing a SQL command to select all the data from the expenses table; assign the return value to a variable
3. Call each on the varaible to print out the data for each row in the table

LS Implementation:

1. Create a connection to the database.
2. Execute a query to retrieve all rows from the `expenses` table, ordered from oldest to newest.
3. Iterate through each result row and print it to the screen. The result should look like this:

```bash
$ ./expense
  1 | 2016-04-05 |        14.56 | Pencils
  2 | 2016-04-05 |         3.29 | Coffee
  3 | 2016-04-05 |        49.99 | Text Editor
```

### Solution

```ruby
#! /usr/bin/env ruby

require "pg"

expenses_app_db = PG.connect(dbname: "expenses_app")

result = expenses_app_db.exec("SELECT * FROM expenses ORDER BY created_on DESC")

result.each do |tuple|
  puts "#{tuple["id"]} | #{tuple["created_on"]} | #{tuple["amount"].rjust(6,' ')} | #{tuple["memo"]}"
end

```

LS solution has a slightly different implementation in that it creates a columns array and uses join:

``ruby
#! /usr/bin/env ruby

require "pg"

connection = PG.connect(dbname: "expenses")

result = connection.exec("SELECT * FROM expenses ORDER BY created_on ASC")
result.each do |tuple|
  columns = [ tuple["id"].rjust(3),
              tuple["created_on"].rjust(10),
              tuple["amount"].rjust(12),
              tuple["memo"] ]

  puts columns.join(" | ")
end
```
