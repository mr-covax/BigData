DROP TABLE IF EXISTS fact_sales;
DROP TABLE IF EXISTS dim_supplier;
DROP TABLE IF EXISTS dim_store;
DROP TABLE IF EXISTS dim_product;
DROP TABLE IF EXISTS dim_seller;
DROP TABLE IF EXISTS dim_customer;
DROP TABLE IF EXISTS dim_category;
DROP TABLE IF EXISTS dim_city;
DROP TABLE IF EXISTS dim_country;

CREATE TABLE dim_country (
  country_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE dim_city (
  city_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  state VARCHAR(100) NOT NULL,
  country_id INTEGER NOT NULL REFERENCES dim_country(country_id),
  UNIQUE (name, state, country_id)
);

CREATE TABLE dim_category (
  category_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE dim_customer (
  customer_id INTEGER PRIMARY KEY,
  file_id INTEGER NOT NULL,
  source_customer_id INTEGER NOT NULL,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  age INTEGER,
  email VARCHAR(200),
  country_id INTEGER REFERENCES dim_country(country_id),
  postal_code VARCHAR(20),
  pet_type VARCHAR(50),
  pet_name VARCHAR(100),
  pet_breed VARCHAR(100),
  UNIQUE (file_id, source_customer_id)
);

CREATE TABLE dim_seller (
  seller_id INTEGER PRIMARY KEY,
  file_id INTEGER NOT NULL,
  source_seller_id INTEGER NOT NULL,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  email VARCHAR(200),
  country_id INTEGER REFERENCES dim_country(country_id),
  postal_code VARCHAR(20),
  UNIQUE (file_id, source_seller_id)
);

CREATE TABLE dim_product (
  product_id INTEGER PRIMARY KEY,
  file_id INTEGER NOT NULL,
  source_product_id INTEGER NOT NULL,
  name VARCHAR(200),
  category_id INTEGER REFERENCES dim_category(category_id),
  price NUMERIC(12,2),
  quantity INTEGER,
  pet_category VARCHAR(100),
  weight NUMERIC(10,2),
  color VARCHAR(50),
  size VARCHAR(50),
  brand VARCHAR(100),
  material VARCHAR(100),
  description TEXT,
  rating NUMERIC(3,1),
  reviews INTEGER,
  release_date DATE,
  expiry_date DATE,
  UNIQUE (file_id, source_product_id)
);

CREATE TABLE dim_store (
  store_id INTEGER PRIMARY KEY,
  name VARCHAR(200),
  location VARCHAR(200),
  city_id INTEGER NOT NULL REFERENCES dim_city(city_id),
  phone VARCHAR(50),
  email VARCHAR(200)
);

CREATE TABLE dim_supplier (
  supplier_id INTEGER PRIMARY KEY,
  name VARCHAR(200),
  contact VARCHAR(200),
  email VARCHAR(200),
  phone VARCHAR(50),
  address VARCHAR(200),
  city_id INTEGER NOT NULL REFERENCES dim_city(city_id)
);

CREATE TABLE fact_sales (
  sale_id BIGINT PRIMARY KEY,
  source_file_id INTEGER NOT NULL,
  source_sale_id INTEGER NOT NULL,
  customer_id INTEGER NOT NULL REFERENCES dim_customer(customer_id),
  seller_id INTEGER NOT NULL REFERENCES dim_seller(seller_id),
  product_id INTEGER NOT NULL REFERENCES dim_product(product_id),
  store_id INTEGER NOT NULL REFERENCES dim_store(store_id),
  supplier_id INTEGER NOT NULL REFERENCES dim_supplier(supplier_id),
  sale_date DATE NOT NULL,
  quantity INTEGER,
  total_price NUMERIC(12,2),
  UNIQUE (source_file_id, source_sale_id)
);

CREATE INDEX idx_fact_sales_customer_id ON fact_sales(customer_id);
CREATE INDEX idx_fact_sales_seller_id ON fact_sales(seller_id);
CREATE INDEX idx_fact_sales_product_id ON fact_sales(product_id);
CREATE INDEX idx_fact_sales_store_id ON fact_sales(store_id);
CREATE INDEX idx_fact_sales_supplier_id ON fact_sales(supplier_id);
CREATE INDEX idx_fact_sales_sale_date ON fact_sales(sale_date);
