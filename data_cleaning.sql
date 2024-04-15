-- For Cleaning, remove following:
-- Null values 
-- Duplicates of rides
-- Trips greater than a minute and less than a day length

-- Find count for Trip length < 1 min 
SELECT COUNT(*) AS less_than_a_minute
FROM `alert-result-414002.cyclistdata.cyclist_2023`
WHERE (
  EXTRACT(HOUR FROM (ended_at - started_at)) * 60 +
  EXTRACT(MINUTE FROM (ended_at - started_at)) +
  EXTRACT(SECOND FROM (ended_at - started_at)) / 60) <= 1;

-- no. of rows in cleaned table
SELECT COUNT(*)
FROM `alert-result-414002.cyclistdata.cyclist_2023_cleaned`;
-- 4244056

-- no. of rows in original table
SELECT COUNT(*)
FROM `alert-result-414002.cyclistdata.cyclist_2023`;
-- 5719877

-- Create and save cleansed data in a different table
CREATE OR REPLACE table `alert-result-414002.cyclistdata.cyclist_2023_cleaned` AS (
SELECT *,
 (EXTRACT(HOUR FROM (ended_at - started_at)) * 60 +
  EXTRACT(MINUTE FROM (ended_at - started_at)) +
  EXTRACT(SECOND FROM (ended_at - started_at)) / 60) AS ride_length

FROM `alert-result-414002.cyclistdata.cyclist_2023`
WHERE start_station_name is NOT NULL AND 
start_station_id is NOT NULL AND 
end_station_name is NOT NULL AND
end_station_id is NOT NULL AND
end_lat is NOT NULL AND
end_lng is NOT NULL AND 
(
 (EXTRACT(HOUR FROM (ended_at - started_at)) * 60 +
  EXTRACT(MINUTE FROM (ended_at - started_at)) +
  EXTRACT(SECOND FROM (ended_at - started_at)) / 60) < 1440 AND 
  (EXTRACT(HOUR FROM (ended_at - started_at)) * 60 +
  EXTRACT(MINUTE FROM (ended_at - started_at)) +
  EXTRACT(SECOND FROM (ended_at - started_at)) / 60) > 1 
)
);


-- no. of rows in cleaned table
SELECT COUNT(*)
FROM `alert-result-414002.cyclistdata.cyclist_2023_cleaned`;
-- 4244056

-- no. of rows in original table
SELECT COUNT(*)
FROM `alert-result-414002.cyclistdata.cyclist_2023`;
-- 5719877






