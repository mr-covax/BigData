TRUNCATE TABLE
  fact_sales,
  dim_supplier,
  dim_store,
  dim_product,
  dim_seller,
  dim_customer,
  dim_category,
  dim_city,
  dim_country
RESTART IDENTITY CASCADE;

CREATE TEMP TABLE stg_normalized AS
SELECT
  r.row_id AS sale_id,
  r.file_id,
  NULLIF(BTRIM(r.id), '')::INTEGER AS source_sale_id,
  NULLIF(BTRIM(r.sale_customer_id), '')::INTEGER AS source_customer_id,
  CASE
    WHEN NULLIF(BTRIM(r.sale_customer_id), '') IS NOT NULL
      THEN (r.file_id * 100000) + NULLIF(BTRIM(r.sale_customer_id), '')::INTEGER
  END AS customer_id,
  NULLIF(BTRIM(r.sale_seller_id), '')::INTEGER AS source_seller_id,
  CASE
    WHEN NULLIF(BTRIM(r.sale_seller_id), '') IS NOT NULL
      THEN (r.file_id * 100000) + NULLIF(BTRIM(r.sale_seller_id), '')::INTEGER
  END AS seller_id,
  NULLIF(BTRIM(r.sale_product_id), '')::INTEGER AS source_product_id,
  CASE
    WHEN NULLIF(BTRIM(r.sale_product_id), '') IS NOT NULL
      THEN (r.file_id * 100000) + NULLIF(BTRIM(r.sale_product_id), '')::INTEGER
  END AS product_id,
  TO_DATE(NULLIF(BTRIM(r.sale_date), ''), 'MM/DD/YYYY') AS sale_date,
  NULLIF(BTRIM(r.sale_quantity), '')::INTEGER AS sale_quantity,
  NULLIF(BTRIM(r.sale_total_price), '')::NUMERIC(12,2) AS sale_total_price,
  NULLIF(BTRIM(r.customer_first_name), '') AS customer_first_name,
  NULLIF(BTRIM(r.customer_last_name), '') AS customer_last_name,
  NULLIF(BTRIM(r.customer_age), '')::INTEGER AS customer_age,
  NULLIF(BTRIM(r.customer_email), '') AS customer_email,
  COALESCE(NULLIF(BTRIM(r.customer_country), ''), '(unknown)') AS customer_country_name,
  NULLIF(BTRIM(r.customer_postal_code), '') AS customer_postal_code,
  NULLIF(BTRIM(r.customer_pet_type), '') AS customer_pet_type,
  NULLIF(BTRIM(r.customer_pet_name), '') AS customer_pet_name,
  NULLIF(BTRIM(r.customer_pet_breed), '') AS customer_pet_breed,
  NULLIF(BTRIM(r.seller_first_name), '') AS seller_first_name,
  NULLIF(BTRIM(r.seller_last_name), '') AS seller_last_name,
  NULLIF(BTRIM(r.seller_email), '') AS seller_email,
  COALESCE(NULLIF(BTRIM(r.seller_country), ''), '(unknown)') AS seller_country_name,
  NULLIF(BTRIM(r.seller_postal_code), '') AS seller_postal_code,
  NULLIF(BTRIM(r.product_name), '') AS product_name,
  COALESCE(NULLIF(BTRIM(r.product_category), ''), '(unknown)') AS product_category_name,
  NULLIF(BTRIM(r.product_price), '')::NUMERIC(12,2) AS product_price,
  NULLIF(BTRIM(r.product_quantity), '')::INTEGER AS product_quantity,
  NULLIF(BTRIM(r.pet_category), '') AS pet_category,
  NULLIF(BTRIM(r.product_weight), '')::NUMERIC(10,2) AS product_weight,
  NULLIF(BTRIM(r.product_color), '') AS product_color,
  NULLIF(BTRIM(r.product_size), '') AS product_size,
  NULLIF(BTRIM(r.product_brand), '') AS product_brand,
  NULLIF(BTRIM(r.product_material), '') AS product_material,
  NULLIF(BTRIM(r.product_description), '') AS product_description,
  NULLIF(BTRIM(r.product_rating), '')::NUMERIC(3,1) AS product_rating,
  NULLIF(BTRIM(r.product_reviews), '')::INTEGER AS product_reviews,
  TO_DATE(NULLIF(BTRIM(r.product_release_date), ''), 'MM/DD/YYYY') AS product_release_date,
  TO_DATE(NULLIF(BTRIM(r.product_expiry_date), ''), 'MM/DD/YYYY') AS product_expiry_date,
  NULLIF(BTRIM(r.store_name), '') AS store_name,
  NULLIF(BTRIM(r.store_location), '') AS store_location,
  COALESCE(NULLIF(BTRIM(r.store_city), ''), '(unknown)') AS store_city_name,
  COALESCE(NULLIF(BTRIM(r.store_state), ''), '(unknown)') AS store_state_name,
  COALESCE(NULLIF(BTRIM(r.store_country), ''), '(unknown)') AS store_country_name,
  NULLIF(BTRIM(r.store_phone), '') AS store_phone,
  NULLIF(BTRIM(r.store_email), '') AS store_email,
  NULLIF(BTRIM(r.supplier_name), '') AS supplier_name,
  NULLIF(BTRIM(r.supplier_contact), '') AS supplier_contact,
  NULLIF(BTRIM(r.supplier_email), '') AS supplier_email,
  NULLIF(BTRIM(r.supplier_phone), '') AS supplier_phone,
  NULLIF(BTRIM(r.supplier_address), '') AS supplier_address,
  COALESCE(NULLIF(BTRIM(r.supplier_city), ''), '(unknown)') AS supplier_city_name,
  COALESCE(NULLIF(BTRIM(r.supplier_country), ''), '(unknown)') AS supplier_country_name,
  MOD(
    ABS(HASHTEXT(
      COALESCE(NULLIF(BTRIM(r.store_name), ''), '') || '|' ||
      COALESCE(NULLIF(BTRIM(r.store_location), ''), '') || '|' ||
      COALESCE(NULLIF(BTRIM(r.store_city), ''), '(unknown)') || '|' ||
      COALESCE(NULLIF(BTRIM(r.store_state), ''), '(unknown)') || '|' ||
      COALESCE(NULLIF(BTRIM(r.store_country), ''), '(unknown)') || '|' ||
      COALESCE(NULLIF(BTRIM(r.store_phone), ''), '') || '|' ||
      COALESCE(NULLIF(BTRIM(r.store_email), ''), '')
    )::BIGINT),
    2147483647
  )::INTEGER AS store_id,
  MOD(
    ABS(HASHTEXT(
      COALESCE(NULLIF(BTRIM(r.supplier_name), ''), '') || '|' ||
      COALESCE(NULLIF(BTRIM(r.supplier_contact), ''), '') || '|' ||
      COALESCE(NULLIF(BTRIM(r.supplier_email), ''), '') || '|' ||
      COALESCE(NULLIF(BTRIM(r.supplier_phone), ''), '') || '|' ||
      COALESCE(NULLIF(BTRIM(r.supplier_address), ''), '') || '|' ||
      COALESCE(NULLIF(BTRIM(r.supplier_city), ''), '(unknown)') || '|' ||
      COALESCE(NULLIF(BTRIM(r.supplier_country), ''), '(unknown)')
    )::BIGINT),
    2147483647
  )::INTEGER AS supplier_id
