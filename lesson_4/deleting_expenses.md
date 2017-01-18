# Deleting Expenses

### Requirements

1. Allow users to delete specific expenses from the system.

```bash
$ ./expense list
  1 | 2016-04-05 |        14.56 | Pencils
  2 | 2016-04-05 |         3.29 | Coffee
  3 | 2016-04-05 |        49.99 | Text Editor
  4 | 2016-04-06 |         3.59 | Coffee
  5 | 2016-04-06 |        43.23 | Gas for Karen's Car
$ ./expense delete 5
The following expense has been deleted:
  5 | 2016-04-06 |        43.23 | Gas for Karen's Car
$ ./expense list
  1 | 2016-04-05 |        14.56 | Pencils
  2 | 2016-04-05 |         3.29 | Coffee
  3 | 2016-04-05 |        49.99 | Text Editor
  4 | 2016-04-06 |         3.59 | Coffee
```

2. If a user attempts to delete an expense that doesn't exist, an appropriate message should be displayed:

```bash
$ ./expense delete 5
There is no expense with the id '5'.
```

### Implementation

1. Add a `delete` method to the `ExpenseData` class. It should:
  * Use a `SELECT` query to check of the `id` passed to the method exists in the database
    * If the `id` exists it should use a `DELETE` query to remove that tuple
    * If the `id` does not exist is should return `"There is no expense with the id '5'."`
2. Add a branch to the `case` statement in `CLI#run`  to call the `delete` method as necessary.

### Solution

```ruby
#! /usr/bin/env ruby

require "pg"

class ExpenseData
  def initialize
    @expenses_app_db = PG.connect(dbname: "expenses_app")
  end
  

  def list
    response = @expenses_app_db.exec("SELECT * FROM expenses ORDER BY created_on ASC;")

    display_data(response)
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
      display_data(response)
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
