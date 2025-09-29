use bikestores;
SELECT 
	so.order_id,
    CONCAT(sc.first_name,' ',sc.last_name) AS customers_name,
    sc.city,
    sc.state,
    so.order_date,
    SUM(soi.quantity) AS sales_units,
	SUM(soi.quantity*soi.list_price*(1-soi.discount)) AS total_revenues,
    pp.product_name,
    pc.category_name,
    ss.store_name,
    CONCAT(sst.first_name,' ', sst.last_name)AS sales_rep
FROM sales_orders so
INNER JOIN sales_customers sc
ON so.customer_id = sc.customer_id
INNER JOIN sales_order_items soi
ON soi.order_id = so.order_id
INNER JOIN production_products pp
ON pp.product_id = soi.product_id
INNER JOIN production_categories pc
ON pc.category_id = pp.category_id
INNER JOIN sales_stores ss
ON ss.store_id = so.store_id
INNER JOIN sales_staffs sst
ON sst.staff_id = so.staff_id
GROUP BY 
	so.order_id,
	customers_name,
    sc.city,
    sc.state,
    so.order_date,
    pp.product_name,
    pc.category_name,
    ss.store_name,
    sales_rep;
