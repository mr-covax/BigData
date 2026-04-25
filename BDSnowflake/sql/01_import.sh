#!/usr/bin/env bash
set -euo pipefail

export PGPASSWORD="${POSTGRES_PASSWORD}"

FILES=(
	"MOCK_DATA.csv"
	"MOCK_DATA (1).csv"
	"MOCK_DATA (2).csv"
	"MOCK_DATA (3).csv"
	"MOCK_DATA (4).csv"
	"MOCK_DATA (5).csv"
	"MOCK_DATA (6).csv"
	"MOCK_DATA (7).csv"
	"MOCK_DATA (8).csv"
	"MOCK_DATA (9).csv"
)

COLUMNS="id, customer_first_name, customer_last_name, customer_age, customer_email, customer_country, customer_postal_code, customer_pet_type, customer_pet_name, customer_pet_breed, seller_first_name, seller_last_name, seller_email, seller_country, seller_postal_code, product_name, product_category, product_price, product_quantity, sale_date, sale_customer_id, sale_seller_id, sale_product_id, sale_quantity, sale_total_price, store_name, store_location, store_city, store_state, store_country, store_phone, store_email, pet_category, product_weight, product_color, product_size, product_brand, product_material, product_description, product_rating, product_reviews, product_release_date, product_expiry_date, supplier_name, supplier_contact, supplier_email, supplier_phone, supplier_address, supplier_city, supplier_country"

for file_id in "${!FILES[@]}"; do
	file_path="/data/src_data/${FILES[$file_id]}"
	echo "Importing ${file_path} as file_id=${file_id}"

	psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --dbname "${POSTGRES_DB}" <<SQL
TRUNCATE TABLE raw_data_load_buffer;
\copy raw_data_load_buffer (${COLUMNS}) FROM '${file_path}' WITH (FORMAT csv, HEADER true)
INSERT INTO raw_data (
  file_id,
  ${COLUMNS}
)
SELECT
  ${file_id},
  ${COLUMNS}
FROM raw_data_load_buffer;

SQL
done

psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --dbname "${POSTGRES_DB}" <<'SQL'
SELECT file_id, COUNT(*) AS rows_per_file
FROM raw_data
GROUP BY file_id
ORDER BY file_id;
SQL
