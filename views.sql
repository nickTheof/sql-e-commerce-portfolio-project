CREATE VIEW UserOrderSummary AS
SELECT 
    u.user_id,
    u.username,
    COUNT(o.order_id) AS total_orders,
    SUM(oi.quantity * oi.price_at_purchase) AS total_spent
FROM 
    users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN order_items oi ON o.order_id = oi.order_id
WHERE 
    o.status IN ('Pending', 'Completed')
GROUP BY 
    u.user_id, u.username;


SELECT * FROM userordersummary;