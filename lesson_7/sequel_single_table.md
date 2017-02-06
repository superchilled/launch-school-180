# Working with a Single Table - Exercises

1. Create a new database called `sequel-single-table` using `psql`.

```bash
createdb sequel-single-table
```

2. Within a `pry` or `irb` session, create a connection to the PostgreSQL database you created in #1. Store this connection object in the constant `DB`.

```pry
require 'sequel'
DB = Sequel.connect("postgres://karl:nikita@localhost/sequel-single-table")
```

3. Use Sequel to create the structure for the following table, `people`. Make sure that `id` is an auto-incrementing primary key.

| id | name | age |  occupation |
|----|----|----|----|
| 1  | Abby | 34 | biologist |
| 2  | Mu'nisah | 26 | NULL |
| 3  | Mirabelle |  40 | contractor |

```pry
DB.create_table(:people) do
  primary_key :id
  String :name
  Integer :age
  String :occupation, :null=>true
end
```

4. Use a method on the `Sequel::Postgres::Database` object held by DB to list the tables in the current database.

```pry
DB.tables
```

5. Use a method on the `Sequel::Postgres::Database` object held by `DB` to describe the columns in the table `people`.

```pry
DB[:people].columns
```

LS Answer:

```pry
DB.schema(:people)
```

http://sequel.jeremyevans.net/rdoc/classes/Sequel/Database.html#method-i-schema

6. Use Sequel to insert the data shown in #3 into the table you just created.

```pry
dataset = DB[:people]

dataset.import([:name, :age, :occupation], [['Abby', 34, 'biologist'], ["Mu\'nisah", 26, nil], ['Mirabelle', 40, 'contractor']])
```

LS Answer inserts rows individually using `insert` (and without using a dataset):

```pry
DB[:people].insert(name: "Abby", age: 34, occupation: "biologist")
DB[:people].insert(name: "Mu'nisah", age: 26)
DB[:people].insert(name: "Mirabelle", age: 40, occupation: "contractor")
```

7. Use Sequel to retrieve the second row of the `people` table in three different ways.

```pry
dataset.where(id: 2)
dataset.where(age: 26)
dataset.where(occupation: nil)
```

LS answer also outputs the return value by calling first on the `Sequel::Dataset` object:

```pry
DB[:people].where(age: 26).first
``


8. What class does `Sequel::Dataset#first` return an instance of?

A `Hash`.

```pry
dataset.where(id: 2).first # => {:id=>2, :name=>"Mu'nisah", :age=>26, :occupation=>nil}
dataset.where(id: 2).first.class # => Hash
```

http://sequel.jeremyevans.net/rdoc/classes/Sequel/Dataset.html#method-i-first

9. What class does `Sequel::Dataset#all` return an instance of?

An `Array` of hashes.

```pry
dataset.all # => => [{:id=>1, :name=>"Abby", :age=>34, :occupation=>"biologist"},
            #        {:id=>2, :name=>"Mu'nisah", :age=>26, :occupation=>nil},
            #        {:id=>3, :name=>"Mirabelle", :age=>40, :occupation=>"contractor"}]

dataset.all.class # => Array
```

http://sequel.jeremyevans.net/rdoc/classes/Sequel/Dataset.html#method-i-all

10. Use Sequel to create a table that can hold the following values. None of the columns should allow null values. Use floating-point numbers to represent `length` and `wingspan`.

| id | name | length | wingspan | family | extinct |
|----|----|----|----|----|----|
| 1  | Spotted Towhee | 21.6 | 26.7 | Emberizidae  | false |
| 2  | American Robin | 25.5 | 36.0 | Turdidae | false |
| 3  | Greater Koa Finch  | 19.0 | 24.0 | Fringillidae | true |
| 4  | Carolina Parakeet |  33.0|  55.8 | Psittacidae |  true |
| 5  | Common Kestrel | 35.5 | 73.5 | Falconidae | false |

```pry
DB.create_table(:birds) do
  primary_key :id
  String :name, null: false
  Float :length, null: false
  Float :wingspan, null: false
  String :family, null: false
  TrueClass :extinct, null: false
end
```

11. Using the table created in #10, write the SQL statements to insert the data as shown in the listing.

