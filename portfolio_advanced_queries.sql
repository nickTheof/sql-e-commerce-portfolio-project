-- Query to retrieve product sales data including product ID, product name, order date, quantity sold,
-- and running total sales for each product, partitioned by product ID and ordered by order date

SELECT 
    p.product_id,
    p.name,
    o.order_date,
    oi.quantity,
    SUM(oi.quantity) OVER(PARTITION BY oi.product_id ORDER BY o.order_date) as running_total_sales

FROM products p
JOIN order_items oi ON oi.product_id = p.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status IN ('Completed', 'Pending')
ORDER BY p.product_id, o.order_date;



-- Query to calculate the total revenue for each product and rank products by revenue
-- including product ID, product name, total revenue, and revenue rank

SELECT 
    p.product_id,
    p.name,
    SUM(oi.quantity * oi.price_at_purchase) AS total_revenue,
    RANK() OVER (ORDER BY SUM(oi.quantity * oi.price_at_purchase) DESC) AS revenue_rank
FROM products p
JOIN order_items oi ON oi.product_id = p.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status IN ('Completed', 'Pending')
GROUP BY p.product_id, p.name
ORDER BY revenue_rank;


-- Query to calculate a 3-period moving average of quantity sold for each product
-- including product ID, product name, order date, quantity, and moving average
SELECT 
    p.product_id,
    p.name,
    o.order_date,
    oi.quantity,
    AVG(oi.quantity) OVER (PARTITION BY p.product_id ORDER BY o.order_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg
FROM products p
JOIN order_items oi ON oi.product_id = p.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status IN ('Completed', 'Pending')
ORDER BY p.product_id, o.order_date;



-- Query to calculate cumulative revenue for each user
-- including user ID, username, order date, order revenue, and cumulative revenue

SELECT
    u.user_id,
    u.username,
    o.order_date,
    oi.price_at_purchase*oi.quantity as order_revenue,
    SUM(oi.price_at_purchase*oi.quantity) OVER (PARTITION BY u.user_id ORDER BY o.order_date) as cumulative_revenue
FROM users u
JOIN orders o ON o.user_id = u.user_id
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status IN ('Completed')
ORDER BY u.user_id, o.order_date;


-- -- Query to calculate the top 5 products by revenue for each category
-- including product ID, product name, category name, total revenue, and sales rank

WITH ProductSales AS (
    SELECT
        p.product_id,
        p.name,
        c.category_name,
        SUM(oi.quantity * oi.price_at_purchase) AS total_revenue,
        RANK() OVER (PARTITION BY p.category_id ORDER BY SUM(oi.quantity * oi.price_at_purchase) DESC) AS sales_rank
    FROM
        products p
        JOIN categories c ON p.category_id = c.category_id
        JOIN order_items oi ON p.product_id = oi.product_id
        JOIN orders o ON o.order_id = oi.order_id
    WHERE 
        o.status = 'Completed'
    GROUP BY
        p.product_id, p.name, c.category_name
)
SELECT
    product_id,
    name,
    category_name,
    total_revenue,
    sales_rank
FROM
    ProductSales
WHERE
    sales_rank <= 5
ORDER BY
    category_name, sales_rank;


-- Query to calculate the total revenue for each product and its percentage of the total revenue
-- including product ID, product name, total product revenue, and percentage of total revenue

SELECT 
    p.product_id,
    p.name,
    SUM(oi.price_at_purchase * oi.quantity) as total_product_revenue,
    ROUND(SUM(oi.price_at_purchase * oi.quantity)/(SELECT SUM(oi.price_at_purchase * oi.quantity) FROM order_items oi JOIN orders o ON o.order_id=oi.order_id WHERE o.status='Completed')*100,2) as percentage_of_total
FROM products p
JOIN order_items oi ON oi.product_id = p.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY p.product_id, p.name;

