drop database if exists ECOMMERCE;
create database ECOMMERCE;
use ECOMMERCE;
#problem_1
#table_1
create table Supplier
(
    SUPP_ID int primary key,
    SUPP_NAME varchar(100),
    SUPP_CITY varchar(50),
    SUPP_PHONE varchar(10)
);
#table_2
create table Customer
(
    CUS_ID int primary key,
    CUS_NAME varchar(100),
    CUS_PHONE varchar(10),
    CUS_CITY varchar(50),
    CUS_GENDER varchar(1)
);

#table_3
create table Category
(
    CAT_ID int primary key,
    CAT_NAME varchar(100)
);

#table_4
create table Product
(
    PRO_ID int primary key,
    PRO_NAME varchar(100),
    PRO_DESC varchar(1000),
    CAT_ID int,
    foreign key (CAT_ID) references Category(CAT_ID)
);

#table_5
create table ProductDetails
(
    PROD_ID int primary key,
    PRO_ID int,
    SUPP_ID int,
    PRICE int,
    foreign key (PRO_ID) references Product(PRO_ID),
    foreign key (SUPP_ID) references Supplier(SUPP_ID)
);

#table_6
create table Orders
(
    ORD_ID int primary key,
    ORD_AMOUNT int,
    ORD_DATE date,
    CUS_ID int,
    PROD_ID int,
    foreign key (CUS_ID) references Customer(CUS_ID),
    foreign key (PROD_ID) references ProductDetails(PROD_ID)
);

#table_7
create table Rating
(
    RAT_ID int primary key,
    CUS_ID int,
    SUPP_ID int,
    RAT_RATSTARS int,
    foreign key(CUS_ID) references Customer(CUS_ID),
    foreign key(SUPP_ID) references Supplier(SUPP_ID)
);

#problem 2. 
insert into Supplier
values(1,'Rajesh Retails','Delhi','1234567890'),
      (2,'Appario Ltd', 'Mumbai', '2589631470'),
      (3,'Knome products','Banglore','9785462315'),
      (4, 'Bansal Retails','Kochi', '8975463285'),
      (5, 'Mittal Ltd.', 'Lucknow','7898456532');

insert into Customer
values(1,'AAKASH','9999999999','DELHI','M'),
      (2, 'AMAN','9785463215', 'NOIDA', 'M'),
      (3, 'NEHA', '9999999999', 'MUMBAI', 'F'),
      (4, 'MEGHA', '9994562399','KOLKATA','F'),
      (5, 'PULKIT','7895999999','LUCKNOW','M');

insert into Category
values(1,'BOOKS'),
      (2, 'GAMES'),
      (3, 'GROCERIES'),
      (4,'ELECTRONICS'),
      (5,'CLOTHES');

insert into Product
values(1,'GTA V','DFJDJFDJFDJFDJFJF', 2),
       (2, 'TSHIRT','DFDFJDFJDKFD',5),
       (3, 'ROG LAPTOP','DFNTTNTNTERND',4),
       (4,'OATS','REURENTBTOTH',3),
       (5,'HARRY POTTER', 'NBEMCTHTJTH', 1);
       
insert into ProductDetails
values(1, 1, 2, 1500),
      (2, 3, 5, 30000),
      (3, 5, 1, 3000),
      (4, 2, 3, 2500),
      (5, 4, 1, 1000);
      
insert into Orders
values(20, 1500,'2021-10-12', 3, 5),
      (25, 30500, '2021-09-16',5,2),
      (26, 2000, '2021-10-05', 1, 1),
      (30, 3500, '2021-08-16',4, 3),
      (50, 2000, '2021-10-06', 2, 1);
      
insert into Rating
values(1, 2, 2, 4),
      (2, 3, 4, 3),
      (3, 5, 1, 5),
      (4, 1, 3, 2),
      (5, 4, 5, 4);

#problem 3
/* Display the number of the customer group by their genders who have placed 
any order of amount greater than or equal to Rs.3000.
*/
select count(C.CUS_ID) As No_of_cus,
	   C.CUS_GENDER
from Customer C
join Orders O 
on 	 C.CUS_ID = O.CUS_ID
where O.ORD_AMOUNT >=3000
Group by C.CUS_GENDER
;

#problem 4
/* query: Display all the orders along with the product name
 ordered by a customer having Customer_Id=2. */
select O.ORD_ID,
	   P.PRO_NAME
from   Orders      O 
join   Customer    C 
on     C.CUS_ID =  O.CUS_ID
and    C.CUS_ID =  2
join   ProductDetails PD
on     O.PROD_ID = PD.PROD_ID
join   Product     P
on     PD.PRO_ID = P.PRO_ID
;

#problem 5
/* query: Display the Supplier details who can supply more than one product.*/
select SUPP_ID, SUPP_NAME, SUPP_PHONE, SUPP_CITY
from Supplier S 
where 1 < 
		( select count(*)
          from ProductDetails
          where SUPP_ID = S.SUPP_ID); 
-- select *
-- from Supplier S
-- where SUPP_ID in (select PD.SUPP_ID
-- 				  from ProductDetails PD
--                   group by PD.SUPP_ID
--                   having count (PD.SUPP_ID)>1);                  
#problem 6
/*query: Find the category of the product whose order amount
 is minimum. */
select P.PRO_NAME, C.CAT_NAME
from Category C
join Product  P
on C.CAT_ID = P.CAT_ID
join ProductDetails PD
on P.PRO_ID = PD.PRO_ID
and PD.PROD_ID in (select PROD_ID
		   from Orders
                   where ORD_AMOUNT in (select min(ORD_AMOUNT)
		   from Orders)
		  )
;

#problem 7
/*Display the Id and Name of the Product ordered after “2021-10-05”.*/
select PRO_ID, PRO_NAME
from Product
where PRO_ID in (select PRO_ID from Orders where ORD_DATE > '2021-10-05');

#problem 8
/*Display customer name and gender whose names start or end with character 'A'.*/
select CUS_NAME, CUS_GENDER
from Customer
where CUS_NAME like 'A%'
or CUS_NAME like '%A';

#problem 9
/*Create a stored procedure to display the Rating for a Supplier
if any along with the Verdict on that rating if any like if rating >4
then “Genuine Supplier”  if rating >2 “Average Supplier” else
“Supplier should not be considered”.*/

select R.RAT_RATSTARS,
	case
		when R.RAT_RATSTARS > 4 then 'Genuine Supplier'
        when R.RAT_RATSTARS >2 and R.RAT_RATSTARS <=4 then 'Average Supplier'
        else 'Suppliers should not be considered' end as rating
from Rating R
where R.SUPP_ID = SUPP_ID;
