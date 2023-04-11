>[Back to Main Homework page](../README.md)
>
>[Back to Week 5 Main page](../../../week_5_batch_processing/README.md)
>
> [Homework without solutions](homework.md)

## Week 5 Homework 

In this homework we'll put what we learned about Spark in practice.

For this homework we will be using the FHVHV 2021-06 data found here. [FHVHV Data](https://github.com/DataTalksClub/nyc-tlc-data/releases/download/fhvhv/fhvhv_tripdata_2021-06.csv.gz )

All solutions in [Jupyter Notebook](../../../week_5_batch_processing/code/Homework.ipynb)

### Question 1: 

**Install Spark and PySpark** 

- Install Spark
- Run PySpark
- Create a local spark session
- Execute spark.version.

What's the output?
* - 3.3.2
- 2.1.4
- 1.2.3
- 5.4
</br></br>

### Solution:
  ```
  $ cd data-engineering-zoomcamp/week_5_batch_processing/code
  $ jupyter notebook
  # Forward port 8888 for Jupyter Notebook
  
  # New Notebook
  
  import pyspark
  from pyspark.sql import SparkSession
  
  spark = SparkSession.builder \
      .master("local[*]") \
      .appName('test') \
      .getOrCreate()
      
  pyspark.__version__
  ```
### Result:
'3.3.2'


### Question 2: 

**HVFHW June 2021**

Read it with Spark using the same schema as we did in the lessons.</br> 
We will use this dataset for all the remaining questions.</br>
Repartition it to 12 partitions and save it to parquet.</br>
What is the average size of the Parquet (ending with .parquet extension) Files that were created (in MB)? Select the answer which most closely matches.</br>


- 2MB
* - 24MB
- 100MB
- 250MB
</br></br>

### Solution:
  ```
  $ cd data-engineering-zoomcamp/week_5_batch_processing/code
  $ wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/fhvhv/fhvhv_tripdata_2021-06.csv.gz
  $ gunzip fhvhv_tripdata_2021-06.csv.gz
  
  In Jupyter Notebook:
  import pyspark
  from pyspark.sql import SparkSession
  
  spark = SparkSession.builder \
    .master("local[*]") \
    .appName('test') \
    .getOrCreate()
    
  df = spark.read \
    .option("header", "true") \
    .option("inferSchema", "true") \
    .csv('fhvhv_tripdata_2021-06.csv')
    
  df.schema
  
  # Modify schema
  
  from pyspark.sql import types
  
  schema = types.StructType([
    types.StructField('dispatching_base_num', types.StringType(), True),
    types.StructField('pickup_datetime', types.TimestampType(), True),
    types.StructField('dropoff_datetime', types.TimestampType(), True),
    types.StructField('PULocationID', types.IntegerType(), True),
    types.StructField('DOLocationID', types.IntegerType(), True),
    types.StructField('SR_Flag', types.StringType(), True),
    types.StructField('Affiliated_base_number', types.StringType(), True)
  ])

  df = spark.read \
    .option("header", "true") \
    .schema(schema) \
    .csv('fhvhv_tripdata_2021-06.csv')
    
  df.printSchema()
  
  df \
    .repartition(12) \
    .write.parquet("data/pq/fhvhv/2021/06/")
    
  
  $ ls -l data/pq/fhvhv/2021/06/
  ```
### Result:
- 23648628 = 24MB

### Question 3: 

**Count records**  

How many taxi trips were there on June 15?</br></br>
Consider only trips that started on June 15.</br>

- 308,164
- 12,856
* - 452,470
- 50,982
</br></br>

### Solution:
  ```
  from pyspark.sql import functions as F
  
  df \
      .withColumn('pickup_date', F.to_date(df.pickup_datetime)) \
      .filter("pickup_date = '2021-06-15'") \
      .count()     
  ```
  or using SQL:
  ```
  df.registerTempTable('fhvhv_2021_06')
  
  spark.sql("""
  SELECT
      COUNT(*)
  FROM
      fhvhv_2021_06
  WHERE
      to_date(pickup_datetime) = '2021-06-15';
  """).show()
  ```
### Result:
- 452470

### Question 4: 

**Longest trip for each day**  

Now calculate the duration for each trip.</br>
How long was the longest trip in Hours?</br>

* - 66.87 Hours
- 243.44 Hours
- 7.68 Hours
- 3.32 Hours
</br></br>

### Solution:
  ```
  df \
      .withColumn('pickup_date', F.to_date(df.pickup_datetime)) \
      .withColumn('duration_h', 
                  F.round((df.dropoff_datetime.cast("long") - df.pickup_datetime.cast("long")) / 3600, 2)
          ) \
      .groupBy('pickup_date') \
      .max('duration_h') \
      .orderBy(F.col('max(duration_h)').desc()) \
      .limit(5) \
      .show()
  ```
### Result:
  ```
  +-----------+---------------+
  |pickup_date|max(duration_h)|
  +-----------+---------------+
  | 2021-06-25|          66.88|
  | 2021-06-22|          25.55|
  | 2021-06-27|          19.98|
  | 2021-06-26|           18.2|
  | 2021-06-23|          16.47|
  +-----------+---------------+
  ```

  or using SQL:
  ```
  spark.sql("""
  SELECT
      to_date(pickup_datetime),
      MAX(ROUND((CAST(dropoff_datetime AS LONG) - CAST(pickup_datetime AS LONG)) / 3600, 2)) AS max_duration_h
  FROM
      fhvhv_2021_06
  GROUP BY
      1
  ORDER BY
      2 DESC
  LIMIT
      10
  ;
  """).show()
  ```

### Question 5: 

**User Interface**

 Spark’s User Interface which shows application's dashboard runs on which local port?</br>

- 80
- 443
* - 4040
- 8080
</br></br>

### Result:
4040

### Question 6: 

**Most frequent pickup location zone**

Load the zone lookup data into a temp view in Spark</br>
[Zone Data](https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv)</br>

Using the zone lookup data and the fhvhv June 2021 data, what is the name of the most frequent pickup location zone?</br>

- East Chelsea
- Astoria
- Union Sq
* - Crown Heights North
</br></br>

### Solution:
  ```
  df_zones = spark.read.parquet('zones/')
  
  df \
      .join(df_zones, df.PULocationID == df_zones.LocationID) \
      .groupBy(df_zones.LocationID, df_zones.Zone) \
      .count() \
      .orderBy(F.col('count').desc()) \
      .limit(5) \
      .show()
  ```
  or using SQL:
  ```
  spark.sql("""
  SELECT
      zones.Zone,
      COUNT(*) AS cnt
  FROM
      fhvhv_2021_06
  INNER JOIN zones
          ON fhvhv_2021_06.PULocationID = zones.LocationID
  GROUP BY
      fhvhv_2021_06.PULocationID, zones.Zone
  ORDER BY
      cnt DESC
  LIMIT
      10
  ;
  """).show()
  ```
### Result:
  ```
  +----------+-------------------+------+
  |LocationID|               Zone| count|
  +----------+-------------------+------+
  |        61|Crown Heights North|231279|
  |        79|       East Village|221244|
  |       132|        JFK Airport|188867|
  |        37|     Bushwick South|187929|
  |        76|      East New York|186780|
  +----------+-------------------+------+
  ```


## Submitting the solutions

* Form for submitting: https://forms.gle/EcSvDs6vp64gcGuD8
* You can submit your homework multiple times. In this case, only the last submission will be used. 

Deadline: 06 March (Monday), 22:00 CET


## Solution

* Video: https://www.youtube.com/watch?v=ldoDIT32pJs
* Answers:
  * Question 1: 3.3.2
  * Question 2: 24MB
  * Question 3: 452,470
  * Question 4: 66.87 Hours
  * Question 5: 4040
  * Question 6: Crown Heights North

_[Back to the top](#week-5-homework)_