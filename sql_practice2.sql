#Q5 write an sql query to find the winner in each group.

#the winner in each group is the player who scored the maximum total points within the group.in case of tie the lowest player_id wins.

create table players
(player_id int,
group_id int)

insert into players values (15,1);
insert into players values (25,1);
insert into players values (30,1);
insert into players values (45,1);
insert into players values (10,2);
insert into players values (35,2);
insert into players values (50,2);
insert into players values (20,3);
insert into players values (40,3);

create table matches
(
match_id int,
first_player int,
second_player int,
first_score int,
second_score int)

insert into matches values (1,15,45,3,0);
insert into matches values (2,30,25,1,2);
insert into matches values (3,30,15,2,0);
insert into matches values (4,40,20,5,2);
insert into matches values (5,35,50,1,1);

select * from players;
select * from matches;

#first step -
select first_player as player_id,first_score as score from matches
union all
select second_player as player_id,second_score as score from matches

#second step - aggregate on player id
with player_score as (
select first_player as player_id,first_score as score from matches
union all
select second_player as player_id,second_score as score from matches)
select player_id,sum(score) as score from player_score
group by player_id;

#third step - max score in each group
with player_score as (
select first_player as player_id,first_score as score from matches
union all
select second_player as player_id,second_score as score from matches)
select p.group_id,ps.player_id,sum(score) as score from player_score ps
inner join players p on p.player_id=ps.player_id
group by p.group_id,ps.player_id;

#fourth_step - rank of each grp
with player_score as (
select first_player as player_id,first_score as score from matches
union all
select second_player as player_id,second_score as score from matches)
, final_score as (
select p.group_id,ps.player_id,sum(score) as score from player_score ps
inner join players p on p.player_id=ps.player_id
group by p.group_id,ps.player_id)
select * ,rank() over (partition by group_id order by score desc, player_id asc) as rn
from final_score;

#fifth_step - final rank of each grp
with player_score as (
select first_player as player_id,first_score as score from matches
union all
select second_player as player_id,second_score as score from matches)
, final_score as (
select p.group_id,ps.player_id,sum(score) as score from player_score ps
inner join players p on p.player_id=ps.player_id
group by p.group_id,ps.player_id)
, final_ranking as (
select * ,rank() over (partition by group_id order by score desc, player_id asc) as rn
from final_score)
select * from final_ranking where rn =1;

#Q6 MARKET ANALYSIS : write an SQL query to find for each seller,whether the brand of second item(by date) they sold
#                     is their favourite brand or not.
# if a seller sold less than two items, report the answer for that seller as no. o/p

create table user (user_id int,join_date date,favorite_brand varchar(50));
create table orders (order_id int,order_date date,item_id int,buyer_id int,seller_id int);
create table items(item_id int,item_brand varchar(50));

insert into user values (1,'2019-01-01','Lenovo'),(2,'2019-02-09','Samsung'),(3,'2019-01-19','LG'),(4,'2019-05-21','HP');
insert into items values (1,'Samsung'),(2,'Lenovo'),(3,'LG'),(4,'HP');
insert into orders values (1,'2019-08-01',4,1,2),(2,'2019-08-02',2,1,3),(3,'2019-08-03',3,2,3),(4,'2019-08-04',1,4,2),
(5,'2019-08-04',1,3,4),(6,'2019-08-05',2,2,4);

#first_step
select *,
rank() over(partition by seller_id order by order_date asc) as rn
from orders;

#second_step
with rank_orders as
(select *,
rank() over(partition by seller_id order by order_date asc) as rn
from orders)
select * from rank_orders
where rn = 2;

#third_step
with rank_orders as
(select *,
rank() over(partition by seller_id order by order_date asc) as rn
from orders)
select * from rank_orders ro
inner join items i on i.item_id = ro.item_id
where rn = 2;

#fourth_step
with rank_orders as
(select *,
rank() over(partition by seller_id order by order_date asc) as rn
from orders)
select ro.*,item_brand from rank_orders ro
inner join items i on i.item_id = ro.item_id
where rn = 2;

#fifth_step
with rank_orders as
(select *,
rank() over(partition by seller_id order by order_date asc) as rn
from orders)
select ro.*,i.item_brand,u.favorite_brand from rank_orders ro
inner join items i on i.item_id = ro.item_id
inner join user u on ro.seller_id=u.user_id
where rn = 2;

#fifth_step
with rank_orders as
(select *,
rank() over(partition by seller_id order by order_date asc) as rn
from orders)
select ro.*,i.item_brand,u.favorite_brand,
case when i.item_brand=u.favorite_brand then 'yes' else 'no' end as 2nd_item_fav_brand
 from rank_orders ro
inner join items i on i.item_id = ro.item_id
inner join user u on ro.seller_id=u.user_id
where rn = 2;

#sixth_step
with rank_orders as
(select *,
rank() over(partition by seller_id order by order_date asc) as rn
from orders)
select u.user_id as seller_id,
case when i.item_brand=u.favorite_brand then 'yes' else 'no' end as 2nd_item_fav_brand
from user U
left join rank_orders ro on ro.seller_id=u.user_id and rn = 2
left join items i on i.item_id = ro.item_id;





















