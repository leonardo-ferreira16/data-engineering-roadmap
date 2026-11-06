# Week 02 — Notes

## Window functions

A window function performs calculations across related rows without collapsing them into one row per group.

### `OVER()`

Defines the window used by the function.

### `PARTITION BY`

Splits the result set into independent groups.

Example:

```sql
ROW_NUMBER() OVER (
    PARTITION BY category_id
    ORDER BY unit_price DESC
)
```

The ranking restarts for each category.

## Ranking functions

### `ROW_NUMBER()`

Assigns a unique sequence even when values are tied.

### `RANK()`

Keeps ties and skips positions after a tie.

Example: 1, 2, 2, 4.

### `DENSE_RANK()`

Keeps ties without skipping positions.

Example: 1, 2, 2, 3.

## `LAG()` and `LEAD()`

`LAG()` accesses a previous row according to the window ordering.

`LEAD()` accesses a following row.

Important: previous and next refer to the order defined inside `OVER()`, not automatically to chronological time.

For chronological comparisons, use an appropriate ordering such as:

```sql
ORDER BY order_date
```

## Window aggregations

### Total per partition

```sql
COUNT(order_id) OVER (
    PARTITION BY customer_id
)
```

Repeats the customer's total number of orders on every order row.

### Running calculation

Adding `ORDER BY` changes the behavior:

```sql
COUNT(order_id) OVER (
    PARTITION BY customer_id
    ORDER BY order_id
)
```

This becomes a running count.

## Running totals

```sql
SUM(faturamento_mes) OVER (
    ORDER BY mes
)
```

The value accumulates as the ordered rows advance.

## Moving average

```sql
AVG(faturamento_mes) OVER (
    ORDER BY mes
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
)
```

The frame contains up to three rows:

- two previous rows
- the current row

The window moves as the query advances.

## `GROUP BY` vs window functions

`GROUP BY` collapses rows into one row per group.

Window functions preserve individual rows and add analytical values alongside them.

## `EXPLAIN`

`EXPLAIN` shows the execution plan PostgreSQL intends to use.

Concepts observed:

- `Seq Scan`: sequential table scan
- `Hash Join`: join strategy using a hash structure
- `HashAggregate`: aggregation strategy used for operations such as `GROUP BY`
- `cost`: optimizer cost estimate, not execution time
- `rows`: estimated number of rows produced by a plan node

A sequential scan is not automatically bad. On small tables it can be cheaper than using an index.

## Review points

Mistakes corrected during the week:

- `ORDER BY ... DESC` changes what `LAG()` considers the previous row.
- `ORDER BY` inside an aggregate window can turn a total into a running calculation.
- A moving frame such as `2 PRECEDING` needs a meaningful `ORDER BY`.
- To filter a result produced by `ROW_NUMBER()`, calculate it in a CTE and filter in the outer query.
