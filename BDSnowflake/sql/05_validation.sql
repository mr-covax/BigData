SELECT 'raw_data' AS table_name, COUNT(*) AS row_count FROM raw_data
UNION ALL
SELECT 'dim_country', COUNT(*) FROM dim_country
UNION ALL
SELECT 'dim_city', COUNT(*) FROM dim_city
UNION ALL
SELECT 'dim_category', COUNT(*) FROM dim_category
UNION ALL
SELECT 'dim_customer', COUNT(*) FROM dim_customer
UNION ALL
SELECT 'dim_seller', COUNT(*) FROM dim_seller
UNION ALL
SELECT 'dim_product', COUNT(*) FROM dim_product
UNION ALL
SELECT 'dim_store', COUNT(*) FROM dim_store
UNION ALL
SELECT 'dim_supplier', COUNT(*) FROM dim_supplier
UNION ALL
SELECT 'fact_sales', COUNT(*) FROM fact_sales
ORDER BY table_name;

SELECT COUNT(*) AS broken_customers
FROM fact_sales f
LEFT JOIN dim_customer c ON c.customer_id = f.customer_id
WHERE c.customer_id IS NULL;

SELECT COUNT(*) AS broken_sellers
FROM fact_sales f
LEFT JOIN dim_seller s ON s.seller_id = f.seller_id
WHERE s.seller_id IS NULL;

SELECT COUNT(*) AS broken_products
FROM fact_sales f
LEFT JOIN dim_product p ON p.product_id = f.product_id
WHERE p.product_id IS NULL;

SELECT COUNT(*) AS broken_stores
FROM fact_sales f
LEFT JOIN dim_store s ON s.store_id = f.store_id
WHERE s.store_id IS NULL;

SELECT COUNT(*) AS broken_suppliers
FROM fact_sales f
LEFT JOIN dim_supplier s ON s.supplier_id = f.supplier_id
WHERE s.supplier_id IS NULL;
