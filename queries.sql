CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2)
);

CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE OrderDetails (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);


INSERT INTO Customers (name, email, city) VALUES 
('Alice', 'alice@example.com', 'New York'),
('Bob', 'bob@example.com', 'Los Angeles'),
('Charlie', 'charlie@example.com', 'Chicago');

INSERT INTO Products (name, category, price) VALUES
('Laptop', 'Electronics', 1200.00),
('Headphones', 'Electronics', 100.00),
('Coffee Maker', 'Home', 80.00);

INSERT INTO Orders (customer_id, order_date) VALUES
(1, '2025-04-01'),
(2, '2025-04-02'),
(1, '2025-04-03');

INSERT INTO OrderDetails (order_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 2, 2),
(2, 3, 1),
(3, 2, 1);


SELECT name, city FROM Customers WHERE city = 'New York' ORDER BY name;

SELECT o.order_id, c.name AS customer_name, o.order_date
FROM Orders o
INNER JOIN Customers c ON o.customer_id = c.customer_id;

SELECT p.name AS product_name, IFNULL(od.quantity, 0) AS quantity_sold
FROM Products p
LEFT JOIN OrderDetails od ON p.product_id = od.product_id;


SELECT p.name, SUM(od.quantity) AS total_quantity_sold
FROM Products p
JOIN OrderDetails od ON p.product_id = od.product_id
GROUP BY p.name;


SELECT name FROM Customers
WHERE customer_id IN (
    SELECT customer_id FROM Orders
    GROUP BY customer_id
    HAVING COUNT(*) > 1
);

CREATE VIEW customer_orders_summary AS
SELECT c.name AS customer_name, COUNT(o.order_id) AS total_orders
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.name;


SELECT * FROM customer_orders_summary;

CREATE INDEX idx_orders_customer_id ON Orders(customer_id);
