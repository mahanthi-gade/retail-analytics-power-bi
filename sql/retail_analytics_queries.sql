-- =========================================================
-- RETAIL ANALYTICS END-TO-END SQL ANALYSIS
-- PostgreSQL
-- =========================================================
-- Covers:
-- KPI calculations
-- Revenue and order analysis
-- Customer segmentation
-- Product/category analysis
-- Regional and channel analysis
-- Year-over-year analysis
-- CTEs and window functions
-- Data quality and referential-integrity validation
-- =========================================================


SELECT 
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)), 2) AS total_revenue
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed';


SELECT COUNT(*) AS completed_orders
FROM orders
WHERE order_status = 'Completed';

SELECT 
    ROUND(
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct))
        / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed';

SELECT
    DATE_TRUNC('month', o.order_date) AS month,
    ROUND(
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)),
        2
    ) AS revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY month;


SELECT
    p.category,
    ROUND(
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)),
        2
    ) AS revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY p.category
ORDER BY revenue DESC;


SELECT
    p.category,
    SUM(oi.quantity) AS units_sold,
    ROUND(AVG(oi.unit_price), 2) AS avg_unit_price,
    ROUND(AVG(oi.discount_pct) * 100, 2) AS avg_discount_pct,
    ROUND(
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)),
        2
    ) AS revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY p.category
ORDER BY revenue DESC;


SELECT
    r.region_name,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    SUM(oi.quantity) AS units_sold,
    ROUND(
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)),
        2
    ) AS revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN regions r
    ON o.region_id = r.region_id
WHERE o.order_status = 'Completed'
GROUP BY r.region_name
ORDER BY revenue DESC;


SELECT
    r.region_name,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    ROUND(
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)),
        2
    ) AS revenue,
    ROUND(
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct))
        / COUNT(DISTINCT o.order_id),
        2
    ) AS avg_order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN regions r
    ON o.region_id = r.region_id
WHERE o.order_status = 'Completed'
GROUP BY r.region_name
ORDER BY revenue DESC;



SELECT
    o.channel,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    SUM(oi.quantity) AS units_sold,
    ROUND(
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)),
        2
    ) AS revenue,
    ROUND(
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct))
        / COUNT(DISTINCT o.order_id),
        2
    ) AS avg_order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY o.channel
ORDER BY revenue DESC;



SELECT
    c.customer_segment,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    ROUND(
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)),
        2
    ) AS revenue,
    ROUND(
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct))
        / COUNT(DISTINCT o.order_id),
        2
    ) AS avg_order_value
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_segment
ORDER BY revenue DESC;



SELECT
    o.customer_id,
    c.customer_name,
    c.customer_segment,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    ROUND(
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)),
        2
    ) AS total_revenue
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY
    o.customer_id,
    c.customer_name,
    c.customer_segment
ORDER BY completed_orders DESC, total_revenue DESC;



WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(*) AS completed_orders
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY customer_id
)

SELECT
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE completed_orders > 1) AS repeat_customers,
    COUNT(*) FILTER (WHERE completed_orders = 1) AS one_time_customers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE completed_orders > 1)
        / COUNT(*),
        2
    ) AS repeat_customer_rate
FROM customer_orders;


SELECT
    EXTRACT(YEAR FROM o.order_date)::INT AS year,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    SUM(oi.quantity) AS units_sold,
    ROUND(
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)),
        2
    ) AS revenue,
    ROUND(
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct))
        / COUNT(DISTINCT o.order_id),
        2
    ) AS avg_order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY EXTRACT(YEAR FROM o.order_date)
ORDER BY year;


WITH yearly_sales AS (
    SELECT
        EXTRACT(YEAR FROM o.order_date)::INT AS year,
        COUNT(DISTINCT o.order_id) AS completed_orders,
        ROUND(
            SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)),
            2
        ) AS revenue,
        ROUND(
            SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct))
            / COUNT(DISTINCT o.order_id),
            2
        ) AS avg_order_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY EXTRACT(YEAR FROM o.order_date)
)

SELECT
    year,
    completed_orders,
    revenue,
    avg_order_value,

    ROUND(
        100.0 * (revenue - LAG(revenue) OVER (ORDER BY year))
        / LAG(revenue) OVER (ORDER BY year),
        2
    ) AS revenue_yoy_pct,

    ROUND(
        100.0 * (completed_orders - LAG(completed_orders) OVER (ORDER BY year))
        / LAG(completed_orders) OVER (ORDER BY year),
        2
    ) AS orders_yoy_pct,

    ROUND(
        100.0 * (avg_order_value - LAG(avg_order_value) OVER (ORDER BY year))
        / LAG(avg_order_value) OVER (ORDER BY year),
        2
    ) AS aov_yoy_pct

FROM yearly_sales
ORDER BY year;






SELECT
    EXTRACT(YEAR FROM o.order_date)::INT AS year,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    SUM(oi.quantity) AS units_sold,

    ROUND(
        SUM(oi.quantity)::NUMERIC
        / COUNT(DISTINCT o.order_id),
        2
    ) AS units_per_order,

    ROUND(AVG(oi.unit_price), 2) AS avg_unit_price,

    ROUND(
        AVG(oi.discount_pct) * 100,
        2
    ) AS avg_discount_pct

FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id

WHERE o.order_status = 'Completed'

GROUP BY EXTRACT(YEAR FROM o.order_date)

ORDER BY year;




