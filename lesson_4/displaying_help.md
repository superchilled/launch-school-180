# Displaying Help

The functionality we built in the previous assignment is currently the expense command's default, as it is run when no arguments are passed along when the program is executed. We ideally want it to be output when the command is passed an argument list, like this:

```bash
$ ./expense list
  1 | 2016-04-05 |        14.56 | Pencils
  2 | 2016-04-05 |         3.29 | Coffee
  3 | 2016-04-05 |        49.99 | Text Editor
```

When no arguments are passed to expense, we want the program to display some help information about its use:

```bash
$ ./expense                    
An expense recording system

Commands:

add AMOUNT MEMO [DATE] - record a new expense
clear - delete all expenses
list - list all expenses
delete NUMBER - remove expense with id NUMBER
search QUERY - list expenses with a matching memo field
```

### Requirements

1. Display a list of expenses when passed the `list` argument, and help content otherwise.

### Implementation

1. Move the existing expense listing code into a method.
2. Add a new method that prints out the help content.
3. Check the value of the first argument passed to the program, and call the appropriate method.

### Solution

```ruby
#! /usr/bin/env ruby

require "pg"

expenses_app_db = PG.connect(dbname: "expenses_app")

def list(db)
  response = db.exec("SELECT * FROM expenses ORDER BY created_on DESC")

  response.each do |tuple|
    puts "#{tuple["id"]} | #{tuple["created_on"]} | #{tuple["amount"].rjust(6,' ')} | #{tuple["memo"]}"
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


command, parameter = ARGV

case command
  when 'list' then list(expenses_app_db)
  else puts help
end
```

LS solution:

```ruby
#! /usr/bin/env ruby

require "pg"

def list_expenses
  connection = PG.connect(dbname: "expenses")

  result = connection.exec("SELECT * FROM expenses ORDER BY created_on ASC")
  result.each do |tuple|
    columns = [ tuple["id"].rjust(3),
                tuple["created_on"].rjust(10),
                tuple["amount"].rjust(12),
                tuple["memo"] ]

    puts columns.join(" | ")
  end
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
else
  display_help
end
```

### Exercises

1. Describe what is happening on line 20 of the Solution shown above.

This is using Ruby's squiggly HEREDOC syntax to ouput a multi-line block of text.
