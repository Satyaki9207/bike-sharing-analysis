/*Bike sharing assignment*/
/*create schema bike_sharing;*/
use bike_sharing;

/*LOAD DATA INFILE 'C:/Satyaki/Coursera/UAZ/module_1/tableau+data_viz/bike-sharing/trip.csv'
INTO TABLE employee_details
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;*/

create table trip2(
id int NOT NULL,
duration int,
start_date datetime,
start_station_name text,
start_station_id int,
end_date datetime,
end_station_name text,
end_station_id int,
bike_id int,
subscription_type text,
primary key(id)
);

/*defining primary keys*/
alter table station add constraint primary key(station_id);
alter table status add constraint primary key(station_id,time);
alter table weather add constraint primary key(Date,Pincode);
alter table trip2 change column id trip_id int;

/*Q1a Total number of bike stations--70*/
select count(*) from station;

/*Q1b-total number of bikes--700*/
select count(distinct(bike_id)) from trip2;

/*Total number of trips 669959 */
select count(*) from trip2;

/*bike id to station_id*/
select bike_id, count(distinct(start_station_id)) from trip2
group by bike_id
order by bike_id;

/*date column and mean_wind_speed*/
select mean_wind_speed_mph from weather
where date='2013-08-29';

/*first trip*/
select * from trip2
order by start_date 
limit 1;

/*average duration of all trips*/
select avg(duration) from trip2
where start_station_id=end_station_id;

/*most used bike*/
select bike_id,sum(duration) n_dur from trip2
group by bike_id order by n_dur desc;

/*least popular stations*/
select start_station_id,count(*) n_trips from trip2
group by start_station_id
order by n_trips
limit 10;

/*idle time for station2*/
select * from status 
where station_id=2 and bikes_available>=3 
and time>='2013-08-29' and time<'2013-08-30';

/*distance between consecutive stations*/
with A1 as (select *,
acos(
cos(radians( st.lat ))
* cos(radians( st.lead_lat ))
* cos(radians( st.long ) - radians( st.lead_long ))
+ sin(radians( st.lat ))
* sin(radians( st.lead_lat ))
) AS consecutiveStationDistance from (select *, 
LEAD(station.lat) OVER(ORDER BY station_id) as lead_lat,
LEAD(station.long) OVER(ORDER BY station_id ) as lead_long
from station) AS st)

select station_id, name,consecutivestationDistance,count(trip_id)  from A1
join trip2 t2 on A1.station_id=t2.start_station_id
group by station_id order by station_id;

/*average number bikes and docks available for station 2*/
select avg(bikes_available) avg_bikes, avg(docks_available) avg_docks from status
where station_id=2;




