create schema staging;

use schema staging;

create schema ODS;

create table temperature(date timestamp, temperature_min integer, temperature_max integer, normal_min float, normal_max float, constraint pk_date  primary key (date));

insert into temperature select to_timestamp(date, 'YYYYMMDD'), temperature_min, temperature_max, normal_min, normal_max from PROJECTYELPRATINGSWEATHER.STAGING.TEMPERATURE;

drop table precipitation;
create table precipitation(date timestamp, precipitation float, precipitation_normal float, constraint pk_date  primary key (date));

insert into precipitation select to_timestamp(date, 'YYYYMMDD'), precipitation, precipitation_normal from PROJECTYELPRATINGSWEATHER.STAGING.PRECIPITATION;

create table Checkins(business_id string, date string, constraint pk_business_id  primary key (business_id));

insert into Checkins
select v:business_id, v:date
 from PROJECTYELPRATINGSWEATHER.STAGING.CHECKINS;

create table Tips( business_id string, user_id string, date timestamp, text string, compliment_count integer, constraint pk_business_id  primary key (business_id));

insert into Tips
select  v:business_id, v:user_id, v:date, v:text, v:compliment_count
 from PROJECTYELPRATINGSWEATHER.STAGING.TIPS;


create table CovidFeatures(business_id string, delivery_or_takeout string, highlights string,
call_to_action_enabled string, covid_banner string,
grubhub_enabled string, request_a_quote_enabled string,
temporary_closed_until string, virtual_services_offered string, constraint pk_business_id  primary key (business_id));

insert into CovidFeatures
select v:business_id, v:"delivery or takeout",v:highlights,
v:"Call To Action enabled", v:"Covid Banner", v:"Grubhub enabled", v:"Request a Quote Enabled", v:"Temporary Closed Until", v:"Virtual Services Offered"
 from PROJECTYELPRATINGSWEATHER.STAGING.COVIDFEATURES;

create table Businesses(business_id string, business_name string, address string, city string, state string, postal_code string, latitude float, longitude float,
stars float, review_count integer, is_open integer, constraint pk_business_id  primary key (business_id));

insert into Businesses
select v:business_id, v:name, v:address, v:city, v:state, v:postal_codeg, v:latitude, v:longitude,
v:stars, v:review_count, v:is_open
 from PROJECTYELPRATINGSWEATHER.STAGING.BUSINESSES;

create table Users(user_id string, user_name string, yelping_since timestamp, review_count integer, useful integer,
 funny integer, cool integer, fans integer, average_stars float, constraint pk_user_id  primary key (user_id));


insert into Users
select
 v:user_id, v:name, v:yelping_since, v:review_count,  v:useful, v:funny, v:cool,
 v:fans, v:average_stars
 from PROJECTYELPRATINGSWEATHER.STAGING.USERS;


create table Reviews(review_id string, user_id string, business_id string, stars integer, date timestamp, useful integer, funny integer, cool integer, text string,
 constraint pk_review_id  primary key (review_id),
constraint fk_user_id foreign key (user_id) references users(user_id),
constraint fk_business_id foreign key (business_id) references businesses(business_id),
constraint fk_date_temperature foreign key (date) references temperature(date),
constraint fk_date_precipitation foreign key (date) references precipitation(date));


insert into Reviews
select v:review_id, v:user_id, v:business_id,
	v:stars, v:date, v:useful, v:funny,
 	v:cool, v:text
 from PROJECTYELPRATINGSWEATHER.STAGING.REVIEWS;
