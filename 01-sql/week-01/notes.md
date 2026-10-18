# Week 01 — Learning Notes

## Concepts I can explain without notes

- Scalar subqueries can return a single value used in comparisons.
- A correlated subquery depends on the current row of the outer query.
- A CTE created with `WITH` can be used as a temporary result set by the main query.
- `GROUP BY` aggregates rows; window functions will be studied next.
- `HAVING` filters aggregated groups, while `WHERE` filters rows.
- A CTE can perform an aggregation once and the outer query can reuse that result.

## Mistakes I made

- Comparing a numeric column directly with the name of a CTE instead of selecting the value from it.
- Forgetting the outer-table alias in a correlated subquery, accidentally comparing a column with itself.
- Re-aggregating data in the outer query even though the CTE had already produced one row per product.
- Comparing different measures, such as quantity sold against average revenue.

## Queries that were difficult

- Total sales revenue by product above the average sales revenue.
- Highest-priced product per category using both correlated subquery and CTE.

## What I learned

- CTEs help split a complex problem into readable steps.
- A CTE is not automatically better than a subquery; clarity and reuse matter.
- After a CTE has already aggregated to one row per entity, the outer query often only needs filtering and enrichment with JOINs.
- Revenue in Northwind can be calculated with `unit_price * quantity * (1 - discount)`.
- Adding aliases consistently makes multi-source SQL much easier to read.

## Topics to review

- EXISTS
- CASE
- Date functions
- UNION vs UNION ALL
