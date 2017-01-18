# Clearing Expenses

### Requirements

1. A user can remove all expenses from the system using a new command, clear.
2. Before deleting all expenses, the program should prompt the user to verify they wish to continue:

```bash
$ ./expense clear
This will remove all expenses. Are you sure? (y/n)
```

3. If the user presses n, then the program should exit without deleting any data:

```bash
$ ./expense clear
This will remove all expenses. Are you sure? (y/n) # press n
$ ./expense list
1 | 2016-04-05 |        14.56 | Pencils
2 | 2016-04-05 |         3.29 | Coffee
3 | 2016-04-05 |        49.99 | Text Editor
4 | 2016-04-06 |         3.59 | Coffee
```

4. If the user presses y, all expenses should be deleted a message should be shown:

```bash
$ ./expense clear
This will remove all expenses. Are you sure? (y/n) # press y
All expenses have been deleted.
$ ./expense list
$
```

### Implementation

1. Create a method in the `ExpenseData` class called `clear_expenses`. The method should:
  * Output a warning and request y/n input
  * Parse the input and either:
    * Exit
    * Delete all data from the table and output a message
2. Add a branch to the `CLI#run` case statement that calls `ExpenseData#clear_expenses`

### Solution

```ruby
#! /usr/bin/env ruby

require "pg"
require "io/console"

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
