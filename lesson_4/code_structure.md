# Code Structure

### Requirements

1. Update the code so it falls in line with the design described in the above video.

### Implementation

1. Move the add_expense and list_expenses methods into a new class, ExpenseData.
2. Move the parameter handling into a new class, CLI. Create an instance of ExpenseData in CLI#initialize.
3. Create a new instance of CLI and call run on it, passing ARGV.

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

    response.each do |tuple|
      data = [
        "#{tuple["id"].rjust(3,' ')}",
        "#{tuple["created_on"]}",
        "#{tuple["amount"].rjust(6,' ')}",
        "#{tuple["memo"]}"
      ]
      puts data.join(' | ')
    end
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
