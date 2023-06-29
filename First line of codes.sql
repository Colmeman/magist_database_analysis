# 1

SELECT
	COUNT(*) AS orders_count
FROM
	orders
;
    
# 2

SELECT
	order_status,
    COUNT(order_status) 
FROM 
	orders
GROUP BY
	order_status
;

# 3

SELECT
	YEAR(order_purchase_timestamp) AS year_,
    MONTH(order_purchase_timestamp) AS month_,
    COUNT(customer_id)
FROM
	orders
GROUP BY
	 year_, 
     month_
ORDER BY
	year_, 
     month_
;

# 4

SELECT
	COUNT(DISTINCT(product_id)) As products_count
 FROM
	products
;

# 5

SELECT
	product_category_name,
    COUNT(DISTINCT(product_id)) AS products_per_category
FROM
	products
GROUP BY
	product_category_name
ORDER BY COUNT(product_id) DESC
;

# 6

SELECT
	COUNT(DISTINCT(product_id)) AS products_per_category
FROM
	order_items
;

#

SELECT
	product_category_name,
	COUNT(DISTINCT(product_id)) AS products_per_category
FROM
	products
LEFT JOIN
	order_items
ON
	products.product_id = order_items.product_id
GROUP BY
	product_category_name
;


# 7

SELECT
	MAX(price) AS most_expensive_product,
    MIN(price) AS cheapest_product
FROM
	order_items
;

# 8

SELECT
	MAX(payment_value) AS highest_payment_value,
    MIN(payment_value) AS lowest_payment_value
FROM
	order_payments
;


SELECT
	*
FROM
	order_Payments
ORDER BY
	payment_value
DESC
LIMIT 10
;
