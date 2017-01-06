# Working with Multiple Tables - Exercises

1. Import this file into an empty PostgreSQL database.

```bash
createdb test2
psql -d test2 < theater_full.sql
```

2. Write a query that determines how many tickets have been sold.

```sql
SELECT count(id) AS tickets_sold FROM tickets;
```

3. Write a query that determines how many different customers purchased tickets to at least one event.

```sql
SELECT count(DISTINCT customer_id) FROM tickets;
```

4. Write a query that determines what percentage of the customers in the database have purchased a ticket to one of the events.

```sql
SELECT round((t.ticket_count / cast(c.customer_count AS DECIMAL (9,2)) * 100),2) FROM
(SELECT count(DISTINCT customer_id) AS ticket_count FROM tickets) AS t,
(SELECT count(id) AS customer_count FROM customers) AS c;
```

LS solution uses  a join rather than sub queries:

```sql
SELECT COUNT(DISTINCT tickets.customer_id) / COUNT(DISTINCT customers.id)::float * 100 AS percent
  FROM customers
  LEFT OUTER JOIN tickets ON tickets.customer_id = customers.id
```

5. Write a query that returns the name of each event and how many tickets were sold for it, in order from most popular to least popular.

```sql
SELECT e.name AS event_name, count(t.id) AS tickets_sold 
  FROM events AS e LEFT OUTER JOIN tickets AS t ON e.id = t.event_id 
  GROUP BY event_name ORDER BY tickets_sold DESC;
```

6. Write a query that returns the user id, email address, and number of events for all customers that have purchased tickets to three events.

```sql
SELECT c.id, c.email, count(DISTINCT t.event_id) AS event_count 
  FROM customers AS c INNER JOIN tickets AS t ON c.id = t.customer_id
  GROUP BY c.id
  HAVING count(DISTINCT t.event_id) = 3;
```

7. Write a query to print out a report of all tickets purchased by the customer with the email address 'gennaro.rath@mcdermott.co'. The report should include the event name and starts_at and the seat's section name, row, and seat number.

```sql
SELECT e.name AS event, e.starts_at, sc.name AS section, s.row, s.number AS seat
  FROM events e INNER JOIN tickets t ON e.id = t.event_id
    INNER JOIN seats s ON t.seat_id = s.id
    INNER JOIN sections sc ON sc.id = s.section_id
    WHERE t.id IN
      (SELECT t.id FROM tickets t INNER JOIN customers c
        ON t.customer_id = c.id
        WHERE c.email = 'gennaro.rath@mcdermott.co');
```

LS solution does not use a sub-query:

```sql
SELECT events.name AS event, events.starts_at, sections.name AS section, seats.row, seats.number AS seat
  FROM tickets
    INNER JOIN events on tickets.event_id = events.id
    INNER JOIN customers ON tickets.customer_id = customers.id
    INNER JOIN seats ON tickets.seat_id = seats.id
    INNER JOIN sections ON seats.section_id = sections.id
WHERE customers.email = 'gennaro.rath@mcdermott.co';
```

My solution re-written without the sub-query:

```sql
SELECT e.name AS event, e.starts_at, sc.name AS section, s.row, s.number AS seat
  FROM events e 
    INNER JOIN tickets t ON e.id = t.event_id
    INNER JOIN seats s ON t.seat_id = s.id
    INNER JOIN sections sc ON sc.id = s.section_id
    INNER JOIN customers c ON t.customer_id = c.id
WHERE c.email = 'gennaro.rath@mcdermott.co';
```
