# Counting and Totaling Expenses

### Requirements

1. The `list` command should display a count of expenses in addition to the total of all expenses:

```bash
$ ./expense list
There are 4 expenses.
  1 | 2016-04-07 |        14.56 | Pencils
  2 | 2016-04-07 |         3.29 | Coffee
  3 | 2016-04-07 |        49.99 | Text Editor
  4 | 2016-04-07 |         3.59 | More Coffee
--------------------------------------------------
Total                     71.43
```

2. Additionally, if there are no expenses (which is much more possible now that we've implemented the `clear` command), an appropriate message should be shown:

```bash
$ ./expense list
There are no expenses.
```

3. The same behavior should be provided by the search command:

```bash
$ ./expense search coffee
There are 2 expenses.
  6 | 2016-04-07 |         3.29 | Coffee
  8 | 2016-04-07 |         3.59 | More Coffee
--------------------------------------------------
Total                      6.88
$ ./expense search bananas
There are no expenses.
```

### Implementation

1. Add a new method called `display_count` - it should count the number of rows in the result of the query.
2. Add a new method `display_total`, this should total the cost in the data and output in the required format.
3. Add a new method `display_detailed_data`. This method should:
  * Be called by `search_expenses` and `list`
  * It should check if the data passed is empty and if so display the 'no expenses' message
  * If there is data it should call the new `display_count` method, the existing `display_data` method followed by the new `display_total` method.

### Solution