```pry
DB[:birds].import([:name, :length, :wingspan, :family, :extinct], 
  [['Spotted Towhee', 21.6, 26.7, 'Emberizidae', false], 
  ['American Robin', 25.5, 36.0, 'Turdidae', false],
  ['Greater Koa Finch', 19.0, 24.0, 'Fringillidae', true], 
  ['Carolina Parakeet', 33.0, 55.8, 'Psittacidae', true], 
  ['Common Kestrel', 35.5, 73.5, 'Falconidae', false]])
```

12. Use Sequel to retrieve all rows from the birds table.

```pry
DB[:birds].all
```

13. Use Sequel to find the names and families for all birds that are not extinct, in order from longest to shortest.

```pry
DB[:birds].select(:name, :family).where(extinct: false).order(Sequel.desc(:length)).all
```

14. Convert the Sequel expression used in the answer to #13 into a SQL string.

```pry
DB[:birds].select(:name, :family).where(extinct: false).order(Sequel.desc(:length)).sql
```

15. Use Sequel to determine the average, minimum, and maximum wingspan for the birds stored in the `birds` table.

Individually:

```pry
DB[:birds].avg(:wingspan)
DB[:birds].min(:wingspan)
DB[:birds].max(:wingspan)
```

All values in one query (usign virtual row block):

```pry
DB[:birds].select{[avg(wingspan), min(wingspan), max(wingspan)]}.first
```

16. Use Sequel to create the table structure shown below, `menu_items`. Make sure that `id` is an auto-incrementing primary key. None of the columns should allow null values, and `item` should be unique.

| id | item | prep_time  | ingredient_cost |  sales |  menu_price |
|----|----|----|----|----|----|
| 1  | omelette | 10 | 1.50 | 182  | 7.99 |
| 2  | tacos |  5 |  2.00 | 254  | 8.99 |
| 3  | oatmeal |  1 |  0.50 | 79 | 5.99 |


```pry
DB.create_table(:menu_items) do
  primary_key :id
  String :item, null: false, unique: true
  Integer :prep_time, null: false
  Numeric :ingredient_cost, size: [4,2], null: false
  Integer :sales, null: false
  Numeric :menu_price, size: [4,2], null: false
end
```

17. Use Sequel to insert the data shown in #16 into the table.

```pry
DB[:menu_items].import([:item, :prep_time, :ingredient_cost, :sales, :menu_price],
  [['omlette', 10, 1.50, 182, 7.99],
   ['tacos', 5, 2.00, 254, 8.99],
   ['oatmeal', 1, 0.50, 79, 5.99]])
```

18. Using the table and data from the last two questions, use Sequel to determine which menu item is the most profitable based on the cost of its ingredients, returning the name of the item and its profit. Keep in mind that `prep_time` is represented in minutes and `ingredient_cost` and `menu_price` are in dollars and cents):

```pry
DB[:menu_items].select do
  [item, Sequel.as(menu_price - ingredient_cost, profit)]
end.order(Sequel.desc(:profit)).first
```

LS answer uses different syntax:

```pry
DB[:menu_items].select { [item, (menu_price - ingredient_cost).as(profit)] }.order(Sequel.desc(:profit)).first
```

19. Convert the Sequel expression used in the answer to #18 into a SQL string.

```pry
DB[:menu_items].select do
  [item, Sequel.as(menu_price - ingredient_cost, profit)]
end.order(Sequel.desc(:profit)).sql
```

20. Convert the value returned for `profit` in #18 into a `Float` object.

```pry
DB[:menu_items].select do
  [item, Sequel.as(Sequel[menu_price - ingredient_cost].cast(:float), profit)]
end.order(Sequel.desc(:profit)).first
```

LS answer converts the value after extracting it returned query:

```pry
result = DB[:menu_items].select { [item, (menu_price - ingredient_cost).as(profit)] }.order(Sequel.desc(:profit)).first
# => {:item=>"tacos", :profit=>#<BigDecimal:7f94ecaa6bc0,'0.699E1',18(18)>}
result[:profit].to_f
# => 6.99
```

21. Create a file called `query.rb`. Within it, connect to the same database as before, "sequel-single-table", and execute queries to determine the profit. Make sure to take into account how much the employee preparing the item would cost, assuming that person is paid $12 an hour.

The program should print the following output when run:

```ruby
$ ruby query.rb
omelette
menu price: $7.99
ingredient cost: $1.50
labor: $2.00
profit: $4.49

tacos
menu price: $8.99
ingredient cost: $2.00
labor: $1.00
profit: $5.99

oatmeal
menu price: $5.99
ingredient cost: $0.50
labor: $0.20
profit: $5.29
```
