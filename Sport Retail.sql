-- Create the database
    CREATE DATABASE IF NOT EXISTS sports_revenue_db;
    -- Use the database
USE sports_revenue_db;

-- Create the products table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    brand VARCHAR(20),
    category VARCHAR(20),
    product_name VARCHAR(50),
    price DECIMAL(10,2),
    discount DECIMAL(5,2),
    rating DECIMAL(3,2),
    reviews INT
);

-- Create the sales table
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    quantity INT,
    sale_date DATE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert product data
INSERT INTO products VALUES
(1, 'Nike', 'Shoes', 'Air Zoom Pegasus', 120, 10, 4.5, 250),
(2, 'Adidas', 'Shoes', 'Ultraboost 21', 150, 15, 4.7, 300),
(3, 'Nike', 'Tshirt', 'Dri-Fit Tee', 35, 5, 4.2, 180),
(4, 'Adidas', 'Tshirt', 'Sport Tee', 30, 10, 4.0, 160),
(5, 'Nike', 'Jacket', 'Windrunner', 90, 20, 4.6, 210),
(6, 'Adidas', 'Jacket', 'Climacool', 85, 25, 4.4, 190),
(7, 'Nike', 'Shorts', 'Flex Stride', 45, 5, 4.3, 130),
(8, 'Adidas', 'Shorts', 'Run It', 40, 10, 4.1, 140),
(9, 'Nike', 'Shoes', 'Air Max 90', 130, 15, 4.6, 320),
(10, 'Adidas', 'Shoes', 'Gazelle', 110, 10, 4.5, 270);

-- Insert sales data
INSERT INTO sales VALUES
(1, 1, 5, '2024-07-01'),
(2, 2, 3, '2024-07-02'),
(3, 3, 7, '2024-07-03'),
(4, 4, 4, '2024-07-04'),
(5, 5, 2, '2024-07-05'),
(6, 6, 3, '2024-07-06'),
(7, 7, 8, '2024-07-07'),
(8, 8, 6, '2024-07-08'),
(9, 9, 4, '2024-07-09'),
(10, 10, 5, '2024-07-10');


SELECT * FROM products;
SELECT * FROM sales;

-- total revenue per product

SELECT p.brand, p.product_name,
       SUM((p.price - (p.price * p.discount/100)) * s.quantity) AS total_revenue
FROM products p
JOIN sales s ON p.product_id = s.product_id
GROUP BY p.brand, p.product_name
ORDER BY total_revenue DESC;

-- Which brand earns more

SELECT p.brand,
       SUM((p.price - (p.price * p.discount/100)) * s.quantity) AS brand_revenue
FROM products p
JOIN sales s ON p.product_id = s.product_id
GROUP BY p.brand;

-- Find best-selling product in each category

SELECT category, product_name, total_revenue
FROM (
  SELECT p.category, p.product_name,
         SUM((p.price - (p.price * p.discount/100)) * s.quantity) AS total_revenue,
         RANK() OVER (PARTITION BY p.category ORDER BY SUM((p.price - (p.price * p.discount/100)) * s.quantity) DESC) AS rank_in_cat
  FROM products p
  JOIN sales s ON p.product_id = s.product_id
  GROUP BY p.category, p.product_name
) ranked
WHERE rank_in_cat = 1;

-- Compare average ratings between brands

SELECT brand, AVG(rating) AS avg_rating
FROM products
GROUP BY brand;
