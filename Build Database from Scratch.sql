/*
1. Your client wants to track information on their customers (first name, last name, email),
their employees (first name, last name, start date, position held), 
their products, and the purchases customers make (customer, time of purchase, purchase amount),
How to design the database and how these tables should relate to one another?
*/

-- table 1: customers
	-- customer_id
	-- first_name
	-- last_name
	-- email
    
-- table 2: employees
	-- employee_id
    -- first_name
    -- last_name
    -- start_date
    -- position

-- table 3: products
	-- product_id
    -- product_name
    -- launch_date
    
-- table 4: customer_purchases
	-- customer_purchase_id
    -- customer_id
    -- product_id
    -- employee_id
    -- purchase_date
    -- purchase_amount

-- table 5: inventory
    -- product_id
    -- volumn_in_stock

/*
2. Given the database design, create an EER diagram of the database. 
Include primary keys and foreign keys. And make sure to use reasonable data types.
*/    
-- For the answer, please refer to the EER diagram image.

/*
3. Create a new schema that include the diagramed tables. 
*/
CREATE SCHEMA `clientschema` ;

-- Create tables
USE clientschema;
CREATE TABLE `clientschema`.`customers` (
  `customer_id` BIGINT NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`customer_id`));
  
  CREATE TABLE `clientschema`.`employees` (
  `employee_id` BIGINT NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `position` VARCHAR(45) NOT NULL,
  `start_date` DATE NOT NULL,
  PRIMARY KEY (`employee_id`));
  
  CREATE TABLE `clientschema`.`products` (
  `product_id` BIGINT NOT NULL,
  `product_name` VARCHAR(45) NOT NULL,
  `launch_date` DATE NOT NULL,
  PRIMARY KEY (`product_id`));
  
  CREATE TABLE `clientschema`.`customer_purchases` (
  `customer_purchase_id` BIGINT NOT NULL,
  `customer_id` BIGINT NOT NULL,
  `product_id` BIGINT NOT NULL,
  `employee_id` BIGINT NOT NULL,
  `purchase_date` TIMESTAMP NOT NULL,
  `purchase_amount` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`customer_purchase_id`));
  
  CREATE TABLE `clientschema`.`inventory` (
  `inventory_id` BIGINT NOT NULL,
  `product_id` BIGINT NOT NULL,
  `volumn_in_stock` INT NOT NULL,
  PRIMARY KEY (`inventory_id`));
  
-- Use primary and foreign keys to relate tables to one another
ALTER TABLE `clientschema`.`customer_purchases` 
ADD INDEX `cp_customer_id_idx` (`customer_id` ASC) VISIBLE;
;
ALTER TABLE `clientschema`.`customer_purchases` 
ADD CONSTRAINT `cp_customer_id`
  FOREIGN KEY (`customer_id`)
  REFERENCES `clientschema`.`customers` (`customer_id`);
  
ALTER TABLE `clientschema`.`customer_purchases` 
ADD INDEX `cp_product_id_idx` (`product_id` ASC) VISIBLE;
;
ALTER TABLE `clientschema`.`customer_purchases` 
ADD CONSTRAINT `cp_product_id`
  FOREIGN KEY (`product_id`)
  REFERENCES `clientschema`.`products` (`product_id`);
  
ALTER TABLE `clientschema`.`customer_purchases` 
ADD INDEX `cp_employee_id_idx` (`employee_id` ASC) VISIBLE;
;
ALTER TABLE `clientschema`.`customer_purchases` 
ADD CONSTRAINT `cp_employee_id`
  FOREIGN KEY (`employee_id`)
  REFERENCES `clientschema`.`employees` (`employee_id`);
  

ALTER TABLE `clientschema`.`inventory` 
ADD INDEX `inv_product_id_idx` (`product_id` ASC) VISIBLE;
;
ALTER TABLE `clientschema`.`inventory` 
ADD CONSTRAINT `inv_product_id`
  FOREIGN KEY (`product_id`)
  REFERENCES `clientschema`.`products` (`product_id`);

/*
4. Add constraints to columns of tables (besides non-null).
*/
ALTER TABLE `clientschema`.`customers` 
ADD UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE;

ALTER TABLE `clientschema`.`products` 
ADD UNIQUE INDEX `product_name_UNIQUE` (`product_name` ASC) VISIBLE;

ALTER TABLE `clientschema`.`inventory` 
ADD UNIQUE INDEX `product_id_UNIQUE` (`product_id` ASC) VISIBLE;

/* 
5. Insert data into tables.
*/

SELECT * FROM customers;
INSERT INTO customers VALUES 
(1, 'Alice', 'Li', 'aliceli@gmail.com'),
(2, 'Darcie', 'Milgrom', 'darcie10@outlook.com'),
(3, 'Carol', 'Hope', 'carolhope@gmail.com');

SELECT * FROM employees;
INSERT INTO employees VALUES 
(1, 'William', 'Gardener', 'salesperson', '2021-09-02'),
(2, 'Daniel', 'Stark', 'accountant', '2017-05-03'),
(3, 'Arya', 'Potter', 'manager', '2020-11-18');

SELECT * FROM products;
INSERT INTO products VALUES 
(1, 'Bed Mattress', '2016-08-13'),
(2, 'Bathing Towel', '2012-06-21'),
(3, 'Hand Soap', '2019-10-07');

SELECT * FROM customer_purchases;
INSERT INTO customer_purchases VALUES 
(1, 2, 1, 3, '2022-07-11 08:21:33', 10.59),
(2, 1, 3, 2, '2022-05-19 11:42:56', 55.31),
(3, 3, 2, 1, '2021-12-30 23:29:05', 67.34);

SELECT * FROM inventory;
INSERT INTO inventory VALUES 
(1, 1, 31),
(2, 2, 17),
(3, 3, 6);

/*
6. Create trigger on inventory table for each insert into customer purchases.
*/
DROP TRIGGER IF EXISTS updateinventory;

CREATE TRIGGER updateinventory
AFTER INSERT ON customer_purchases
FOR EACH ROW
	UPDATE inventory
    SET volumn_in_stock = volumn_in_stock - 1
    WHERE inventory.product_id = NEW.product_id;

INSERT INTO customer_purchases VALUES
(4, 2, 3, 1, '2021-12-09 07:25:41', 4.33),
(5, 1, 1, 2, '2022-06-08 10:24:54', 9.85);

SELECT * FROM inventory;

