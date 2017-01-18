# Many to Many Relationships - Exercises

1. Write a SQL statement that will return the following result:

```sql
 id |     author      |           categories
----+-----------------+--------------------------------
  1 | Charles Dickens | Fiction, Classics
  2 | J. K. Rowling   | Fiction, Fantasy
  3 | Walter Isaacson | Nonfiction, Biography, Physics
(3 rows)
```

Answer:

```sql
SELECT b.id, b.author, string_agg(c.name, ', ') AS categories 
  FROM books b
    INNER JOIN books_categories bc ON b.id = bc.book_id
    INNER JOIN categories c ON bc.category_id = c.id
  GROUP BY b.id;
```

2. Write SQL statements to insert the following new books into the database. What do you need to do to ensure this data fits in the database?

| Author | Title | Categories |
|----|----|----|
| Lynn Sherr | Sally Ride: America's First Woman in Space | Biography, Nonfiction, Space Exploration |
| Charlotte Brontë | Jane Eyre  | Fiction, Classics |
| Meeru Dhalwala and Vikram Vij |  Vij's: Elegant and Inspired Indian Cuisine | Cookbook, Nonfiction, South Asia |

Answer:

To ensure that the data fits you need to increase the size of the title column.

```sql
ALTER TABLE books ALTER COLUMN title TYPE VARCHAR(50);

INSERT INTO books (author, title) VALUES
  ('Lynn Sherr', 'Sally Ride: America''s First Woman in Space'),
  ('Charlotte Brontë', 'Jane Eyre'),
  ('Meeru Dhalwala and Vikram Vij', 'Vij''s: Elegant and Inspired Indian Cuisine');

INSERT INTO categories (name) VALUES
  ('Space Exploration'),
  ('Cookbook'),
  ('South Asia');

INSERT INTO books_categories VALUES
  (4, 5),
  (4, 1),
  (4, 7),
  (5, 2),
  (5, 4),
  (6, 8),
  (6, 1),
  (6, 9);
```

3. Write a SQL statement to add a uniqueness constraint on the combination of columns `book_id` and `category_id` of the `books_categories` table. This constraint should be a table constraint; so, it should check for uniqueness on the combination of `book_id` and `category_id` across all rows of the `books_categories` table.

Answer:

```sql
ALTER TABLE books_categories ADD CONSTRAINT book_category_combination_unique UNIQUE (book_id, category_id);
```

4. Write a SQL statement that will return the following result:

```sql
      name        | book_count |                                 book_titles
------------------+------------+-----------------------------------------------------------------------------
Biography         |          2 | Einstein: His Life and Universe, Sally Ride: America's First Woman in Space
Classics          |          2 | A Tale of Two Cities, Jane Eyre
Cookbook          |          1 | Vij's: Elegant and Inspired Indian Cuisine
Fantasy           |          1 | Harry Potter
Fiction           |          3 | Jane Eyre, Harry Potter, A Tale of Two Cities
Nonfiction        |          3 | Sally Ride: America's First Woman in Space, Einstein: His Life and Universe, Vij's: Elegant and Inspired Indian Cuisine
Physics           |          1 | Einstein: His Life and Universe
South Asia        |          1 | Vij's: Elegant and Inspired Indian Cuisine
Space Exploration |          1 | Sally Ride: America's First Woman in Space
```

Answer:

```sql
SELECT c.name, count(b.id) AS book_count, string_agg(b.title, ', ') AS book_titles
  FROM categories c INNER JOIN books_categories bc ON c.id = bc.category_id
    INNER JOIN books b ON bc.book_id = b.id
  GROUP BY c.name
  ORDER BY c.name;
```
