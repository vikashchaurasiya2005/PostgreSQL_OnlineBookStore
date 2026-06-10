CREATE database onlinebookstore;
--BOOK TABLE
CREATE TABLE Books(
Book_ID SERIAL PRIMARY KEY,
Title VARCHAR(100),
Author VARCHAR(100),
Genre VARCHAR(50),
Published_Year INT,
Price NUMERIC(10,2),
Stock INT
) ;

--CUSTOMER TABLE
CREATE TABLE Customers(
Customer_ID SERIAL PRIMARY KEY,
Name VARCHAR(100),
Email VARCHAR(100),
Phone VARCHAR(15),
City VARCHAR(50),
Country VARCHAR(150)
);

--ORDER TABLE
CREATE TABLE Orders(
Order_ID SERIAL PRIMARY KEY,
Customer_ID INT REFERENCES Customers(Customer_ID),
Books_ID INT REFERENCES Books(Book_ID),
Order_Date DATE,
Quantity INT,
Total_Amount NUMERIC(10,2)
);

--CHECK ALL TABLE
SELECT*FROM Books;
SELECT*FROM Customers;
SELECT*FROM Orders;


--- ALL TABLE CVS FILE CONNECT
COPY Orders
FROM 'C:/Users/vikas/OneDrive/Desktop/30 Day - SQL Practice Files/Orders.csv'
DELIMITER ','
CSV HEADER;

COPY Customers
FROM 'C:/Users/vikas/OneDrive/Desktop/30 Day - SQL Practice Files/Customers.csv'
DELIMITER ','
CSV HEADER;

COPY Books
FROM 'C:/Users/vikas/OneDrive/Desktop/30 Day - SQL Practice Files/Books.csv'
DELIMITER ','
CSV HEADER;


--Normal QUESTION
--Retrive all books in the "fiction" genre
SELECT*FROM Books 
WHERE Genre='Fiction';


--Find books published after the year 1950
SELECT*FROM Books
WHERE published_year>'1950';


--List all customer from the canada
SELECT*FROM Customers
WHERE Country='Canada';


--show order placed in november 2023
SELECT*FROM Orders
WHERE Order_date BETWEEN '2023-11-01' AND '2023-11-30';


--Retrieve the total stock of books available
SELECT SUM(stock) AS Total_Stoc
FROM Books;


--find the details of the most expensive book
SELECT*FROM Books Order BY Price DESC LIMIT 5;


---show all customer who ordered more than 1 quqntity of a book
SELECT*FROM Orders
WHERE Quantity>'1';


-- Retrieve all order where the total amount exceeds &20
SELECT*FROM Orders
WHERE total_amount>20;


--- list all genre available in the books table
SELECT DISTINCT(genre) FROM Books;


--find the book with the lowest stock
SELECT*FROM Books ORDER BY stock limit 1;


---calculate the total revenue geneareted from all order 
SELECT SUM(total_amount) as Revenue FROM Orders;

--ADVANCED QUESTION

--1) RETRIVE THE TOTAL NUMBER OF BOOKS SOLD FOR EACH GENRE
SELECT*FROM Orders;
 SELECT b.Genre ,SUM(o.Quantity) AS Total_Books_Sold
 From Orders o
 JOIN Books b ON o.books_id = b.books_id
 GROUP BY b.Genre;



 --2) Find the average price of books in the 'fantasty' genre
 SELECT AVG (price) AS Average_price
 FROM Books
 WHERE Genre ='Fantasy';



 --3) List customer who have placed at least 2 order
SELECT  o.customer_id, c.name, 
COUNT(o.order_id) AS ORDER_COUNT
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(o.order_id) >= 2;



--4)Find the most frequently ordered book:
SELECT o.books_id, b.title, 
COUNT(o.order_id) AS ORDER_COUNT
FROM orders o
JOIN books b ON o.books_id = b.book_id
GROUP BY o.books_id, b.title
ORDER BY ORDER_COUNT DESC 
LIMIT 1;



--5) Show the top 3 most expensive books of 'Fantasy' Genre:
SELECT * FROM books
WHERE genre = 'Fantasy'
ORDER BY price DESC 
LIMIT 3;




--6) Retrieve the total quantity of books sold by each author:
SELECT b.author, SUM(o.quantity) AS Total_Books_Sold
FROM orders o
JOIN books b ON o.books_id = b.book_id
GROUP BY b.author;


--7) List the cities where customers who spent over $30 are located
SELECT DISTINCT c.city, o.total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.total_amount > 30;


--8) Find the customer who spent the most on orders:
SELECT c.customer_id, c.name, 
SUM(o.total_amount) AS Total_Spent
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_Spent DESC 
LIMIT 1;


--9) Calculate the stock remaining after fulfilling all orders:
SELECT b.book_id, b.title, b.stock, 
COALESCE(SUM(o.quantity), 0) AS Order_Quantity,
(b.stock - COALESCE(SUM(o.quantity), 0)) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id = o.books_id
GROUP BY b.book_id, b.title, b.stock;