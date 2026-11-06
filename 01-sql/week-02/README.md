# Week 02 — Window Functions & SQL Performance

This week focused on analytical SQL with PostgreSQL and the Northwind database.

## Topics covered

- `OVER()`
- `PARTITION BY`
- `ORDER BY` inside window functions
- `ROW_NUMBER()`
- `RANK()`
- `DENSE_RANK()`
- `LAG()`
- `LEAD()`
- `SUM() OVER()`
- `AVG() OVER()`
- `COUNT() OVER()`
- Running totals
- Moving averages
- `EXPLAIN` and execution-plan basics

## Analyses built

- Product ranking by price
- Top 3 most expensive products per category
- Previous and next order dates by customer
- Days between customer orders
- Total order revenue
- Running revenue by order
- Moving average over the current row and two previous rows
- Total orders per customer without collapsing detail rows
- Product ranking by total revenue
- Monthly revenue and month-over-month variation
- Monthly cumulative revenue
- Three-month moving average
- Basic execution-plan inspection with `EXPLAIN`

## Key takeaway

Unlike `GROUP BY`, window functions preserve individual rows while adding analytical context such as rankings, previous/next values, totals, and moving calculations.

## Database

Northwind — PostgreSQL

## Files

- `queries.sql`: validated practice queries from the week
- `notes.md`: concepts, observations, and mistakes reviewed during practice
