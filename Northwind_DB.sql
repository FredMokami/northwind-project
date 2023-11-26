CREATE DATABASE NorthwindDB;

USE NorthwindDB;

/* orders table */
CREATE TABLE orders (
	order_id BIGINT NOT NULL,
    customer_id VARCHAR(50) NOT NULL,
    employee_id BIGINT NOT NULL,
    order_date DATE NOT NULL,
    required_date DATE NOT NULL,
    shipped_date DATE,
    shipper_id BIGINT NOT NULL,
    freight DECIMAL(10, 2) NOT NULL, 
    PRIMARY KEY (order_id)
    );
    
ALTER TABLE orders
MODIFY COLUMN order_id BIGINT AUTO_INCREMENT,
AUTO_INCREMENT = 10248;

-- orders QA
SHOW COLUMNS FROM orders;
-- -- --
SELECT COUNT(*) AS record_count,
MAX(order_date) AS most_recent_order_date
FROM orders; 

SELECT * FROM orders LIMIT 5;

SELECT *
FROM orders
WHERE shipped_date IS NULL;
-- -- --

/* order_details table */
CREATE TABLE order_details (
	order_id BIGINT NOT NULL,
	product_id BIGINT NOT NULL,
	unit_price DECIMAL(10, 2) NOT NULL,
	quantity INT NOT NULL,
	discount DECIMAL(6, 2) NOT NULL,
	PRIMARY KEY (order_id, product_id)
	);

-- order_details QA    
SHOW COLUMNS FROM order_details;

-- -- 
SELECT COUNT(*) AS record_count FROM order_details;
SELECT * FROM order_details LIMIT 5;
-- --

/*
Add single PK order_details_id to order_details table
*/

-- Drop the existing primary key
ALTER TABLE order_details
DROP PRIMARY KEY;

-- Add order_details_id column
ALTER TABLE order_details
ADD order_details_id BIGINT AUTO_INCREMENT FIRST,
ADD PRIMARY KEY (order_details_id);

SHOW COLUMNS FROM order_details;

/* customers table */
CREATE TABLE customers (
    customer_id VARCHAR(50) NOT NULL,
    company_name VARCHAR(50) NOT NULL,
    contact_name VARCHAR(50) NOT NULL,
    contact_title VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    PRIMARY KEY (customer_id)
);

-- customers QA
SHOW COLUMNS FROM customers;
SELECT COUNT(*) AS record_count FROM customers;
SELECT * FROM customers LIMIT 5;


/* products table */
CREATE TABLE products (
    product_id BIGINT NOT NULL AUTO_INCREMENT,
    product_name VARCHAR(50) NOT NULL,
    quantity_per_unit VARCHAR(50) NOT NULL,
    unit_price DECIMAL(6, 2) NOT NULL,
    discontinued TINYINT CHECK (discontinued IN (0, 1)) NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (product_id),
    UNIQUE (product_name)
);

-- products QA
SHOW COLUMNS FROM products;
SELECT COUNT(*) AS record_count FROM products;
SELECT * FROM products LIMIT 5;

/* categories table */
CREATE TABLE categories (
    category_id INT NOT NULL AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL,
    category_description VARCHAR(255) NOT NULL,
    PRIMARY KEY (category_id),
    UNIQUE (category_name)
);

-- categories QA
SHOW COLUMNS FROM categories;
SELECT COUNT(*) AS record_count FROM categories;
SELECT * FROM categories;

/* employees table */
CREATE TABLE employees (
    employee_id BIGINT NOT NULL AUTO_INCREMENT,
    employee_name VARCHAR(50) NOT NULL,
    title VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    reports_to BIGINT,
    PRIMARY KEY (employee_id)
);

-- employees QA
SHOW COLUMNS FROM employees;
SELECT COUNT(*) AS record_count FROM employees;

SELECT * 
FROM employees
WHERE reports_to IS NULL;

/* shippers table */
CREATE TABLE shippers (
    shipper_id BIGINT NOT NULL AUTO_INCREMENT,
    company_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (shipper_id),
    UNIQUE (company_name)
);

-- shippers QA
SHOW COLUMNS FROM shippers;
SELECT COUNT(*) AS record_count FROM shippers;
SELECT * FROM shippers;


# REFERENTIAL INTERGRITY ENFORMENT
SELECT @@FOREIGN_KEY_CHECKS; -- Get the Current Value	
SET FOREIGN_KEY_CHECKS=0; -- Disable foreign key check 

-- Orders FKs
ALTER TABLE orders
	ADD FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
	ADD FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
	ADD FOREIGN KEY (shipper_id) REFERENCES shippers(shipper_id);
    
SHOW COLUMNS FROM orders;

-- Order_details FKs
ALTER TABLE order_details
	ADD FOREIGN KEY (order_id) REFERENCES orders(order_id),
	ADD FOREIGN KEY (product_id) REFERENCES products(product_id);
    
SHOW COLUMNS FROM order_details;

-- Products FKs
ALTER TABLE products
	ADD FOREIGN KEY (category_id) REFERENCES categories(category_id);
    
SHOW COLUMNS FROM products;

-- Employees Fks, SELF-REFERENCED
ALTER TABLE employees
	ADD FOREIGN KEY (reports_to) REFERENCES employees(employee_id);
    
SHOW COLUMNS FROM employees;
