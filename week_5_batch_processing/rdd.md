>[Back to Week Menu](README.md)
>
>Previous Theme: [Spark Internals](spark_internals.md)
>
>Next Theme: 

# Resilient Distributed Datasets (RDDs)
_Video sources: [1](https://youtu.be/Bdu-xIrF3OM&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)_, [2](https://youtu.be/k3uB2K99roI&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)


## RDDs: Map and Reduce

_[Video source](https://youtu.be/Bdu-xIrF3OM&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)_

### What are RDDs? How do they relate to dataframes?

***Resilient Distributed Datasets*** (RDDs) are the main abstraction provided by Spark and consist of collection of elements partitioned across the nodes of the cluster.

Dataframes are actually built on top of RDDs and contain a schema as well, which plain RDDs do not.

### From Dataframe to RDD

Spark dataframes contain a `rdd` field which contains the raw RDD of the dataframe. The RDD's objects used for the dataframe are called ***rows***.

Let's take a look once again at the SQL query we saw in the [GROUP BY section](spark_internals.md#group-by-in-spark):

```sql
SELECT 
    date_trunc('hour', lpep_pickup_datetime) AS hour, 
    PULocationID AS zone,

    SUM(total_amount) AS amount,
    COUNT(1) AS number_records
FROM
    green
WHERE
    lpep_pickup_datetime >= '2020-01-01 00:00:00'
GROUP BY
    1, 2
```

#### Before:
```python
import pyspark
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .master("local[*]") \
    .appName('test') \
    .getOrCreate()

df_green = spark.read.parquet('data/pq/green/*/*')
```

#### We can re-implement this query with RDD's instead:

1. We can re-implement the `SELECT` section by choosing the 3 fields from the RDD's rows.

    ```python
    rdd = df_green \
        .select('lpep_pickup_datetime', 'PULocationID', 'total_amount') \
        .rdd
    ```

2. We can implement the `WHERE` section by using the `filter()` and `take()` methods:
    * `filter()` returns a new RDD cointaining only the elements that satisfy a _predicate_, which in our case is a function that we pass as a parameter.
    * `take()` takes as many elements from the RDD as stated.
    ```python
    from datetime import datetime

    start = datetime(year=2020, month=1, day=1)

    def filter_outliers(row):
        return row.lpep_pickup_datetime >= start

    rdd.filter(filter_outliers).take(1)
    ```

The `GROUP BY` is more complex and makes use of special methods.

### Operations on RDDs: map, filter, reduceByKey

1. We need to generate _intermediate results_ in a very similar way to the original SQL query, so we will need to create the _composite key_ `(hour, zone)` and a _composite value_ `(amount, count)`, which are the 2 halves of each record that the executors will generate. Once we have a function that generates the record, we will use the `map()` method, which takes an RDD, transforms it with a function (our key-value function) and returns a new RDD.
    ```python
    def prepare_for_grouping(row): 
        hour = row.lpep_pickup_datetime.replace(minute=0, second=0, microsecond=0)
        zone = row.PULocationID
        key = (hour, zone)
        
        amount = row.total_amount
        count = 1
        value = (amount, count)

        return (key, value)
    

    rdd \
        .filter(filter_outliers) \
        .map(prepare_for_grouping)
    ```
2. We now need to use the `reduceByKey()` method, which will take all records with the same key and put them together in a single record by transforming all the different values according to some rules which we can define with a custom function. Since we want to count the total amount and the total number of records, we just need to add the values:
    ```python
    # we get 2 value tuples from 2 separate records as input
    def calculate_revenue(left_value, right_value):
        # tuple unpacking
        left_amount, left_count = left_value
        right_amount, right_count = right_value
        
        output_amount = left_amount + right_amount
        output_count = left_count + right_count
        
        return (output_amount, output_count)
    
    rdd \
        .filter(filter_outliers) \
        .map(prepare_for_grouping) \
        .reduceByKey(calculate_revenue)
    ```
3. The output we have is already usable but not very nice, so we map the output again in order to _unwrap_ it.
    ```python
    from collections import namedtuple
    RevenueRow = namedtuple('RevenueRow', ['hour', 'zone', 'revenue', 'count'])
    def unwrap(row):
        return RevenueRow(
            hour=row[0][0], 
            zone=row[0][1],
            revenue=row[1][0],
            count=row[1][1]
        )

    rdd \
        .filter(filter_outliers) \
        .map(prepare_for_grouping) \
        .reduceByKey(calculate_revenue) \
        .map(unwrap)
    ```
    * Using `namedtuple` isn't necessary but it will help in the next step.

### From RDD to Dataframe

Finally, we can take the resulting RDD and convert it to a dataframe with `toDF()`. We will need to generate a schema first because we lost it when converting RDDs:

Get schema from:
```python
df_result.schema
```
and modify it.

```python
from pyspark.sql import types

result_schema = types.StructType([
    types.StructField('hour', types.TimestampType(), True),
    types.StructField('zone', types.IntegerType(), True),
    types.StructField('revenue', types.DoubleType(), True),
    types.StructField('count', types.IntegerType(), True)
])

df_result = rdd \
    .filter(filter_outliers) \
    .map(prepare_for_grouping) \
    .reduceByKey(calculate_revenue) \
    .map(unwrap) \
    .toDF(result_schema) 
```
* We can use `toDF()` without any schema as an input parameter, but Spark will have to figure out the schema by itself which may take a substantial amount of time. Using `namedtuple` in the previous step allows Spark to infer the column names but Spark will still need to figure out the data types; by passing a schema as a parameter we skip this step and get the output much faster.

#### Save:
```python
df_result.write.parquet('tmp/green-revenue')
```

As you can see, manipulating RDDs to perform SQL-like queries is complex and time-consuming. Ever since Spark added support for dataframes and SQL, manipulating RDDs in this fashion has become obsolete, but since dataframes are built on top of RDDs, knowing how they work can help us understand how to make better use of Spark.

_[Back to the top](#resilient-distributed-datasets--rdds-)_

## Spark RDD mapPartitions

_[Video source](https://www.youtube.com/watch?v=k3uB2K99roI&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=58)_

The `mapPartitions()` function behaves similarly to `map()` in how it receives an RDD as input and transforms it into another RDD with a function that we define but it transforms partitions rather than elements. In other words: `map()` creates a new RDD by transforming every single element, whereas `mapPartitions()` transforms every partition to create a new RDD.

`mapPartitions()` is a convenient method for dealing with large datasets because it allows us to separate it into chunks that we can process more easily, which is handy for workflows such as Machine Learning.

### Using `mapPartitions()` for ML

Let's demonstrate this workflow with an example. Let's assume we want to predict taxi travel length with the green taxi dataset. We will use `VendorID`, `lpep_pickup_datetime`, `PULocationID`, `DOLocationID` and `trip_distance` as our features. We will now create an RDD with these columns:

```python
columns = ['VendorID', 'lpep_pickup_datetime', 'PULocationID', 'DOLocationID', 'trip_distance']

duration_rdd = df_green \
    .select(columns) \
    .rdd
```

Let's now create the method that `mapPartitions()` will use to transform the partitions. This method will essentially call our prediction model on the partition that we're transforming:

```python
import pandas as pd

def model_predict(df):
    # fancy ML code goes here
    (...)
    # predictions is a Pandas dataframe with the field predicted_duration in it
    return predictions

def apply_model_in_batch(rows):
    df = pd.DataFrame(rows, columns=columns)
    predictions = model_predict(df)
    df['predicted_duration'] = predictions

    for row in df.itertuples():
        yield row
```
* We're assuming that our model works with Pandas dataframes, so we need to import the library.
* We are converting the input partition into a dataframe for the model.
    * RDD's do not contain column info, so we use the `columns` param to name the columns because our model may need them.
    * Pandas will crash if the dataframe is too large for memory! We're assuming that this is not the case here, but you may have to take this into account when dealing with large partitions. You can use the [itertools package](https://docs.python.org/3/library/itertools.html) for slicing the partitions before converting them to dataframes.
* Our model will return another Pandas dataframe with a `predicted_duration` column containing the model predictions.
* `df.itertuples()` is an iterable that returns a tuple containing all the values in a single row, for all rows. Thus, `row` will contain a tuple with all the values for a single row.
* `yield` is a Python keyword that behaves similarly to `return` but returns a ***generator object*** instead of a value. This means that a function that uses `yield` can be iterated on. Spark makes use of the generator object in `mapPartitions()` to build the output RDD.
  * You can learn more about the `yield` keyword [in this link](https://realpython.com/introduction-to-python-generators/).

With our defined fuction, we are now ready to use `mapPartitions()` and run our prediction model on our full RDD:

```python
df_predicts = duration_rdd \
    .mapPartitions(apply_model_in_batch)\
    .toDF() \
    .drop('Index')

df_predicts.select('predicted_duration').show()
```
* We're not specifying the schema when creating the dataframe, so it may take some time to compute.
* We drop the `Index` field because it was created by Spark and it is not needed.

As a final thought, you may have noticed that the `apply_model_in_batch()` method does NOT operate on single elements, but rather it takes the whole partition and does something with it (in our case, calling a ML model). If you need to operate on individual elements then you're better off with `map()`.

_[Back to the top](#resilient-distributed-datasets--rdds-)_