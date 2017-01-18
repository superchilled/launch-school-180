# Adding Expenses

Now let's add the ability to add additional expenses through the expense program.

### Requirements

1. Add a command, add, that can be used to add new expenses to the system. It should look like this in use:

```bash
$ ./expense add 3.59 "More Coffee"
$ ./expense list
  1 | 2016-04-05 |        14.56 | Pencils
  2 | 2016-04-05 |         3.29 | Coffee
  3 | 2016-04-05 |        49.99 | Text Editor
  4 | 2016-04-06 |         3.59 | More Coffee
```

2. Make sure that this command is always passed any additional parameters needed to add an expense. If it isn't display an error message:

```bash
$ ./expense add                 
You must provide an amount and memo.
```

### Implementation

1. Define a method that:
  * Takes the various parts of the `ARGV` array
  * Checks to see that there are sufficient parameters (i.e. an amount and a memo)
  * Uses a `SQL` statement to add the data into the database 

### Solution

```ruby
#! /usr/bin/env ruby

require "pg"

expenses_app_db = PG.connect(dbname: "expenses_app")

def list(db)
  response = db.exec("SELECT * FROM expenses ORDER BY created_on DESC;")

  response.each do |tuple|
    puts "#{tuple["id"]} | #{tuple["created_on"]} | #{tuple["amount"].rjust(6,' ')} | #{tuple["memo"]}"
  end
end

def add_expense(db, amount, memo)
  if amount && memo
    amount = amount.to_f
    db.exec("INSERT INTO expenses (memo, amount, created_on) VALUES ('#{memo}', #{amount}, NOW());")
  else
    puts 'You must provide an amount and memo'
  end
end

def help
  "An expense recording system\n" + 
  "\n" + 
  "Commands:\n" + 
  "\n" + 
  "add AMOUNT MEMO [DATE] - record a new expense\n" +
  "clear - delete all expenses\n" +
  "list - list all expenses\n" +
  "delete NUMBER - remove expense with id NUMBER\n" +
  "search QUERY - list expenses with a matching memo field"
end


command, param_1, param_2 = ARGV

case command
  when 'list' then list(expenses_app_db)
  when 'add' then add_expense(expenses_app_db, param_1, param_2)
  else puts help
end

```

LS solution:

```sql
#! /usr/bin/env ruby

require "pg"

CONNECTION = PG.connect(dbname: "expenses")

def list_expenses
  result = CONNECTION.exec("SELECT * FROM expenses ORDER BY created_on ASC")
  result.each do |tuple|
    columns = [ tuple["id"].rjust(3),
                tuple["created_on"].rjust(10),
                tuple["amount"].rjust(12),
                tuple["memo"] ]

    puts columns.join(" | ")
  end
end

def add_expense(amount, memo)
  date = Date.today
  sql = "INSERT INTO expenses (amount, memo, created_on) VALUES (#{amount}, '#{memo}', '#{date}')"
  CONNECTION.exec(sql)
end

def display_help
  puts <<~HELP
    An expense recording system

    Commands:

    add AMOUNT MEMO [DATE] - record a new expense
    clear - delete all expenses
    list - list all expenses
    delete NUMBER - remove expense with id NUMBER
    search QUERY - list expenses with a matching memo field
  HELP
end

command = ARGV.first
if command == "list"
  list_expenses
elsif command == "add"
  amount = ARGV[1]
  memo = ARGV[2]
  abort "You must provide an amount and memo." unless amount && memo
  add_expense(amount, memo)
else
  display_help
end
```

### Exercises

1. Can you see any potential issues with the Solution code above?

Any apostrophe or single-quote characters interpolated into the `sql` string will cause issues.
