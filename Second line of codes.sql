# 1 How many months of data are included in the magist database?

SELECT
COUNT(distinct(EXTRACT(YEAR_MONTH FROM order_purchase_timestamp))) AS QUANTITY_OF_MONTHS
FROM
	orders    
ORDER BY
	QUANTITY_OF_MONTHS
;

# 2 How many sellers are there?  

SELECT
	COUNT(DISTINCT seller_id) AS QUANTITY_OF_SELLERS
FROM
	order_items
;


# How many Tech sellers are there?

SELECT
	COUNT(DISTINCT seller_id) AS QUANTITY_OF_TECH_SELLERS
FROM
	order_items i
LEFT JOIN
	products p
ON
	i.product_id = p.product_id
WHERE 
	product_category_name IN ('audio', 'cine_foto', 'consoles_games', 'eletronicos', 'informatica_acessorios', 'pc_gamer', 'pcs', 'telefonia')
;


# What percentage of overall sellers are Tech sellers?

SELECT
	(SELECT
		COUNT(DISTINCT seller_id) 
	FROM
		order_items i
	LEFT JOIN
		products p
	ON
		i.product_id = p.product_id
	WHERE 
		product_category_name IN ('audio', 'cine_foto', 'consoles_games', 'eletronicos', 'informatica_acessorios', 'pc_gamer', 'pcs', 'telefonia')) 
	/
 	COUNT(DISTINCT seller_id)*100 AS PERCENTAGE_TECH
FROM
	order_items
;

# 484/3095*100 = 15,6%


# 3 What is the total amount earned by all sellers?

SELECT
	*
FROM
	order_items i
CROSS JOIN
	orders o
ON
	i.order_id = o.order_id
WHERE 
	o.order_status = 'delivered'
;

SELECT
	SUM(price) AS TOTAL_AMOUNT_EARNED_BY_SELLERS 
FROM
	order_items 
;

SELECT
	ROUND(SUM(op.payment_value)) AS TOTAL_AMOUNT_EARNED_BY_SELLERS # Why does it have so many decimals?
FROM
	order_payments op
RIGHT JOIN
	orders o
ON
	op.order_id = o.order_id
WHERE 
	o.order_status = 'delivered'
;

# What is the total amount earned by all Tech sellers? # Why does it have so many decimals?

SELECT
	ROUND(SUM(op.payment_value)) AS TOTAL_AMOUNT_EARNED_BY_TECH_SELLERS
FROM
	order_payments op
RIGHT JOIN
	orders o
ON
	op.order_id = o.order_id
LEFT JOIN
	order_items oi
ON
	op.order_id = oi.order_id
LEFT JOIN
    products p
ON
	oi.product_id = p.product_id
WHERE o.order_status = 'delivered' AND
	p.product_category_name IN ('audio', 'cine_foto', 'consoles_games', 'eletronicos', 'informatica_acessorios', 'pc_gamer', 'pcs', 'telefonia')
;

# 2794958/15422462*100
# 18,12%

# 4 Can you work out the average monthly income of all sellers?
 
SELECT
	ROUND((SUM(op.payment_value))/(COUNT(DISTINCT(EXTRACT(YEAR_MONTH FROM o.order_purchase_timestamp))))) AS AVG_MONTHLY_INCOME_SELLERS
FROM
	order_payments op
RIGHT JOIN
	orders o
ON
	op.order_id = o.order_id
WHERE 
	o.order_status = 'delivered'
;

# Can you work out the average monthly income of Tech sellers?

SELECT
	ROUND((SUM(op.payment_value))/(COUNT(DISTINCT(EXTRACT(YEAR_MONTH FROM o.order_purchase_timestamp))))) AS AVG_MONTHLY_INCOME_TECH_SELLERS
FROM
	order_payments op
RIGHT JOIN
	orders o
ON
	op.order_id = o.order_id
LEFT JOIN
	order_items oi
ON
	op.order_id = oi.order_id
LEFT JOIN
	products p
ON
	oi.product_id = p.product_id
WHERE 
	o.order_status = 'delivered' AND
	p.product_category_name IN ('audio', 'cine_foto', 'consoles_games', 'eletronicos', 'informatica_acessorios', 'pc_gamer', 'pcs', 'telefonia')
;

SELECT 
    CASE
        WHEN order_estimated_delivery_date <= order_delivered_customer_date THEN 'On Time'
        ELSE 'Delayed'
    END AS delivery_status,
    COUNT(*) AS order_count
FROM orders o
JOIN order_items i ON o.order_id = i.order_id
JOIN products p  ON p.product_id = i.product_id
WHERE product_category_name IN ('audio', 'cine_foto', 'consoles_games', 'eletronicos', 'informatica_acessorios', 'pc_gamer', 'pcs', 'telefonia')
GROUP BY delivery_status;


SELECT 
    CASE
        WHEN DATE(order_estimated_delivery_date) <= DATE(order_delivered_customer_date) THEN 'On Time'
        ELSE 'Delayed'
    END AS delivery_status,
    COUNT(*) AS order_count
FROM orders o
JOIN order_items i ON o.order_id = i.order_id
JOIN products p  ON p.product_id = i.product_id
WHERE product_category_name IN ('audio', 'cine_foto', 'consoles_games', 'eletronicos', 'informatica_acessorios', 'pc_gamer', 'pcs', 'telefonia')
GROUP BY delivery_status
;


SELECT 
    CASE
        WHEN DATEDIFF(order_estimated_delivery_date,order_delivered_customer_date) >0 THEN 'On Time'
        ELSE 'Delayed'
    END AS delivery_status,
    COUNT(*) AS order_count
FROM orders o
LEFT JOIN order_items i ON o.order_id = i.order_id
LEFT JOIN products p  ON p.product_id = i.product_id
WHERE o.order_status = 'delivered' AND product_category_name IN ('audio', 'cine_foto', 'consoles_games', 'eletronicos', 'informatica_acessorios', 'pc_gamer', 'pcs', 'telefonia')
GROUP BY delivery_status
;


IF DATEDIFF(,[Order Estimated Delivery Date],[Order Delivered Customer Date])>0 THEN 'On Time'
ELSE 'Delayed'
;