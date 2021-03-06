-- Part I – Working with an existing database
SET SCHEMA 'chinook';
-- 1.0	Setting up Oracle Chinook
-- In this section you will begin the process of working with the Oracle Chinook database
-- Task – Open the Chinook_Oracle.sql file and execute the scripts within.


-- 2.0 SQL Queries
-- In this section you will be performing various queries against the Oracle Chinook database.


-- 2.1 SELECT
-- Task – Select all records from the Employee table.
SELECT * FROM employee;

-- Task – Select all records from the Employee table where last name is King.
SELECT * FROM employee
	WHERE lastname = 'King';

-- Task – Select all records from the Employee table where first name is Andrew and REPORTSTO is NULL.
SELECT * FROM employee
	WHERE firstname = 'Andrew' and 
	reportsto is null;

-- 2.2 ORDER BY
-- Task – Select all albums in Album table and sort result set in descending order by title.
SELECT COUNT(title), title FROM album 
	GROUP BY title
	ORDER BY COUNT(title) DESC;

-- Task – Select first name from Customer and sort result set in ascending order by city
SELECT (firstname), city FROM customer 
	ORDER BY city;

-- 2.3 INSERT INTO
-- Task – Insert two new records into Genre table
INSERT INTO genre (genreid, name) VALUES (26, 'Power Metal');
INSERT INTO genre (genreid, name) VALUES (27, 'Progressive Folk Metal');

-- Task – Insert two new records into Employee table
INSERT INTO employee VALUES (9,'Smith', 'John');
INSERT INTO employee VALUES (10,'Smith', 'Jacob');

-- Task – Insert two new records into Customer table
INSERT INTO customer (customerid, firstname, lastname, email) VALUES (60, 'Jared', 'Smith', 'jared@email.com');
INSERT INTO customer (customerid, firstname, lastname, email) VALUES (61, 'Jirard', 'Smith', 'jirard@de.chocolate');

-- 2.4 UPDATE
-- Task – Update Aaron Mitchell in Customer table to Robert Walter
UPDATE customer
SET firstname = 'Robert',lastname = 'Walter'
WHERE customerid = 32;

-- Task – Update name of artist in the Artist table “Creedence Clearwater Revival” to “CCR”
UPDATE artist
SET name = 'CCR'
WHERE name = 'Creedence Clearwater Revival';

-- 2.5 LIKE
-- Task – Select all invoices with a billing address like “T%”
SELECT * FROM invoice
WHERE billingaddress LIKE 'T%';

-- 2.6 BETWEEN
-- Task – Select all invoices that have a total between 15 and 50
SELECT * FROM invoice
WHERE total BETWEEN 15 AND 50;

-- Task – Select all employees hired between 1st of June 2003 and 1st of March 2004
SELECT * FROM employee
WHERE hiredate BETWEEN '2003-06-01' AND '2004-03-01';

-- 2.7 DELETE
-- Task – Delete a record in Customer table where the name is Robert Walter (There may be constraints that rely on this, find out how to resolve them).
DELETE FROM invoiceline 
WHERE invoiceid IN
	(SELECT invoiceid FROM invoice
     WHERE customerid IN
		(SELECT customerid FROM customer
		 	WHERE firstname = 'Robert' and lastname = 'Walter'));
		 
DELETE FROM invoice 
WHERE customerid IN
	(SELECT customerid FROM customer
		 	WHERE firstname = 'Robert' and lastname = 'Walter');
		 
DELETE FROM customer 
	  WHERE firstname = 'Robert' and lastname = 'Walter';


-- 3.0	SQL Functions
-- In this section you will be using the Oracle system functions, as well as your own functions, to perform various actions against the database


-- 3.1 System Defined Functions
-- Task – Create a function that returns the current time.
CREATE OR REPLACE FUNCTION currentTime () RETURNS TIME AS $$
DECLARE
	thisTime TIME;
   BEGIN
   	SELECT CURRENT_TIME INTO thisTime;
	RETURN thisTime;
   END;
$$ LANGUAGE plpgsql;

-- Task – create a function that returns the length of a mediatype from the mediatype table
CREATE OR REPLACE FUNCTION mediaLength () RETURNS VARCHAR(120) AS $$
DECLARE
	mediaL VARCHAR(120);
   BEGIN
   	SELECT LENGTH(name) AS LengthOfEntry From mediatype INTO mediaL;
	RETURN mediaL;
   END;
$$ LANGUAGE plpgsql;

