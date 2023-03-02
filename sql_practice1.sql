# Q4 write a query to find personid,name,number of friends , sum of marks of person who have friends with total score greater than 100
# first step
SELECT f.personid,f.friendid,p.score as friend_score FROM databases.friend f
inner join databases.person p on f.friendid=p.personid

#second step
SELECT f.personid,sum(p.score) as total_friend_score FROM databases.friend f
inner join databases.person p on f.friendid=p.personid
group by f.personid

#third step - sum
SELECT f.personid,sum(p.score) as total_friend_score,count(1) as no_of_friends FROM databases.friend f
inner join databases.person p on f.friendid=p.personid
group by f.personid
having sum(p.score) > 100 ;
 
#fourth step - we want person name as well
with score_detail as (
SELECT f.personid,sum(p.score) as total_friend_score,count(1) as no_of_friends FROM databases.friend f
inner join databases.person p on f.friendid=p.personid
group by f.personid
having sum(p.score) > 100 
)
select s.*,p.name as person_name from databases.person p 
inner join score_detail s on p.personid=s.personid


#Q5 write a sql query to find the cancellation rate of requests with unbanned users (both client and driver must not be banned)
 each day between "2013-10-01" and "2013-10-03". round cancellation rate to two decimal points.
 
 #the cancellation rate is computed by dividing the no of cancelled (by client or driver) requestt with unbanned users by the total no
 of request with banned users on that day
 
 Create table  Trips (id int, client_id int, driver_id int, city_id int, status varchar(50), request_at varchar(50));
 Create table Users (users_id int, banned varchar(50), role varchar(50));
 Truncate table Trips;
 insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('1', '1', '10', '1', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('2', '2', '11', '1', 'cancelled_by_driver', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('3', '3', '12', '6', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('4', '4', '13', '6', 'cancelled_by_client', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('5', '1', '10', '1', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('6', '2', '11', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('7', '3', '12', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('8', '2', '12', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('9', '3', '10', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('10', '4', '13', '12', 'cancelled_by_driver', '2013-10-03');
select * from trips;

Truncate table Users;
insert into Users (users_id, banned, role) values ('1', 'No', 'client');
insert into Users (users_id, banned, role) values ('2', 'Yes', 'client');
insert into Users (users_id, banned, role) values ('3', 'No', 'client');
insert into Users (users_id, banned, role) values ('4', 'No', 'client');
insert into Users (users_id, banned, role) values ('10', 'No', 'driver');
insert into Users (users_id, banned, role) values ('11', 'No', 'driver');
insert into Users (users_id, banned, role) values ('12', 'No', 'driver');
insert into Users (users_id, banned, role) values ('13', 'No', 'driver');

select * from users;

#first step - for clients banned
select * from trips t
inner join users c on t.client_id=c.users_id

#second step - similarly for driver
select * from trips t
inner join users c on t.client_id=c.users_id
inner join users d on t.driver_id=d.users_id

#third step - now filtering
select * from trips t
inner join users c on t.client_id=c.users_id
inner join users d on t.driver_id=d.users_id
where c.banned = 'No' and d.banned = 'No'

#fourth step - cancellation rate
select request_at, count(case when status in ('cancelled_by_client','cancelled_by_driver') then 1 else null end) as cancelled_trip_count, count(1) as total_trips
from trips t
inner join users c on t.client_id=c.users_id
inner join users d on t.driver_id=d.users_id
where c.banned = 'No' and d.banned = 'No'
group by request_at

#fifth step - percentage
select request_at, count(case when status in ('cancelled_by_client','cancelled_by_driver') then 1 else null end) as cancelled_trip_count, count(1) as total_trips,
1.0*count(case when status in ('cancelled_by_client','cancelled_by_driver') then 1 else null end)/count(1)*100 as cancelled_percentage
from trips t
inner join users c on t.client_id=c.users_id
inner join users d on t.driver_id=d.users_id
where c.banned = 'No' and d.banned = 'No'
group by request_at;




























