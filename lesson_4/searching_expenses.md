# Searching Expenses

### Requirements

1. Allow users to search for expenses that match a specified term:

```bash
$ ./expense search Coffee
2 | 2016-04-05 |         3.29 | Coffee
4 | 2016-04-06 |         3.59 | Coffee
5 | 2016-04-06 |         3.59 | Coffee
```

### Implementation

1. Add a `search` method to the `ExpenseData` class. It should:
  * Send a `SELECT` query to the database with a `WHERE` clause that matches the search term using `LIKE`
  * Assign the return value of the query to a variable
  * Iterate through the data in the variable to produce the desired output
2. Add branch to the `case` statement in `CLI#run` for the `search` option

Note: LS implementation suggests using `ILIKE` (a case-insensitive version of `LIKE` particular to PostgreSQL)

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
