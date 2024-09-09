-- Create User Table
CREATE TABLE User (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    UserName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL
);

-- Create Category Table
CREATE TABLE Category (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL,
    Description VARCHAR(255)
);

-- Create Transaction Table
CREATE TABLE Transaction (
    TransactionID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    CategoryID INT,
    Amount DECIMAL(10, 2) NOT NULL,
    Date DATETIME NOT NULL,
    PaymentMethod VARCHAR(20),
    Type ENUM('Income', 'Expense') NOT NULL,
    FOREIGN KEY (UserID) REFERENCES User(UserID),
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);


--Sample Data

-- Insert sample data into User Table
INSERT INTO User (UserName, Email, Password) VALUES
('John Doe', 'john@example.com', 'hashed_password'),
('Jane Smith', 'jane@example.com', 'hashed_password');

-- Insert sample data into Category Table
INSERT INTO Category (CategoryName, Description) VALUES
('Food', 'Expenses related to food and groceries'),
('Transport', 'Expenses related to transport'),
('Salary', 'Monthly income from salary'),
('Utilities', 'Expenses related to utilities like electricity, water, etc.');

-- Insert sample data into Transaction Table
INSERT INTO Transaction (UserID, CategoryID, Amount, Date, PaymentMethod, Type) VALUES
(1, 1, 50.00, '2024-08-31 00:00:00', 'M-pesa', 'Expense'),
(1, 3, 1000.00, '2024-08-31 00:00:00', 'Bank Transfer', 'Income'),
(2, 2, 20.00, '2024-09-01 00:00:00', 'Cash', 'Expense'),
(2, 4, 150.00, '2024-09-01 00:00:00', 'Credit Card', 'Expense');


-- Part 3: SQL Programming
-- Data Retrieval:

-- Retrieve all transactions for a specific user:

SELECT * FROM Transaction WHERE UserID = 1;

-- Retrieve all expenses grouped by category:

SELECT c.CategoryName, SUM(t.Amount) AS TotalExpense
FROM Transaction t
JOIN Category c ON t.CategoryID = c.CategoryID
WHERE t.Type = 'Expense'
GROUP BY c.CategoryName;

--Data Analysis:

-- Analyze total income and expenses for each user:

SELECT u.UserName, 
       SUM(CASE WHEN t.Type = 'Income' THEN t.Amount ELSE 0 END) AS TotalIncome,
       SUM(CASE WHEN t.Type = 'Expense' THEN t.Amount ELSE 0 END) AS TotalExpense
FROM User u
LEFT JOIN Transaction t ON u.UserID = t.UserID
GROUP BY u.UserName;

-- Calculate monthly expenses trend:

SELECT DATE_FORMAT(Date, '%Y-%m') AS Month, 
       SUM(CASE WHEN Type = 'Expense' THEN Amount ELSE 0 END) AS MonthlyExpense
FROM Transaction
GROUP BY Month
ORDER BY Month;