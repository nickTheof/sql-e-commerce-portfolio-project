
-- Number of products by product_category-- Query to count the number of different products in each category and order by the count descending
SELECT 
    categories.category_name,
    COUNT(products.product_id) as different_category_products
FROM
    products
JOIN categories ON categories.category_id=products.category_id
GROUP BY categories.category_name
ORDER BY different_category_products DESC;


-- Query to retrieve products of the 'Electronics' category and order them by price in descending order using a subquery
SELECT *
FROM products
WHERE category_id = (
    SELECT category_id
    FROM
        categories
    WHERE
        category_name = 'Electronics'
)
ORDER BY price DESC;


-- Query to retrieve products of the 'Electronics' category and order them by price in descending order using a join
SELECT p.*, c.category_name
FROM products p
JOIN categories c ON p.category_id=c.category_id
WHERE c.category_name='Electronics'
ORDER BY price DESC;


-- Query to count the number of orders by their status
SELECT 
    status as order_status,
    COUNT(order_id)
FROM
    orders
GROUP BY status;


-- Query to retrieve usernames with at least one pending order
SELECT 
    DISTINCT u.username
FROM orders o
JOIN users u ON o.user_id = u.user_id
WHERE o.status IN ('Pending');


-- Query to count the number of pending orders for each username and order by the count descending
SELECT 
    u.username,
    COUNT(o.order_id) as pending_orders
FROM orders o
JOIN users u ON o.user_id = u.user_id
WHERE o.status IN ('Pending')
GROUP BY u.username
ORDER BY pending_orders DESC;

-- Query to calculate the percentage of cancelled orders
SELECT 
    ROUND(
        (COUNT(*) FILTER (WHERE status = 'Cancelled')::decimal / COUNT(*) * 100), 
        2
    ) AS cancelled_order_percentage
FROM 
    orders;


-- Query to count the number of orders grouped by year and month, ordered by year and month
SELECT
    EXTRACT(Year FROM order_date) as year, 
    EXTRACT(Month FROM order_date) as month,
    COUNT(order_id) as number_of_orders
FROM
    orders
GROUP BY year, month
ORDER BY year, month;


-- Query to retrieve orders from the last year
SELECT *
FROM
    orders 
WHERE     order_date >= DATE_TRUNC('year', NOW()) - INTERVAL '1 year'
    AND order_date < DATE_TRUNC('year', NOW());