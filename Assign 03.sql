-- -------------------------------------------------ASSIGNMENT 3------------------------------------------------------------------------------
use assignmentdb;
-- Q1.
select * from orderdetails;
select * from orders;
call order_status1(2003,10103);
call order_status1(2005,10111);

----------------------------------------------------------------------------------------------------------------------------------------------
-- Q2.

-- Q2. (a)
select * from customers;
select * from orders;
create table cancellation(
              id int not null auto_increment, 
              customernumber int null,
              ordernumber int null,
			  comments char(50),
              primary key (id),
              constraint cancellation_customer_fk 
              foreign key (customernumber) references customers(customernumber), 
              constraint cancillation_order_fk
              foreign key (ordernumber) references orders(ordernumber));
select * from cancellation;

-- Q2. (b) Read through the orders table . If an order is cancelled, then put an entry in the cancellations table.
SELECT Orders.Ordernumber, Customers.CustomerNumber
FROM Orders
INNER JOIN Customers ON Orders.Customernumber = Customers.Customernumber;
select orders.status, cancellation.comments from orders  inner join 
cancellation on orders.orderNumber = cancellation.ordernumber where status ='cancelled';
select status='cancelled' from orders inner join cancellation on orders.status=cancellation.status;
select * from cancellation where ordernumber in (select ordernumber from orders);
desc cancellation;
desc orders;
alter table cancellation modify column comments text;
insert into cancellation (customernumber, ordernumber, comments) select  customernumber, ordernumber, 
comments from orders where status = 'Cancelled';
---------------------------------------------------------------------------------------------------------------------------------------------
-- Q3.

-- Q3. (a)
select * from payments;
select * from customers;

DELIMITER $$
CREATE FUNCTION purchase_status(credit DECIMAL(10,2)) 
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
	DECLARE purchase_status VARCHAR(20);
    
    IF credit > 50000 THEN
		SET  purchase_status = 'PLATINUM';
        
    ELSEIF (credit >= 25000 AND credit < 50000) THEN
        SET  purchase_status = 'GOLD';
        
    ELSEIF credit < 25000 THEN
        SET  purchase_status = 'SILVER';
        
    END IF;
	
	RETURN ( purchase_status);
END$$
DELIMITER ;

-- Q3. (b)
SELECT customerNumber_,customerName, purchase_status(creditLimit) 
from customers;

SHOW FUNCTION STATUS;
DROP FUNCTION CustomerLevel;
----------------------------------------------------------------------------------------------------------------------------------------------
-- Q4.

/*
update trigger for update cascade functionality
create definer=`root`@`localhost` trigger `movies_After_update` After update on `movies` for each row begin

update rentals
set movieid = new.id
where movieid = old.id;

END
*/

									-- ----------OR---------------
                                    
CREATE TABLE moviesArchives (
    id INT ,
	title varchar(25),
    category text,
    deletedAt TIMESTAMP DEFAULT NOW()
);

DELIMITER $$
CREATE TRIGGER before__movies__delete
BEFORE DELETE
ON movies FOR EACH ROW
BEGIN
    INSERT INTO moviesArchives(id,title,category)
    VALUES(OLD.id,OLD.title,OLD.category);
END$$    

DELIMITER ;
set sql_safe_updates=0;
DELETE FROM movies WHERE id = 8;

-- on rentals

CREATE TABLE rentalsArchives (
    memid INT ,
	first_name varchar(25),
    last_name varchar(25),
    movieid int,
    deletedAt TIMESTAMP DEFAULT NOW()
);

DELIMITER $$
CREATE TRIGGER before__rentals_delete
BEFORE DELETE
ON rentals FOR EACH ROW
BEGIN
    INSERT INTO rentalsArchives (memid,first_name,last_name,movieid)
    VALUES(OLD.memid,OLD.first_name,OLD.last_name,old.movieid);
END$$    

DELIMITER ;
set sql_safe_updates=0;
DELETE FROM rentals WHERE memid = 3;

-- on update trigger
-- on movies

CREATE TABLE moviesChanges (
     id INT ,
	title varchar(25),
    category text,
    changedAt TIMESTAMP NOT NULL DEFAULT now()
);

DELIMITER $$

CREATE TRIGGER after__movies__update
AFTER UPDATE
ON movies FOR EACH ROW
BEGIN
    IF OLD.title <> new.title THEN
        INSERT INTO moviesChanges(id,title,category)
		VALUES(OLD.id,OLD.title,OLD.category);
		END IF;
END$$

DELIMITER ;

SET SQL_SAFE_UPDATES=0;
UPDATE movies
SET title = 'unsafe'

-- on rentals
Create TABLE rentalsChanges (
      memid INT ,
	first_name varchar(25),
    last_name varchar(25),
    movieid int,
    changedAt TIMESTAMP NOT NULL DEFAULT now()
    );

DELIMITER $$

CREATE TRIGGER after__rentals__update
AFTER UPDATE
ON rentals FOR EACH ROW
BEGIN
    IF OLD.first_name <> new.first_name THEN
         INSERT INTO rentalsChanges(memid,first_name,last_name,movieid)
          VALUES(OLD.memid,OLD.first_name,OLD.last_name,old.movieid);
		END IF;
END$$

DELIMITER ;

SET SQL_SAFE_UPDATES=0;
UPDATE rentals
SET first_name = 'Sam'
WHERE memid = 2;
----------------------------------------------------------------------------------------------------------------------------------------------
-- Q5.
select * from employee;
select * from employee order by salary desc limit 2,1;
----------------------------------------------------------------------------------------------------------------------------------------------
-- Q6.
select * from employee;
select rank()over (order by salary desc) as ranking, empid, fname, lname, deptno, salary from employee;
----------------------------------------------------------------------------------------------------------------------------------------------















