# Working with Todos - Exercises

In this assignment, we'll continue the process of implementing methods in the `DatabasePersistence` class to restore the original functionality of the application. We'll focus on the methods that are required to create, complete, and delete todos.

1. Write a new implementation of `DatabasePersistence#create_new_todo` that inserts new rows into the database.

Answer:

```ruby
def add_todo(list_id, name)
  sql = "INSERT INTO todos (name, list_id) VALUES ($1, $2);"
  query(sql, name, list_id)
end
```

2. Write a new implementation of `DatabasePersistence#delete_todo_from_list` that removes the correct row from the todos table.

Answer:

First of all we need to change this line:

```ruby
@db_storage.delete_todo(@list_id, todo_id)
```

in the `post "/lists/:list_id/todos/:id/destroy"` route to:

```ruby
@db_storage.delete_todo(todo_id)
```

since we no longer need the `list_id` (all todos now have unique ids).

Then we can define the method:

```ruby
def delete_todo(todo_id)
  sql = "DELETE FROM todos WHERE id = $1;"
  query(sql, todo_id)
end
```

3. Write a new implementation of `DatabasePersistence#update_todo_status` that updates a row in the database.

Answer:

```ruby
def update_todo_status(list_id, todo_id, new_status)
  status = new_status ? 't' : 'f'
  sql = "UPDATE todos SET status = $1 WHERE id = $2 AND list_id = $3;"
  query(sql, status, todo_id, list_id)
end
```

4. Write a new implementation of `DatabasePersistence#mark_all_todos_as_completed` that updates a row in the database.

Answer:

```ruby
def complete_all_todos(list_id)
  sql = "UPDATE todos SET status = 't' WHERE list_id = $1;"
  query(sql, list_id)
end
```
