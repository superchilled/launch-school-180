# Working with Multiple Tables - Exercises

1. Create a new database called `sequel_multiple_tables` using `psql`.

```bash
createdb sequel_multiple_tables
```

2. Import this file into the database created in #1.

```bash
psql -d sequel_multiple_tables < theater_full.sql
```

3. Within a `pry` or `irb` session, create a connection to the PostgreSQL database you created in #1. Store this connection object in the constant `DB`.

```pry
DB = Sequel.connect("postgres://karl:nikita@localhost/sequel_multiple_tables")
```

4. Write a query that determines how many tickets have been sold.

```pry
DB[:tickets].count(:id)
```

LS solution shows that actually you don't need to count a specific column, just count all the tuples:

```pry
DB[:tickets].count
```

5. Write a query that determines how many different customers purchased tickets to at least one event.

```pry
DB[:tickets].distinct(:customer_id).count
```

6. Write a query that determines what percentage of the customers in the database have purchased a ticket to one of the events.

```pry
DB[:customers].join_table(:left_outer, :tickets, :customer_id=>:id).select do
  total_customers = count(Sequel[customers][id]).distinct
  purchasing_customers = count(customer_id).distinct.cast(:float)
  (purchasing_customers / total_customers * 100).as(percentage)
end.first
```

The LS solution uses different syntax/ structure for the query:

```pry
DB[:customers].select {
    (count(tickets__customer_id).distinct / count(customers__id).distinct.cast(Float) * 100).as(:percent)
  }.left_outer_join(:tickets, customer_id: :id).first
```

7. Write a query that returns the name of each event and how many tickets were sold for it, in order from most popular to least popular.

```pry
DB[:events].join_table(:left_outer, :tickets, :event_id=>:id).select do
  [name, count(tickets__id).as(count)]
end.group(:events__id).order(Sequel.desc(:count)).all
```

The LS solution uses different syntax/ structure for the query:

```pry
DB[:events].select { [events__name, count(tickets__id)] }.
left_outer_join(:tickets, event_id: :id).
group(:events__id).
order { count(tickets__id) }.reverse.all
```

8. Write a query that returns the user id, email address, and number of events for all customers that have purchased tickets to three or more events.

```pry
DB[:customers].join(:tickets, :customer_id=>:id).select do
  [customers__id, email, (count(tickets__event_id).distinct).as(event_count)]
end.group(:customers__id).having { count(tickets__event_id).distinct >= 3 }.all
```

The LS solution uses different syntax/ structure for the query:

```pry
DB[:customers].select do
   [customers__id, customers__email, count(tickets__event_id).distinct]
 end.
 left_outer_join(:tickets, customer_id: :id).
 group(:customers__id).
 having { count(tickets__event_id).distinct >= 3 }.all
```

9. Write a query to print out the data needed for a report of all tickets purchased by the customer with the email address 'gennaro.rath@mcdermott.co'. The report will include the event name and starts_at and the seat's section name, row, and seat number.

```pry
DB[:events].join(:tickets, :event_id=>:id).join(:seats, :id=>:seat_id).
join(:sections, :id=>:section_id).
join(:customers, :id=>:tickets__customer_id).select do
  [events__name.as(event), events__starts_at, sections__name, seats__row, seats__number]
end.where(:customers__email => 'gennaro.rath@mcdermott.co').all
```

