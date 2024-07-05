
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


-- Query to calculate the percentage of completed orders
SELECT 
    ROUND(
        (COUNT(*) FILTER (WHERE status = 'Completed')::decimal / COUNT(*) * 100), 
        2
    ) AS completed_order_percentage
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


-- Query to retrieve detailed order information including order ID, order date, username, product name, quantity, and price at purchase
-- for orders placed between January 1, 2024, and the current date
SELECT
    o.order_id,
    o.order_date,
    u.username,
    p.name,
    oi.quantity,
    oi.price_at_purchase
FROM
    orders o
JOIN
    users u ON u.user_id=o.user_id
JOIN
    order_items oi ON oi.order_id=o.order_id
JOIN
    products p ON p.product_id=oi.product_id
WHERE
    o.order_date BETWEEN '01-01-2024' AND NOW();


-- Query to calculate the total quantity and total revenue for each product category
-- by summing the quantities and revenue from order items, grouped by category ID and category name
SELECT
    p.category_id,
    c.category_name,
    SUM(oi.quantity) as total_quantity,
    SUM(oi.price_at_purchase*oi.quantity) as total_revenue
FROM
    order_items oi
JOIN
    products p ON p.product_id=oi.product_id
JOIN
    categories c ON c.category_id=p.category_id
GROUP BY p.category_id, c.category_name
ORDER BY p.category_id, c.category_name;


-- Query to retrieve product details including product ID, category name, product name, price, and average rating
-- for products priced above the average price of all products
SELECT
    P.product_id,
    c.category_name,
    p.name,
    p.price,
    (SELECT AVG(rating) FROM reviews r WHERE r.product_id=p.product_id) as avg_rating

FROM products p
JOIN categories c on p.category_id=c.category_id
WHERE p.price > (SELECT AVG(price) FROM products);


-- Query to retrieve the top 5 most expensive products
-- including product name, price, and category name, ordered by price in descending order
SELECT 
    p.name AS product_name,
    p.price,
    c.category_name
FROM 
    products p
JOIN 
    categories c ON p.category_id = c.category_id
ORDER BY 
    p.price DESC
LIMIT 5;


-- Query to retrieve products with low stock quantities
-- including product name and stock quantity, ordered by stock quantity in ascending order
SELECT 
    name AS product_name,
    stock_quantity
FROM 
    products
WHERE 
    stock_quantity < 25
ORDER BY 
    stock_quantity ASC;


-- Query to calculate the monthly sales revenue for the current year
SELECT
    EXTRACT(Month FROM o.order_date) AS month,
    ROUND(SUM(oi.quantity * oi.price_at_purchase), 2) AS monthly_revenue
FROM
    orders o
JOIN 
    order_items oi ON o.order_id = oi.order_id
WHERE
    EXTRACT(Year FROM o.order_date) = EXTRACT(Year FROM NOW())
GROUP BY 
    month
ORDER BY 
    month;


-- Query to find products that have not received any reviews
SELECT 
    p.product_id,
    p.name AS product_name
FROM 
    products p
LEFT JOIN 
    reviews r ON p.product_id = r.product_id
WHERE 
    r.review_id IS NULL;


-- Query to calculate the average completed order value per customer
SELECT 
    u.username,
    ROUND(AVG(oi.price_at_purchase * oi.quantity), 2) AS average_order_value
FROM 
    users u
JOIN 
    orders o ON u.user_id = o.user_id
JOIN 
    order_items oi ON o.order_id = oi.order_id
WHERE 
    o.status = 'Completed'
GROUP BY 
    u.username
HAVING
     ROUND(AVG(oi.price_at_purchase * oi.quantity), 2) > 300
ORDER BY 
    average_order_value DESC;