FROM raw_data r;

INSERT INTO dim_country (name)
SELECT DISTINCT country_name
FROM (
  SELECT customer_country_name AS country_name FROM stg_normalized
  UNION
  SELECT seller_country_name FROM stg_normalized
  UNION
  SELECT store_country_name FROM stg_normalized
  UNION
  SELECT supplier_country_name FROM stg_normalized
) countries
ORDER BY country_name;

INSERT INTO dim_city (name, state, country_id)
SELECT DISTINCT
  city_data.city_name,
  city_data.state_name,
  c.country_id
FROM (
  SELECT
    store_city_name AS city_name,
    store_state_name AS state_name,
    store_country_name AS country_name
  FROM stg_normalized
  UNION
  SELECT
    supplier_city_name AS city_name,
    '(unknown)' AS state_name,
    supplier_country_name AS country_name
  FROM stg_normalized
) city_data
JOIN dim_country c
  ON c.name = city_data.country_name;

INSERT INTO dim_category (name)
SELECT DISTINCT product_category_name
FROM stg_normalized
ORDER BY product_category_name;

INSERT INTO dim_customer (
  customer_id,
  file_id,
  source_customer_id,
  first_name,
  last_name,
  age,
  email,
  country_id,
  postal_code,
  pet_type,
  pet_name,
  pet_breed
)
SELECT DISTINCT ON (s.file_id, s.source_customer_id)
  s.customer_id,
  s.file_id,
  s.source_customer_id,
  s.customer_first_name,
  s.customer_last_name,
  s.customer_age,
  s.customer_email,
  c.country_id,
  s.customer_postal_code,
  s.customer_pet_type,
  s.customer_pet_name,
  s.customer_pet_breed
