-- Data Engineering Roadmap
-- Week 01 — Intermediate / Advanced SQL
-- Database: Northwind

-- ============================================================
-- Query 01
-- Business question:
-- List products priced above the average product price,
-- ordered from highest to lowest price.
-- Concepts: scalar subquery, AVG, ORDER BY
-- ============================================================

SELECT
    product_name,
    unit_price
FROM
    products
WHERE
    unit_price > (
        SELECT
            AVG(unit_price)
        FROM
            products
    )
ORDER BY
    unit_price DESC;


-- ============================================================
-- Query 02
-- Business question:
-- List the products whose price is equal to the highest price
-- within their own category.
-- Concepts: correlated subquery, MAX
-- ============================================================

SELECT
    p1.product_name,
    p1.unit_price
FROM
    products p1
WHERE
    p1.unit_price = (
        SELECT
            MAX(p2.unit_price)
        FROM
            products p2
        WHERE
            p2.category_id = p1.category_id
    );


-- ============================================================
-- Query 03
-- Business question:
-- Return categories that contain at least 5 products.
-- Concepts: GROUP BY, HAVING, COUNT
-- ============================================================

SELECT
    category_id,
    COUNT(product_id) AS quantidade_produtos
FROM
    products
GROUP BY
    category_id
HAVING
    COUNT(product_id) >= 5;


-- ============================================================
-- Query 04
-- Business question:
-- Rewrite the "products above average price" query using a CTE.
-- Concepts: CTE, scalar subquery, AVG
-- ============================================================

WITH media AS (
    SELECT
        AVG(unit_price) AS media_preco
    FROM
        products
)

SELECT
    product_name,
    unit_price
FROM
    products
WHERE
    unit_price > (
        SELECT
            media_preco
        FROM
            media
    )
ORDER BY
    unit_price DESC;


-- ============================================================
-- Query 05
-- Business question:
-- Show products whose total sales revenue is above the average
-- sales revenue across products.
-- Concepts: CTE, aggregation, JOIN, scalar subquery
-- ============================================================

WITH total_vendido_produto AS (
    SELECT
        product_id,
        SUM(unit_price * quantity * (1 - discount)) AS vendido
    FROM
        order_details
    GROUP BY
        product_id
)

SELECT
    t.product_id,
    p.product_name,
    t.vendido AS total_vendido
FROM
    total_vendido_produto t
INNER JOIN
    products p
    ON t.product_id = p.product_id
WHERE
    t.vendido > (
        SELECT
            AVG(vendido)
        FROM
            total_vendido_produto
    );


-- ============================================================
-- Query 06
-- Business question:
-- List the products whose price is the highest in their category,
-- this time using a CTE.
-- Concepts: CTE, MAX, GROUP BY, JOIN
-- ============================================================

WITH maior_preco_categoria AS (
    SELECT
        category_id,
        MAX(unit_price) AS maior_preco
    FROM
        products
    GROUP BY
        category_id
)

SELECT
    p.product_name,
    p.unit_price
FROM
    products p
INNER JOIN
    maior_preco_categoria m
    ON p.category_id = m.category_id
    AND p.unit_price = m.maior_preco;


-- ============================================================
-- Queries 07–15
-- Add the date, UNION/UNION ALL, EXISTS and CASE exercises here.
-- ============================================================