-- 3.2 System Defined Aggregate Functions
-- Task – Create a function that returns the average total of all invoices
CREATE OR REPLACE FUNCTION averageTotal () RETURNS NUMERIC(10, 2) AS $$
DECLARE
	average NUMERIC(10, 2);
   BEGIN
   	SELECT AVG(total) FROM invoice INTO average;
	RETURN average;
   END;
$$ LANGUAGE plpgsql;

-- Task – Create a function that returns the most expensive track
CREATE OR REPLACE FUNCTION highestPrice () RETURNS NUMERIC(10, 2) AS $$
DECLARE
	price NUMERIC(10, 2);
   BEGIN
   	SELECT MAX(unitprice) FROM track INTO price;
	RETURN price;
   END;
$$ LANGUAGE plpgsql;

-- 3.3 User Defined Scalar Functions
-- Task – Create a function that returns the average price of invoiceline items in the invoiceline table
CREATE OR REPLACE FUNCTION averagePrice () RETURNS NUMERIC(10, 2) AS $$
DECLARE
	average NUMERIC(10, 2);
   BEGIN
   	SELECT AVG(unitprice) FROM invoiceline INTO average;
	RETURN price;
   END;
$$ LANGUAGE plpgsql;

-- 3.4 User Defined Table Valued Functions
-- Task – Create a function that returns all employees who are born after 1968.
CREATE OR REPLACE FUNCTION after1968 () RETURNS NUMERIC(10, 2) AS $$
DECLARE
	list NUMERIC(10, 2);
   BEGIN
   	SELECT * from employee WHERE birthdate >= '1969-01-01  00:00:00';
	RETURN list;
   END;
$$ LANGUAGE plpgsql;

-- 4.0 Stored Procedures
--  In this section you will be creating and executing stored procedures. You will be creating various types of stored procedures that take input and output parameters.


-- 4.1 Basic Stored Procedure
-- Task – Create a stored procedure that selects the first and last names of all the employees.
CREATE OR REPLACE FUNCTION firstAndLast () RETURNS NUMERIC(10, 2) AS $$
DECLARE
	list NUMERIC(10, 2);
   BEGIN
   	SELECT firstname, lastname FROM employee;
	RETURN list;
   END;
$$ LANGUAGE plpgsql;

-- 4.2 Stored Procedure Input Parameters
-- Task – Create a stored procedure that updates the personal information of an employee.
CREATE OR REPLACE FUNCTION updateEmployee () RETURNS NUMERIC(10, 2) AS $$
DECLARE
	list NUMERIC(10, 2);
   BEGIN
   	UPDATE employee
	SET firstname = 'Seems', lastname = 'Reasonable'
	WHERE employeeid = 1; 
	RETURN list;
   END;
$$ LANGUAGE plpgsql;

-- Task – Create a stored procedure that returns the managers of an employee.
CREATE OR REPLACE FUNCTION returnManagers () RETURNS NUMERIC(10, 2) AS $$
DECLARE
	list NUMERIC(10, 2);
   BEGIN
   	UPDATE employee
	SELECT reportsto FROM employee
	WHERE employeeid = '2';
	RETURN list;
   END;
$$ LANGUAGE plpgsql;

-- 4.3 Stored Procedure Output Parameters
-- Task – Create a stored procedure that returns the name and company of a customer.
CREATE OR REPLACE FUNCTION returnNameAndCompany () RETURNS NUMERIC(10, 2) AS $$
DECLARE
	list NUMERIC(10, 2);
   BEGIN
   	SELECT firstname, lastname, company FROM customer
WHERE customerid = '5';
	RETURN list;
   END;
$$ LANGUAGE plpgsql;

-- 5.0 Transactions
-- In this section you will be working with transactions. Transactions are usually nested within a stored procedure. You will also be working with handling errors in your SQL.

-- Task – Create a transaction that given a invoiceId will delete that invoice (There may be constraints that rely on this, find out how to resolve them).
CREATE OR REPLACE FUNCTION deleteInvoice () RETURNS NUMERIC(10, 2) AS $$
DECLARE
	list NUMERIC(10, 2);
   BEGIN
   
		DELETE FROM invoiceline 
	WHERE invoiceid IN
		(SELECT invoiceid FROM invoice
		 WHERE customerid IN
			(SELECT customerid FROM customer
				WHERE firstname = 'Daan' and lastname = 'Peeters'));

	DELETE FROM invoice 
	WHERE customerid IN
		(SELECT customerid FROM customer
				WHERE firstname = 'Daan' and lastname = 'Peeters');

	DELETE FROM customer 
		  WHERE firstname = 'Daan' and lastname = 'Peeters';
			 
	RETURN list;
   END;
