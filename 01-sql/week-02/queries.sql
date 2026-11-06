-- ============================================================
-- WEEK 02 — WINDOW FUNCTIONS & SQL PERFORMANCE
-- Database: Northwind / PostgreSQL
-- ============================================================


-- ============================================================
-- Query 01
-- Rank all products from highest to lowest price.
-- Concepts: ROW_NUMBER, OVER, ORDER BY
-- ============================================================

SELECT
    product_name,
    unit_price,
    ROW_NUMBER() OVER (
        ORDER BY unit_price DESC
    ) AS posicao_preco
FROM
    products;


-- ============================================================
-- Query 02
-- Rank products by price within each category.
-- Concepts: ROW_NUMBER, PARTITION BY
-- ============================================================

SELECT
    category_id,
    product_name,
    unit_price,
    ROW_NUMBER() OVER (
        PARTITION BY category_id
        ORDER BY unit_price DESC
    ) AS posicao_preco
FROM
    products;


-- ============================================================
-- Query 03
-- Compare ROW_NUMBER, RANK and DENSE_RANK.
-- ============================================================

SELECT
    product_name,
    unit_price,
    ROW_NUMBER() OVER (
        ORDER BY unit_price DESC
    ) AS wf_row_number,
    RANK() OVER (
        ORDER BY unit_price DESC
    ) AS wf_rank,
    DENSE_RANK() OVER (
        ORDER BY unit_price DESC
    ) AS wf_dense_rank
FROM
    products;


-- ============================================================
-- Query 04
-- Return the 3 most expensive products in each category.
-- Concepts: CTE, ROW_NUMBER, Top N per group
-- ============================================================

WITH caro AS (
    SELECT
        category_id,
        product_name,
        unit_price,
        ROW_NUMBER() OVER (
            PARTITION BY category_id
            ORDER BY unit_price DESC
        ) AS posicao
    FROM
        products
)
SELECT
    category_id,
    product_name,
    unit_price,
    posicao
FROM
    caro
WHERE
    posicao <= 3;


-- ============================================================
-- Query 05
-- Show the previous order date for each customer.
-- Concepts: LAG, PARTITION BY
-- ============================================================

SELECT
    customer_id,
    order_id,
    order_date,
    LAG(order_date) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS pedido_anterior
FROM
    orders;


-- ============================================================
-- Query 06
-- Calculate days since the previous order for each customer.
-- Concepts: LAG, CTE, date arithmetic
-- ============================================================

WITH pedidos_anteriores AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        LAG(order_date) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS pedido_anterior
    FROM
        orders
)
SELECT
    customer_id,
    order_id,
    order_date,
    pedido_anterior,
    order_date - pedido_anterior AS dias_desde_pedido_anterior
FROM
    pedidos_anteriores;


-- ============================================================
-- Query 07
-- Show the next order date for each customer.
-- Concepts: LEAD
-- ============================================================

SELECT
    customer_id,
    order_id,
    order_date,
    LEAD(order_date) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS proximo_pedido
FROM
    orders;


-- ============================================================
-- Query 08
-- Calculate revenue per order.
-- Concepts: SUM, GROUP BY
-- ============================================================

SELECT
    order_id,
    SUM(unit_price * quantity * (1 - discount)) AS faturamento_pedido
FROM
    order_details
GROUP BY
    order_id;


-- ============================================================
-- Query 09
-- Calculate running revenue by order.
-- Concepts: SUM OVER, running total
-- ============================================================

WITH faturamento AS (
    SELECT
        order_id,
        SUM(unit_price * quantity * (1 - discount)) AS faturamento_pedido
    FROM
        order_details
    GROUP BY
        order_id
)
SELECT
    order_id,
    faturamento_pedido,
    SUM(faturamento_pedido) OVER (
        ORDER BY order_id
    ) AS faturamento_acumulado
FROM
    faturamento;


-- ============================================================
-- Query 10
-- Calculate a 3-row moving average of order revenue.
-- Concepts: AVG OVER, ROWS BETWEEN
-- ============================================================

WITH faturamento AS (
    SELECT
        order_id,
        SUM(unit_price * quantity * (1 - discount)) AS faturamento_pedido
    FROM
        order_details
    GROUP BY
        order_id
)
SELECT
    order_id,
    faturamento_pedido,
    AVG(faturamento_pedido) OVER (
        ORDER BY order_id
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS media_movel
FROM
    faturamento;


-- ============================================================
-- Query 11
-- Show each order and the customer's total number of orders.
-- Concepts: COUNT OVER, PARTITION BY
-- ============================================================

SELECT
    order_id,
    customer_id,
    COUNT(order_id) OVER (
        PARTITION BY customer_id
    ) AS total_pedidos_cliente
FROM
    orders;


-- ============================================================
-- Query 12
-- Rank products by total revenue.
-- Concepts: JOIN, GROUP BY, DENSE_RANK
-- ============================================================

WITH faturamento AS (
    SELECT
        p.product_name,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) AS faturamento_total
    FROM
        products p
    INNER JOIN
        order_details od
        ON p.product_id = od.product_id
    GROUP BY
        p.product_name
)
SELECT
    product_name,
    faturamento_total,
    DENSE_RANK() OVER (
        ORDER BY faturamento_total DESC
    ) AS posicao_faturamento
FROM
    faturamento;


-- ============================================================
-- Query 13
-- Compare monthly revenue with the previous month.
-- Concepts: DATE_TRUNC, LAG, month-over-month variation
-- ============================================================

WITH faturamento AS (
    SELECT
        DATE_TRUNC('month', o.order_date) AS mes,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) AS faturamento_mes
    FROM
        orders o
    INNER JOIN
        order_details od
        ON o.order_id = od.order_id
    GROUP BY
        DATE_TRUNC('month', o.order_date)
)
SELECT
    mes,
    faturamento_mes,
    LAG(faturamento_mes) OVER (
        ORDER BY mes
    ) AS faturamento_mes_anterior,
    faturamento_mes - LAG(faturamento_mes) OVER (
        ORDER BY mes
    ) AS variacao
FROM
    faturamento;


-- ============================================================
-- Query 14
-- Monthly running revenue and 3-month moving average.
-- Concepts: SUM OVER, AVG OVER, moving window
-- ============================================================

WITH faturamento AS (
    SELECT
        DATE_TRUNC('month', o.order_date) AS mes,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) AS faturamento_mes
    FROM
        orders o
    INNER JOIN
        order_details od
        ON o.order_id = od.order_id
    GROUP BY
        DATE_TRUNC('month', o.order_date)
)
SELECT
    mes,
    faturamento_mes,
    SUM(faturamento_mes) OVER (
        ORDER BY mes
    ) AS faturamento_acumulado,
    AVG(faturamento_mes) OVER (
        ORDER BY mes
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS media_movel
FROM
    faturamento;


-- ============================================================
-- Query 15
-- Inspect the execution plan of product revenue aggregation.
-- Concepts: EXPLAIN, HashAggregate, Hash Join, Seq Scan
-- ============================================================

EXPLAIN
SELECT
    p.product_name,
    SUM(od.unit_price * od.quantity * (1 - od.discount)) AS faturamento
FROM
    products p
INNER JOIN
    order_details od
    ON od.product_id = p.product_id
GROUP BY
    p.product_name;
