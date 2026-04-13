USE magist;
select * FROM customers;
SELECT * FROM geo;
SELECT * FROM order_items;
SELECT * FROM order_payments;
SELECT * FROM order_reviews;
SELECT * FROM orders;
SELECT * FROM product_category_name_translation;
SELECT * FROM products;
SELECT * FROM sellers;
-- What categories of tech products does Magist have?
-- Query to see all unique categories to make your choice
SELECT DISTINCT product_category_name FROM products;
-- How many products of these tech categories have been sold (within the time window of the database snapshot)? What percentage does that represent from the overall number of products sold?
SELECT COUNT(oi.product_id) AS tech_products_sold,
       (COUNT(oi.product_id) / (SELECT COUNT(*) FROM order_items) * 100) AS percentage_of_total
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
WHERE p.product_category_name IN ('informatica_acessorios', 'eletronicos', 'relogios_presentes'); -- Example tech categories
-- What’s the average price of the products being sold?
SELECT AVG(price) FROM order_items;
-- Are expensive tech products popular? *
SELECT 
    CASE WHEN price > 500 THEN 'Expensive' ELSE 'Budget' END AS price_range,
    COUNT(*) AS number_of_sales
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
WHERE p.product_category_name IN ('informatica_acessorios', 'eletronicos')
GROUP BY price_range;
-- How many months of data are included in the magist database?
SELECT 
    TIMESTAMPDIFF(MONTH,
        MIN(order_purchase_timestamp),
        MAX(order_purchase_timestamp)) AS months_count
FROM
    orders;
    -- How many sellers are there? How many Tech sellers are there? What percentage of overall sellers are Tech sellers?
SELECT COUNT(DISTINCT s.seller_id) 
FROM sellers s
JOIN order_items oi ON s.seller_id = oi.seller_id
JOIN products p ON oi.product_id = p.product_id
WHERE p.product_category_name IN ('informatica_acessorios', 'eletronicos');
-- What is the total amount earned by all sellers? What is the total amount earned by all Tech sellers?
SELECT 
    SUM(oi.price) AS tech_total_earnings
FROM
    order_items oi
        JOIN
    products p ON oi.product_id = p.product_id
WHERE
    p.product_category_name IN ('audio' , 'eletronicos',
        'informatica_acessorios',
        'pc_gamer',
        'pcs',
        'relogios_presentes',
        'telefonia');
        -- Can you work out the average monthly income of all sellers? Can you work out the average monthly income of Tech sellers?
SELECT 
    SUM(oi.price) / COUNT(DISTINCT TIMESTAMPDIFF(MONTH, '2016-09-04', o.order_purchase_timestamp)) AS tech_avg_monthly_income
FROM
    order_items oi
JOIN 
    orders o ON oi.order_id = o.order_id
JOIN 
    products p ON oi.product_id = p.product_id
WHERE 
    p.product_category_name IN ('audio', 'eletronicos', 'informatica_acessorios', 'pc_gamer', 'pcs', 'relogios_presentes', 'telefonia');
    -- What’s the average time between the order being placed and the product being delivered?
    SELECT 
    AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) AS avg_delivery_time_days
FROM
    orders
WHERE
    order_status = 'delivered';
    -- How many orders are delivered on time vs orders delivered with a delay?
    SELECT 
    CASE 
        WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 'On Time'
        WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 'Delayed'
        ELSE 'Status Unknown/Not Delivered'
    END AS delivery_performance,
    COUNT(order_id) AS total_orders
FROM 
    orders
WHERE 
    order_status = 'delivered'
GROUP BY 
    delivery_performance;
    -- Is there any pattern for delayed orders, e.g. big products being delayed more often?
    SELECT 
    CASE 
        WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 'On Time'
        ELSE 'Delayed' 
    END AS delivery_status,
    AVG(p.product_weight_g) AS avg_weight_g,
    AVG(p.product_length_cm * p.product_height_cm * p.product_width_cm) AS avg_volume_cm3,
    COUNT(*) AS total_orders
FROM 
    orders o
JOIN 
    order_items oi ON o.order_id = oi.order_id
JOIN 
    products p ON oi.product_id = p.product_id
WHERE 
    o.order_status = 'delivered'
    AND o.order_delivered_customer_date IS NOT NULL
GROUP BY 
    delivery_status;