$$ LANGUAGE plpgsql;

-- Task – Create a transaction nested within a stored procedure that inserts a new record in the Customer table
CREATE OR REPLACE FUNCTION insertCustomer () RETURNS NUMERIC(10, 2) AS $$
DECLARE
	list NUMERIC(10, 2);
   BEGIN
   
	INSERT INTO customer(customerid, firstname, lastname, email) VALUES (60, 'Anonymous', 'Joe', 'email@email.bacon');
	RETURN list;
   END;
$$ LANGUAGE plpgsql;

-- 6.0 Triggers
-- In this section you will create various kinds of triggers that work when certain DML statements are executed on a table.


-- 6.1 AFTER/FOR
-- Task - Create an after insert trigger on the employee table fired after a new record is inserted into the table.
CREATE OR REPLACE FUNCTION updatelogfunc() RETURNS TRIGGER AS $employee$
   BEGIN
      INSERT INTO employee (firstname, lastname) VALUES ('John', 'Davy');
      RETURN NEW;
   END;
$employee$ LANGUAGE plpgsql;

CREATE TRIGGER my_trigger AFTER INSERT ON employee
FOR EACH ROW EXECUTE PROCEDURE updatelogfunc();

-- Task – Create an after update trigger on the album table that fires after a row is inserted in the table
CREATE OR REPLACE FUNCTION updatelogfunc() RETURNS TRIGGER AS $album$
   BEGIN
      UPDATE album 
	  SET albumid = '2'
	  WHERE albumid = '1';
   END;
$album$ LANGUAGE plpgsql;

CREATE TRIGGER my_trigger AFTER UPDATE album
FOR EACH ROW EXECUTE PROCEDURE updatelogfunc();

-- Task – Create an after delete trigger on the customer table that fires after a row is deleted from the table.
CREATE OR REPLACE FUNCTION updatelogfunc() RETURNS TRIGGER AS $customer$
   BEGIN
      DELETE FROM customer 
	  WHERE customerid = '10';
   END;
$customer$ LANGUAGE plpgsql;

CREATE TRIGGER my_trigger AFTER INSERT ON customer
FOR EACH ROW EXECUTE PROCEDURE updatelogfunc();


-- 6.2 INSTEAD OF
-- Task – Create an instead of trigger that restricts the deletion of any invoice that is priced over 50 dollars.
CREATE OR REPLACE FUNCTION updatelogfunc() RETURNS TRIGGER AS $invoice$
   BEGIN
      DELETE FROM invoice 
	  WHERE total <= '50';
   END;
$invoice$ LANGUAGE plpgsql;

CREATE TRIGGER my_trigger BEFORE DELETE
ON invoice
FOR EACH ROW EXECUTE PROCEDURE updatelogfunc();

-- 7.0 JOINS
-- In this section you will be working with combining various tables through the use of joins. You will work with outer, inner, right, left, cross, and self joins.


-- 7.1 INNER
-- Task – Create an inner join that joins customers and orders and specifies the name of the customer and the invoiceId.
SELECT customer.firstname,customer.lastname, invoice.invoiceid
FROM customer
INNER JOIN invoice ON customer.customerid = invoice.customerid;

-- 7.2 OUTER
-- Task – Create an outer join that joins the customer and invoice table, specifying the CustomerId, firstname, lastname, invoiceId, and total.
SELECT customer.customerid id, customer.firstname, customer.lastname, invoice.invoiceid, invoice.total
FROM customer
FULL OUTER JOIN invoice ON customer.customerid = invoice.customerid;

-- 7.3 RIGHT
-- Task – Create a right join that joins album and artist specifying artist name and title.
SELECT artist.name, album.title
FROM artist
RIGHT JOIN album ON artist.artistid = album.artistid;

-- 7.4 CROSS
-- Task – Create a cross join that joins album and artist and sorts by artist name in ascending order.
SELECT * FROM artist CROSS JOIN album ORDER BY artist.name ASC;

-- 7.5 SELF
-- Task – Perform a self-join on the employee table, joining on the reportsto column.
SELECT * FROM employee 
AS A INNER JOIN employee 
AS B ON A.reportsto = B.employeeid;
