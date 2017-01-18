# Creating the Schema Automatically

In PostgreSQL, information about the database server is contained in and presented as tables that can be interacted with in the same way as other user-created tables. We're going to take advantage of this to automatically determine if the `expenses` table has been created. If it hasn't, the program should automatically create it before doing anything else.

### Requirements

1. When a user runs the expense program for the first time, it should automatically create any tables it needs within the expenses database (notice there are no errors):

```bash
$ createdb expenses
$ ./expense list
There are no expenses.
```

### Implementation

```bash
expenses=# SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'expenses';
 count
-------
     1
(1 row)
```

If that table does not exist, the `COUNT` will return zero:

```bash
expenses=# SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'doesnotexist';
 count
-------
     0
(1 row)
```

1. Add a new method, setup_schema to ExpenseData. Call this method inside ExpenseData#initialize.
2. Inside setup_schema, use the query described above to see if the expenses table already exists. If it doesn't, create it.

### Solution

```ruby
#! /usr/bin/env ruby

require "pg"
require "io/console"

class ExpenseData
  def initialize
    @expenses_app_db = PG.connect(dbname: "expenses_app")
    setup_schema
  end

  def setup_schema
    expense_table_count = @expenses_app_db.exec("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'expenses';")
    if expense_table_count[0]['count'] == '0'
      @expenses_app_db.exec("CREATE TABLE expenses (id serial PRIMARY KEY, amount numeric(6,2) NOT NULL, memo text NOT NULL, created_on date NOT NULL);")
    end
  end

  def list
    response = @expenses_app_db.exec("SELECT * FROM expenses ORDER BY created_on ASC;")

    display_detailed_data(response)
  end

  def add_expense(amount, memo)
    if amount && memo
      amount = amount.to_f
      sql = "INSERT INTO expenses (memo, amount, created_on) VALUES ($1, $2, NOW());"
      @expenses_app_db.exec_params(sql, [memo, amount])
    else
      puts 'You must provide an amount and memo'
    end
  end

  def search_expenses(search_term)
    if search_term
      sql = "SELECT * FROM expenses WHERE memo ILIKE $1;"
      response = @expenses_app_db.exec_params(sql, [search_term])
      display_detailed_data(response)
    else
      puts 'Please incluse a search term'
    end
  end

  def delete_expense(id)
    id_check_sql = "SELECT * FROM expenses WHERE id = $1;"
    id_check_line = @expenses_app_db.exec_params(id_check_sql, [id])
    if id_check_line.values.empty?
      puts "There is no expense with the id '#{id}'."
    else
      sql = "DELETE FROM expenses WHERE id = $1;"
      @expenses_app_db.exec_params(sql, [id])
      puts "The following expense has been deleted:"
      display_data(id_check_line)
    end
  end

  def clear_expenses
    puts "This will remove all expenses. Are you sure? (y/n)"
    answer = $stdin.getch.downcase
    if answer == 'y'
      @expenses_app_db.exec("DELETE FROM expenses;")
      puts "All expenses have been deleted."
    else
      abort
    end
  end

  def display_data(data)
    data.each do |tuple|
      rows = [
        "#{tuple["id"].rjust(3,' ')}",
        "#{tuple["created_on"]}",
        "#{tuple["amount"].rjust(6,' ')}",
        "#{tuple["memo"]}"
      ]
      puts rows.join(' | ')
    end
  end

  def display_count(count)
    if count == 0
      puts "There are no expenses."
    elsif count == 1
      puts "There is 1 expense."
    else
      puts "There are #{count} expenses."
    end
  end

  def display_total(data)
    total = 0.0
    data.each do |tuple|
      total += tuple["amount"].to_f
    end
    puts "--------------------------------------------------"
    puts "Total #{total.to_s.rjust(19, ' ')}"
  end

  def display_detailed_data(data)
    count = data.ntuples
    display_count(count)
    if count > 0
      display_data(data)
      display_total(data)
    end
  end
end

class CLI
  def initialize
    @data = ExpenseData.new
  end

  def run(input)
    command, param_1, param_2 = input

    case command
      when 'list' then @data.list
      when 'add' then @data.add_expense(param_1, param_2)
      when 'search' then @data.search_expenses(param_1)
      when 'delete' then @data.delete_expense(param_1)
      when 'clear' then @data.clear_expenses
      else display_help
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
end

CLI.new.run(ARGV)

```