SELECT
    p.category,

    ROUND(SUM(
        CASE
            WHEN EXTRACT(YEAR FROM o.order_date) = 2024
            THEN oi.quantity * oi.unit_price * (1 - oi.discount_pct)
            ELSE 0
        END
    ), 2) AS revenue_2024,

    ROUND(SUM(
        CASE
            WHEN EXTRACT(YEAR FROM o.order_date) = 2025
            THEN oi.quantity * oi.unit_price * (1 - oi.discount_pct)
            ELSE 0
        END
    ), 2) AS revenue_2025,

    ROUND(
        SUM(
            CASE
                WHEN EXTRACT(YEAR FROM o.order_date) = 2025
                THEN oi.quantity * oi.unit_price * (1 - oi.discount_pct)
                ELSE 0
            END
        )
        -
        SUM(
            CASE
                WHEN EXTRACT(YEAR FROM o.order_date) = 2024
                THEN oi.quantity * oi.unit_price * (1 - oi.discount_pct)
                ELSE 0
            END
        ),
        2
    ) AS revenue_change

FROM orders o

JOIN order_items oi
    ON o.order_id = oi.order_id

JOIN products p
    ON oi.product_id = p.product_id

WHERE o.order_status = 'Completed'

GROUP BY p.category

ORDER BY revenue_change;




SELECT
    EXTRACT(YEAR FROM o.order_date)::INT AS year,

    COUNT(DISTINCT o.order_id) AS orders,

    SUM(oi.quantity) AS units_sold,

    ROUND(
        SUM(oi.quantity)::NUMERIC /
        COUNT(DISTINCT o.order_id),
        2
    ) AS units_per_order,

    ROUND(
        AVG(oi.unit_price),
        2
    ) AS avg_unit_price,

    ROUND(
        AVG(oi.discount_pct) * 100,
        2
    ) AS avg_discount_pct,

    ROUND(
        SUM(
            oi.quantity *
            oi.unit_price *
            (1 - oi.discount_pct)
        ),
        2
    ) AS revenue

FROM orders o

JOIN order_items oi
    ON o.order_id = oi.order_id

JOIN products p
    ON oi.product_id = p.product_id

WHERE o.order_status = 'Completed'
  AND p.category = 'Electronics'

GROUP BY EXTRACT(YEAR FROM o.order_date)

ORDER BY year;




SELECT p.product_name,

    ROUND(SUM(
        CASE
            WHEN EXTRACT(YEAR FROM o.order_date) = 2024
            THEN oi.quantity * oi.unit_price * (1 - oi.discount_pct)
            ELSE 0
        END
    ), 2) AS revenue_2024,

    ROUND(SUM(
        CASE
            WHEN EXTRACT(YEAR FROM o.order_date) = 2025
            THEN oi.quantity * oi.unit_price * (1 - oi.discount_pct)
            ELSE 0
        END
    ), 2) AS revenue_2025,

    ROUND(
        SUM(
            CASE
                WHEN EXTRACT(YEAR FROM o.order_date) = 2025
                THEN oi.quantity * oi.unit_price * (1 - oi.discount_pct)
                ELSE 0
            END
        )
        -
        SUM(
            CASE
                WHEN EXTRACT(YEAR FROM o.order_date) = 2024
                THEN oi.quantity * oi.unit_price * (1 - oi.discount_pct)
                ELSE 0
            END
        ),
        2
    ) AS revenue_change

FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id

WHERE o.order_status = 'Completed'
  AND p.category = 'Electronics'

GROUP BY
    p.product_id,
    p.product_name

ORDER BY revenue_change;


SELECT
    CASE
        WHEN oi.discount_pct = 0 THEN 'No Discount'
        WHEN oi.discount_pct <= 0.10 THEN '1-10%'
        WHEN oi.discount_pct <= 0.20 THEN '11-20%'
        ELSE '20%+'
    END AS discount_bucket,

    COUNT(DISTINCT o.order_id) AS orders,

    SUM(oi.quantity) AS units_sold,

    ROUND(
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)),
        2
    ) AS revenue

FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id

WHERE o.order_status = 'Completed'

GROUP BY
    CASE
        WHEN oi.discount_pct = 0 THEN 'No Discount'
        WHEN oi.discount_pct <= 0.10 THEN '1-10%'
        WHEN oi.discount_pct <= 0.20 THEN '11-20%'
        ELSE '20%+'
    END

ORDER BY revenue DESC;




SELECT
    order_status,
    COUNT(*) AS order_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_orders
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;




-- =========================================================
-- DATA QUALITY & VALIDATION
-- =========================================================

-- 1. Check for duplicate order IDs
SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;


-- 2. Check for duplicate customer IDs
SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- 3. Check for duplicate product IDs
SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;


-- 4. Check for missing critical order fields
SELECT
    COUNT(*) AS invalid_orders
FROM orders
WHERE order_id IS NULL
   OR customer_id IS NULL
   OR order_date IS NULL
   OR order_status IS NULL;


-- 5. Check for invalid order-item values
SELECT
    COUNT(*) AS invalid_order_items
FROM order_items
WHERE quantity IS NULL
   OR quantity <= 0
   OR unit_price IS NULL
   OR unit_price < 0
   OR discount_pct IS NULL
   OR discount_pct < 0
   OR discount_pct > 1;


-- 6. Check for orders with customer IDs not found in customers
SELECT COUNT(*) AS orphan_customer_orders
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- 7. Check for order items with order IDs not found in orders
SELECT COUNT(*) AS orphan_order_items
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;


-- 8. Check for order items with product IDs not found in products
SELECT COUNT(*) AS orphan_product_items
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;


-- 9. Check for orders with region IDs not found in regions
SELECT COUNT(*) AS orphan_region_orders
FROM orders o
LEFT JOIN regions r
    ON o.region_id = r.region_id
WHERE r.region_id IS NULL;


-- 10. Review available order statuses
SELECT
    order_status,
    COUNT(*) AS order_count
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;