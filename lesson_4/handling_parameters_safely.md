# Handling Parameters Safely

### Exercises

1. What happens if you use two placeholders in the first argument to PG::Connection#exec_params, but only one in the Array of values used to fill in those placeholders?

Answer:

You get a `PG::ProtocolViolation` error.

```bash
connection.exec_params("SELECT upper($1), upper($2)", ['test']).values
PG::ProtocolViolation: ERROR:  bind message supplies 1 parameters, but prepared statement "" requires 2
```

2. Update the code within the `add_expense` method to use `exec_params` instead of exec.

```ruby
def add_expense(db, amount, memo)
  if amount && memo
    amount = amount.to_f
    db.exec_params("INSERT INTO expenses (memo, amount, created_on) VALUES ($1, $2, NOW());", [memo, amount])
  else
    puts 'You must provide an amount and memo'
  end
end
```

3. What happens when the same malicious arguments are passed to the program now?

The malicious part of the input (the `DROP TABLE` clause) gets added as part of the memo.
