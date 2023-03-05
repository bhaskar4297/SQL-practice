#Q1 This  is about finding new and repeat customers .using SQL. In this we will learn following concepts:
#how to approach complex query step by step
#how to use CASE WHEN with SUM
#how to use common table expression (CTE)
#what output do we want: order_date,new_customer_count,repeat_customer_count

show databases;
show tables;
select * from customer_orders;
# how to find which customer is new
select customer_id,min(order_date) as first_visit_date 
from customer_orders
group by customer_id;
# virtual table first_visit
with first_visit as (
select customer_id,min(order_date) as first_visit_date 
from customer_orders
group by customer_id)
, visit_flag as 
(select co.*,fv.first_visit_date 
, CASE WHEN co.order_date = fv.first_visit_date then 1 else 0 end as first_visit_flag
, CASE WHEN co.order_date != fv.first_visit_date then 1 else 0 end as repeat_visit_flag
from customer_orders co
inner join first_visit fv on co.customer_id= fv.customer_id
order by order_id)
select order_date, sum(first_visit_flag) as no_of_new_customers,sum(repeat_visit_flag) as no_of_repeat_customer_id
from visit_flag
group by order_date;

#alternate_solution
with cte as(
select  order_date, row_number() over(partition by customer_id order by 
order_date asc) as rn from customer_orders)
select order_date, sum(case when rn=1 then 1 else 0 end) as new_customers,
sum(case when rn>1 then 1 else 0 end) as repeat_customers from cte
group by order_date;

#Q2. 
create table entries ( 
name varchar(20),
address varchar(20),
email varchar(20),
floor int,
resources varchar(10));
insert into entries 
values ('A','Bangalore','A@gmail.com',1,'CPU'),('A','Bangalore','A1@gmail.com',1,'CPU'),('A','Bangalore','A2@gmail.com',2,'DESKTOP')
,('B','Bangalore','B@gmail.com',2,'DESKTOP'),('B','Bangalore','B1@gmail.com',2,'DESKTOP'),('B','Bangalore','B2@gmail.com',1,'MONITOR');

with
total_visits as (select name,count(1) as total_visits,GROUP_CONCAT(distinct resources) as resources_used from entries group by name)
,floor_visit as
(select 
name,floor,count(1) no_of_floor_visit,
rank() over(partition by name order by count(1) desc) as rn
from entries
group by name,floor)
select fv.name,fv.floor as most_visited_floor,tv.total_visits,tv.resources_used 
from floor_visit fv 
inner join total_visits tv on fv.name=tv.name
where rn = 1

#Q3