FROM stg_normalized s
JOIN dim_country c
  ON c.name = s.customer_country_name
WHERE s.source_customer_id IS NOT NULL
ORDER BY s.file_id, s.source_customer_id, s.sale_id;

INSERT INTO dim_seller (
  seller_id,
  file_id,
  source_seller_id,
  first_name,
  last_name,
  email,
  country_id,
  postal_code
)
SELECT DISTINCT ON (s.file_id, s.source_seller_id)
  s.seller_id,
  s.file_id,
  s.source_seller_id,
  s.seller_first_name,
  s.seller_last_name,
  s.seller_email,
  c.country_id,
  s.seller_postal_code
FROM stg_normalized s
JOIN dim_country c
  ON c.name = s.seller_country_name
WHERE s.source_seller_id IS NOT NULL
ORDER BY s.file_id, s.source_seller_id, s.sale_id;

INSERT INTO dim_product (
  product_id,
  file_id,
  source_product_id,
  name,
  category_id,
  price,
  quantity,
  pet_category,
  weight,
  color,
  size,
  brand,
  material,
  description,
  rating,
  reviews,
  release_date,
  expiry_date
)
SELECT DISTINCT ON (s.file_id, s.source_product_id)
  s.product_id,
  s.file_id,
  s.source_product_id,
  s.product_name,
  cat.category_id,
  s.product_price,
  s.product_quantity,
  s.pet_category,
  s.product_weight,
  s.product_color,
  s.product_size,
  s.product_brand,
  s.product_material,
  s.product_description,
  s.product_rating,
  s.product_reviews,
  s.product_release_date,
  s.product_expiry_date
FROM stg_normalized s
JOIN dim_category cat
  ON cat.name = s.product_category_name
WHERE s.source_product_id IS NOT NULL
ORDER BY s.file_id, s.source_product_id, s.sale_id;

INSERT INTO dim_store (
  store_id,
  name,
  location,
  city_id,
  phone,
  email
)
SELECT DISTINCT
  s.store_id,
  s.store_name,
  s.store_location,
  city.city_id,
  s.store_phone,
  s.store_email
FROM stg_normalized s
JOIN dim_country country_dim
  ON country_dim.name = s.store_country_name
JOIN dim_city city
  ON city.name = s.store_city_name
 AND city.state = s.store_state_name
 AND city.country_id = country_dim.country_id;

INSERT INTO dim_supplier (
  supplier_id,
  name,
  contact,
  email,
  phone,
  address,
  city_id
)
SELECT DISTINCT
  s.supplier_id,
  s.supplier_name,
  s.supplier_contact,
  s.supplier_email,
  s.supplier_phone,
  s.supplier_address,
  city.city_id
FROM stg_normalized s
JOIN dim_country country_dim
  ON country_dim.name = s.supplier_country_name
JOIN dim_city city
  ON city.name = s.supplier_city_name
 AND city.state = '(unknown)'
 AND city.country_id = country_dim.country_id;

INSERT INTO fact_sales (
  sale_id,
  source_file_id,
  source_sale_id,
  customer_id,
  seller_id,
  product_id,
  store_id,
  supplier_id,
  sale_date,
  quantity,
  total_price
)
SELECT
  s.sale_id,
  s.file_id,
  s.source_sale_id,
  c.customer_id,
  se.seller_id,
  p.product_id,
  st.store_id,
  sp.supplier_id,
  s.sale_date,
  s.sale_quantity,
  s.sale_total_price
FROM stg_normalized s
JOIN dim_customer c
  ON c.customer_id = s.customer_id
JOIN dim_seller se
  ON se.seller_id = s.seller_id
JOIN dim_product p
  ON p.product_id = s.product_id
JOIN dim_store st
  ON st.store_id = s.store_id
JOIN dim_supplier sp
  ON sp.supplier_id = s.supplier_id
WHERE s.source_sale_id IS NOT NULL
  AND s.sale_date IS NOT NULL;
