# Setting up a Database Connection - Exercises

1. Why can we call the `map` method directly on an instance of `PG::Result`?

Answer:

This is because the `PG::Result` class includes the `Enumerable` module:

We can see on line 1215 of the [source code](https://github.com/ged/ruby-pg/blob/219f33223b7fa9f3d352e993ccb0eaa598a05e1a/ext/pg_result.c) for the PG gem the following line:

```ruby
rb_include_module(rb_cPGresult, rb_mEnumerable);
```

We can also test this by creating a `PG::Result` object and calling `ancestors` on it:

```ruby
db = PG.connect(dbname: "todos")
result = db.exec("SELECT * FROM lists;")
# => #<PG::Result:0x000000008e5328 status=PGRES_TUPLES_OK ntuples=0 nfields=2 cmd_tuples=0>
result.class # => PG::Result
result.class.ancestors
# => [PG::Result, PG::Constants, Enumerable, Object, JSON::Ext::Generator::GeneratorMethods::Object, Kernel, BasicObject]
```
