# Working with Lists - Exercises

In this assignment, we'll continue the process of implementing methods in the `DatabasePersistence` class to restore the original functionality of the application. We'll focus on the methods that are required to create, edit, and delete lists.

1. Write a new implementation of `DatabasePersistence#create_new_list` that inserts new rows into the database.

Answer:

```ruby
def add_list(list_name)
  sql = "INSERT INTO lists (name) VALUES ($1);"
  result = query(sql, list_name)
end
```

2. Write a new implementation of `DatabasePersistence#delete_list` that removes the correct row from the `lists` table.

Answer:

First we need to alter the table so that todos are also deleted when a list is deleted:

```sql
ALTER TABLE todos DROP CONSTRAINT todos_list_id_fkey,
ADD CONSTRAINT todos_list_id_fkey FOREIGN KEY (list_id)
REFERENCES lists(id)
ON DELETE CASCADE;
ALTER TABLE
```

Then we can amend the method definition:

```ruby
def destroy_list(id)
  sql = "DELETE FROM lists WHERE id = $1;"
  result = query(sql, id)
end
```


3. Write a new implementation of `DatabasePersistence#update_list_name` that updates a row in the database.

Answer:

```ruby
def update_list_name(id, list_name)
  sql = "UPDATE lists SET name = $1 WHERE id = $2;"
  query(sql, list_name, id)
end
```
