>[Back to Main Homework page](../README.md)
>
>[Back to Week 1 Main page](../../../week_1_basics_n_setup/README.md)
>
> [Homework without solutions](homework.md)

## Week 1 Homework (Docker & SQL)

In this homework we'll prepare the environment 
and practice with Docker and SQL


## Question 1. Knowing docker tags

Run the command to get information on Docker 

```docker --help```

Now run the command to get help on the "docker build" command

Which tag has the following text? - *Write the image ID to the file* 

- `--imageid string`
  - `--iidfile string`
- `--idimage string`
- `--idfile string`

### Solution:
```
$ docker build --help
--iidfile string          Write the image ID to the file
```

## Question 2. Understanding docker first run 

Run docker with the python:3.9 image in an interactive mode and the entrypoint of bash.
Now check the python modules that are installed ( use pip list). 
How many python packages/modules are installed?

- 1
- 6
  - 3
- 7

### Solution:
```
$ docker run -it --entrypoint=bash python:3.9
pip list

Package    Version
---------- -------
pip        22.0.4
setuptools 58.1.0
wheel      0.38.4
```

# Prepare Postgres

Run Postgres and load data as shown in the videos
We'll use the green taxi trips from January 2019:

```wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-01.csv.gz```

You will also need the dataset with zones:

```wget https://s3.amazonaws.com/nyc-tlc/misc/taxi+_zone_lookup.csv```

Download this data and put it into Postgres (with jupyter notebooks or with a pipeline)

### Preparing data:
```
# Run docker-compose with Postgres and PgAdmin
$ docker-compose up -d

# Build docker image using Docker file:
$ docker build -t taxi_ingest:v001 .

# Use ingest_data_hw.py for ingesting data (olmoust the same file like ingest_data.py)

# Run docker container taxi_ingest:v001 with default network (when postgres and pgadmin run by docker-compose):

URL1="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-01.csv.gz"

# To ingest data about green_tripdata
docker run -it \
  --network=docker_sql_default \
  taxi_ingest:v001 \
  --user=root \
  --password=root \
  --host=pgdatabase \
  --port=5432 \
  --db=ny_taxi \
  --table_name=green_tripdata \
  --url=${URL1}

# Build docker image for zones using Docker file:
$ docker build -t zones_ingest:v001 .

URL2="https://s3.amazonaws.com/nyc-tlc/misc/taxi+_zone_lookup.csv"

# To ingest data about taxi_zone
docker run -it \
  --network=docker_sql_default \
  zones_ingest:v001 \
  --user=root \
  --password=root \
  --host=pgdatabase \
  --port=5432 \
  --db=ny_taxi \
  --table_name=taxi_zone \
  --url=${URL2}
```

## Question 3. Count records 

How many taxi trips were totally made on January 15?

Tip: started and finished on 2019-01-15. 

Remember that `lpep_pickup_datetime` and `lpep_dropoff_datetime` columns are in the format timestamp (date and hour+min+sec) and not in date.

- 20689
  - 20530
- 17630
- 21090

### Solution:
```
SELECT	COUNT(*)
FROM	green_tripdata
WHERE	date(lpep_pickup_datetime) = '2019-01-15' AND
		 date(lpep_dropoff_datetime) = '2019-01-15'
;

20530
```

## Question 4. Largest trip for each day

Which was the day with the largest trip distance
Use the pick up time for your calculations.

- 2019-01-18
- 2019-01-28
  - 2019-01-15
- 2019-01-10

### Solution:
```
SELECT	date(lpep_pickup_datetime)
FROM	green_tripdata
WHERE	trip_distance = (SELECT	MAX(trip_distance)
						 FROM	 green_tripdata
						);

2019-01-15
```

## Question 5. The number of passengers

In 2019-01-01 how many trips had 2 and 3 passengers?
 
- 2: 1282 ; 3: 266
- 2: 1532 ; 3: 126
  - 2: 1282 ; 3: 254
- 2: 1282 ; 3: 274

### Solution:
```
SELECT	passenger_count,
		 COUNT(*)
FROM	green_tripdata
WHERE	date(lpep_pickup_datetime) = '2019-01-01' AND
		 passenger_count IN (2, 3)
GROUP BY passenger_count;

"passenger_count"	"count"
2	1282
3	254
```

## Question 6. Largest tip

For the passengers picked up in the Astoria Zone which was the drop off zone that had the largest tip?
We want the name of the zone, not the id.

Note: it's not a typo, it's `tip` , not `trip`

- Central Park
- Jamaica
- South Ozone Park
  - Long Island City/Queens Plaza

### Solution:
```
SELECT	zones_do."Zone"
FROM	green_tripdata trips
INNER JOIN taxi_zone zones_po
		 ON trips."PULocationID" = zones_po."LocationID"
INNER JOIN taxi_zone zones_do
		 ON trips."DOLocationID" = zones_do."LocationID"
WHERE	zones_po."Zone" = 'Astoria' AND
		 tip_amount = ( SELECT	MAX(tip_amount)
						FROM	green_tripdata trips
						INNER JOIN taxi_zone zones
								 ON trips."PULocationID" = zones."LocationID"
						WHERE	zones."Zone" = 'Astoria'
					  )
;
Long Island City/Queens Plaza

```

## Submitting the solutions

* Form for submitting: [form](https://forms.gle/EjphSkR1b3nsdojv7)
* You can submit your homework multiple times. In this case, only the last submission will be used. 

Deadline: 30 January (Monday), 22:00 CET


## Solution

See here: https://www.youtube.com/watch?v=KIh_9tZiroA

_[Back to the top](#week-1-homework--docker--sql-)_