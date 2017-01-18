# Designing a Schema - Exercises

We're going to need to design a database schema that will hold the data for our todo lists and items. The following tables describe the attributes of these entities that we'll need to store:

**List**

  * Has a *unique* name

**Todo**

  * Has a name
  * Belongs to a list
  * Can be completed, but should default to not being completed

We'll also want each table to have an `id` column so we can easily identify specific rows in it.
Exercises

1. Write the SQL statements necessary to create a schema that will hold the data for lists and todos as described above. Include any constraints that are appropriate.

Answer:

```sql
CREATE TABLE lists (
  id serial PRIMARY KEY,
  name text UNIQUE NOT NULL
);

CREATE TABLE todos (
  id serial PRIMARY KEY,
  name text UNIQUE NOT NULL,
  status boolean NOT NULL DEFAULT false,
  list_id integer NOT NULL REFERENCES lists(id)
);
```


2. Create a new file, `schema.sql`, in the project directory. Save the statements written in #1 in this file.

3. Create a new database for this project called `todos`. Execute the SQL file created in #2 in this database using `psql`.

Answer:

```bash
createdb todos
psql -d todos < schema.sql
```
