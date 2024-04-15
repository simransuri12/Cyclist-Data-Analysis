-- Possible questions to ask:
--1. can we know the time at which the bikes are used? NO, as the time is in UTC
--2. Which month is the most/least popular for bike rides ?
--3. What are the no of casual and membership people? done 
--4. most/least busy start stations? done 
--5. Month wise member type usage?
--6. Bike type vs Month
--7. Distribution of rides distance for casual-member done 


-- For checking duplicate rows
SELECT COUNT(ride_id) - COUNT(DISTINCT ride_id) AS duplicate_rows
from `alert-result-414002.cyclistdata.cyclist_2023`;

--- To find 3 types of rideable bikes
SELECT DISTINCT rideable_type, COUNT(rideable_type) AS no_of_trips
from `alert-result-414002.cyclistdata.cyclist_2023`
GROUP BY rideable_type;


-- Trips longer than a day 
SELECT COUNT(*) AS longer_than_a_day
FROM `alert-result-414002.cyclistdata.cyclist_2023`
WHERE (
  EXTRACT(HOUR FROM (ended_at - started_at)) * 60 +
  EXTRACT(MINUTE FROM (ended_at - started_at)) +
  EXTRACT(SECOND FROM (ended_at - started_at)) / 60) >= 1440;   -- longer than a day - total rows = 5360

  
-- Trips less than a minute
  SELECT COUNT(*) AS less_than_a_minute
FROM `alert-result-414002.cyclistdata.cyclist_2023`
WHERE (
  EXTRACT(HOUR FROM (ended_at - started_at)) * 60 +
  EXTRACT(MINUTE FROM (ended_at - started_at)) +
  EXTRACT(SECOND FROM (ended_at - started_at)) / 60) <= 1;
-- 151069

-- No. of rows where end time is equal or less than the start time 
SELECT COUNT(*) ENDED_AT_LESS
FROM `alert-result-414002.cyclistdata.cyclist_2023`
WHERE ended_at <= started_at;
-- 1269

-- Finding busiest station 
SELECT start_station_name,
COUNT(DISTINCT ride_id) AS num_of_rides
FROM `alert-result-414002.cyclistdata.cyclist_2023`
WHERE start_station_name is not NULL 
GROUP BY 1
ORDER BY 2 DESC LIMIT 10;

-- Finding null values in start station name
SELECT COUNT(ride_id) AS null_start_station
FROM `alert-result-414002.cyclistdata.cyclist_2023`
WHERE start_station_name is NULL or start_station_id is NULL;

--Find null values in end station name
SELECT DISTINCT end_station_name
FROM `alert-result-414002.cyclistdata.cyclist_2023`
ORDER BY end_station_name;

SELECT COUNT(ride_id) AS null_end_station
FROM `alert-result-414002.cyclistdata.cyclist_2023`
WHERE end_station_name is NULL or end_station_id is NULL;

-- end_lat, end_lng  missing values
SELECT COUNT(ride_id) AS null_end_lnglat
FROM`alert-result-414002.cyclistdata.cyclist_2023`
WHERE end_lat is NULL OR end_lng is NULL;

-- member vs casual no. of trips
SELECT DISTINCT member_casual, COUNT(member_casual) AS no_of_trips
FROM `alert-result-414002.cyclistdata.cyclist_2023`
GROUP BY member_casual;


-- Casual vs Member average distance, percentiles plot
SELECT 
member_casual,
avg(ST_DISTANCE(ST_GEOGPOINT(start_lng,start_lat), ST_GEOGPOINT(end_lng,end_lat), True)/ 1000) as avg_distance_km,
approx_quantiles((ST_DISTANCE(ST_GEOGPOINT(start_lng,start_lat), ST_GEOGPOINT(end_lng,end_lat), True)/ 1000), 100)[OFFSET(20)] as _20_pc_distance_km,
approx_quantiles((ST_DISTANCE(ST_GEOGPOINT(start_lng,start_lat), ST_GEOGPOINT(end_lng,end_lat), True)/ 1000), 100)[OFFSET(40)] as _40_pc_distance_km,
approx_quantiles((ST_DISTANCE(ST_GEOGPOINT(start_lng,start_lat), ST_GEOGPOINT(end_lng,end_lat), True)/ 1000), 100)[OFFSET(60)] as _60_pc_distance_km,
approx_quantiles((ST_DISTANCE(ST_GEOGPOINT(start_lng,start_lat), ST_GEOGPOINT(end_lng,end_lat), True)/ 1000), 100)[OFFSET(80)] as _80_pc_distance_km,
approx_quantiles((ST_DISTANCE(ST_GEOGPOINT(start_lng,start_lat), ST_GEOGPOINT(end_lng,end_lat), True)/ 1000), 100)[OFFSET(90)] as _90_pc_distance_km,
approx_quantiles((ST_DISTANCE(ST_GEOGPOINT(start_lng,start_lat), ST_GEOGPOINT(end_lng,end_lat), True)/ 1000), 100)[OFFSET(99)] as _99_pc_distance_km

FROM `alert-result-414002.cyclistdata.cyclist_2023`
where end_lat is not null and end_lng is not null 
group  by 1;



