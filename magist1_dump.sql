USE magist;
select * FROM customers;
SELECT * FROM geo;
SELECT * FROM order_items;
SELECT * FROM order_payments;
SELECT * FROM order_reviews;
SELECT * FROM orders;
SELECT * FROM product_category_name_translation;
SELECT * FROM products;
SELECT COUNT(*) FROM Products;
SELECT * FROM sellers;
SELECT 
    COUNT(*) AS total_orders
FROM 
    orders;
    
    SELECT 
    order_status, 
    COUNT(*) AS order_count
FROM 
    orders
GROUP BY 
    order_status
ORDER BY 
    order_count DESC;
    
    SELECT 
    YEAR(order_purchase_timestamp) AS order_year, 
    MONTH(order_purchase_timestamp) AS order_month, 
    COUNT(order_id) AS total_orders
FROM 
    orders
GROUP BY 
    order_year, 
    order_month
ORDER BY 
    order_year ASC, 
    order_month ASC;
    
    SELECT 
    COUNT(DISTINCT product_id) AS unique_products
FROM 
    products;
    
    SELECT 
    product_category_name, 
    COUNT(product_id) AS product_count
FROM 
    products
GROUP BY 
    product_category_name
ORDER BY 
    product_count DESC;
    
    SELECT 
    COUNT(DISTINCT product_id) AS products_sold
FROM 
    order_items;
    
    SELECT 
    MIN(price) AS cheapest_product, 
    MAX(price) AS most_expensive_product
FROM 
    order_items;
    
    SELECT 
    MIN(payment_value) AS lowest_payment, 
    MAX(payment_value) AS highest_payment
FROM 
    order_payments;