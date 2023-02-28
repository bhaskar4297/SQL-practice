#Q1 How to select UNIQUE records from a table using a SQL Query?
# Method- 1 Using GROUP BY Function
CREATE TABLE EMPLOYEE (
EMPLOYEE_ID int, 
NAME VARCHAR(20), 
SALARY int 
);
INSERT INTO EMPLOYEE(EMPLOYEE_ID,NAME,SALARY) VALUES(100,'Jennifer',4400);
INSERT INTO EMPLOYEE(EMPLOYEE_ID,NAME,SALARY) VALUES(100,'Jennifer',4400);
INSERT INTO EMPLOYEE(EMPLOYEE_ID,NAME,SALARY) VALUES(101,'Michael',13000);
INSERT INTO EMPLOYEE(EMPLOYEE_ID,NAME,SALARY) VALUES(101,'Michael',13000);
INSERT INTO EMPLOYEE(EMPLOYEE_ID,NAME,SALARY) VALUES(101,'Michael',13000);
INSERT INTO EMPLOYEE(EMPLOYEE_ID,NAME,SALARY) VALUES(102,'Pat',6000);
INSERT INTO EMPLOYEE(EMPLOYEE_ID,NAME,SALARY) VALUES(102,'Pat',6000);
INSERT INTO EMPLOYEE(EMPLOYEE_ID,NAME,SALARY) VALUES(103,'Den',11000);

select * from employee;

select employee_id,name,salary from employee group by employee_id,name,salary;

# Method- 2  Using ROW_NUMBER Analytic Function

select name,salary,row_number() over(partition by employee_id,name,salary order by employee_id) as row_num from employee;

with cte as
(select employee_id,name,salary,row_number() over(partition by employee_id,name,salary order by employee_id) as row_num from employee)
select employee_id,name,salary from cte 
WHERE row_num = 1;

#Q2 How to read TOP 5 records from a table using a SQL query?
CREATE TABLE Departments(
 Department_ID int,
 Department_Name varchar(50)
);
INSERT INTO DEPARTMENTS VALUES('10','Administration');
INSERT INTO DEPARTMENTS VALUES('20','Marketing');
INSERT INTO DEPARTMENTS VALUES('30','Purchasing');
INSERT INTO DEPARTMENTS VALUES('40','Human Resources');
INSERT INTO DEPARTMENTS VALUES('50','Shipping');
INSERT INTO DEPARTMENTS VALUES('60','IT');
INSERT INTO DEPARTMENTS VALUES('70','Public Relations');
INSERT INTO DEPARTMENTS VALUES('80','Sales');

SELECT * FROM Departments;

SELECT * FROM Departments LIMIT 5;
SELECT * FROM Departments LIMIT 5 OFFSET 5;

#Q3  How to find the employee with second MAX Salary using a SQL query?
CREATE TABLE Employees(
EMPLOYEE_ID int, NAME VARCHAR(20), SALARY int);

INSERT INTO EMPLOYEES(EMPLOYEE_ID,NAME,SALARY) VALUES(100,'Jennifer',4400);
INSERT INTO EMPLOYEES(EMPLOYEE_ID,NAME,SALARY) VALUES(101,'Michael',13000);
INSERT INTO EMPLOYEES(EMPLOYEE_ID,NAME,SALARY) VALUES(102,'Pat',6000);
INSERT INTO EMPLOYEES(EMPLOYEE_ID,NAME,SALARY) VALUES(103,'Den', 11000);
INSERT INTO EMPLOYEES(EMPLOYEE_ID,NAME,SALARY) VALUES(104,'Alexander',3100);
INSERT INTO EMPLOYEES(EMPLOYEE_ID,NAME,SALARY) VALUES(105,'Shelli',2900);
INSERT INTO EMPLOYEES(EMPLOYEE_ID,NAME,SALARY) VALUES(106,'Sigal',2800);
INSERT INTO EMPLOYEES(EMPLOYEE_ID,NAME,SALARY) VALUES(107,'Guy',2600);
INSERT INTO EMPLOYEES(EMPLOYEE_ID,NAME,SALARY) VALUES(108,'Karen',2500);

select * from employees;

#without analytical function

select max(salary) as salary from employees where salary =
(select max(salary) as salary from employees where salary not in
(select max(salary) as salary from employees));

with cte as(select max(salary) as salary from employees where salary not in(select max(salary) as salary from employees))
select a.* from employees a join cte b on a.salary=b.salary;

#with analytical function
select employees.*,dense_rank() over(order by salary desc) as salary_rank from employees;

with cte as
(select employees.*,dense_rank() over(order by salary desc) as salary_rank from employees)
select employee_id,name , salary from cte
where salary_rank= 3
;

