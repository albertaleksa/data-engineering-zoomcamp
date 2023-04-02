-- Question 1
SELECT count(*) FROM `substantial-mix-378619.production.fact_trips`
WHERE DATE(pickup_datetime) BETWEEN '2019-01-01' AND '2020-12-31';

SELECT count(*) FROM `substantial-mix-378619.production.fact_trips`
WHERE extract(year from pickup_datetime) IN (2019, 2020);

-- 61602988

-- Question 2
-- 89.8/10.2


-- Question 3
SELECT COUNT(*) FROM `substantial-mix-378619.development.stg_fhv_tripdata`
WHERE DATE(pickup_datetime) BETWEEN '2019-01-01' AND '2019-12-31';

-- Or after deply in production
SELECT COUNT(*) FROM `substantial-mix-378619.production.stg_fhv_tripdata`
WHERE DATE(pickup_datetime) BETWEEN '2019-01-01' AND '2019-12-31';


SELECT COUNT(*) FROM `substantial-mix-378619.production.stg_fhv_tripdata`
WHERE extract(year from pickup_datetime) IN (2019);

-- 43244696


-- Question 4
SELECT COUNT(*) FROM `substantial-mix-378619.development.fact_fhv_trips`
WHERE DATE(pickup_datetime) BETWEEN '2019-01-01' AND '2019-12-31';

-- Or after deply in production
SELECT COUNT(*) FROM `substantial-mix-378619.production.fact_fhv_trips`
WHERE extract(year from pickup_datetime) IN (2019);

-- 22998722
