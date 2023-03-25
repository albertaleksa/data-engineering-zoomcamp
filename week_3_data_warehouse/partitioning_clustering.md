>[Back to Week Menu](README.md)
>
>Previous Theme: [Data Warehouse](dw_bigquery.md)
>
>Next Theme: [Best practices](bigquery_best_practices.md)

## Partitioning and clustering
_[Video source1](https://youtu.be/jrHljAoD6nM?t=726)_
_[Video source2](https://youtu.be/-CqXf7vhhDs)_

[Big Query basic SQL](big_query.sql)

### Partitioning

BQ tables can be ***partitioned*** into multiple smaller tables. For example, if we often filter queries based on date, we could partition a table based on date so that we only query a specific sub-table based on the date we're interested in.

[Partition tables](https://cloud.google.com/bigquery/docs/partitioned-tables) are very useful to improve performance and reduce costs, because BQ will not process as much data per query.

You may partition a table by:
* ***Time-unit column***: tables are partitioned based on a `TIMESTAMP`, `DATE`, or `DATETIME` column in the table.
* ***Ingestion time***: tables are partitioned based on the timestamp when BigQuery ingests the data.
* ***Integer range***: tables are partitioned based on an integer column.

For ***Time-unit*** and ***Ingestion time*** columns, the partition may be:
* daily (the default option)
* hourly
* monthly or yearly.

>Note: BigQuery limits the amount of partitions to 4000 per table. If you need more partitions, consider [clustering](#clustering) as well.

Here's an example query for creating a partitioned table:

```sql
CREATE OR REPLACE TABLE nytaxi.yellow_tripdata_partitoned
PARTITION BY
  DATE(tpep_pickup_datetime) AS
SELECT * FROM nytaxi.external_yellow_tripda
```

BQ will identify partitioned tables with a specific icon. The _Details_ tab of the table will specify the field which was used for partitioning the table and its datatype.

Querying a partitioned table is identical to querying a non-partitioned table, but the amount of processed data may be drastically different. Here are 2 identical queries to the non-partitioned and partitioned tables we created in the previous queries:

For seeing clear results we disable cache for queries:
> More -> Query settings -> Cache preference -> Uncheck 'Use cached results' -> Save 

```sql
SELECT DISTINCT(VendorID)
FROM nytaxi.yellow_tripdata_non_partitoned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-03-01' AND '2019-03-10';
```
* Query to non-partitioned table.
* It will process around 276 MB of data

```sql
SELECT DISTINCT(VendorID)
FROM nytaxi.yellow_tripdata_partitoned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-03-01' AND '2019-03-10';
```
* Query to partitioned table.
* It will process around 40 MB of data.

You may check the amount of rows of each partition in a partitioned table with a query such as this:

```sql
SELECT table_name, partition_id, total_rows
FROM `nytaxi.INFORMATION_SCHEMA.PARTITIONS`
WHERE table_name = 'yellow_tripdata_partitoned'
ORDER BY total_rows DESC;
```

This is useful to check if there are data imbalances and/or biases in your partitions.

_[Back to the top](#partitioning-and-clustering)_

### Clustering

- ***Clustering*** consists of rearranging a table based on the values of its columns so that the table is ordered according to any criteria.
- Clustering can be done based on one or multiple **columns up to 4**
- the ***order*** of the columns in which the clustering is specified is **important** in order to determine the column priority.
- Clustering may **improve** performance and lower costs on big datasets for certain types of queries, such as queries that use:
  - **filter** clauses and queries that 
  - **aggregate** data.

>Note: tables with less than 1GB don't show significant improvement with partitioning and clustering; doing so in a small table could even lead to increased cost due to the additional metadata reads and maintenance needed for these features.

Clustering columns must be ***top-level***, ***non-repeated*** columns. The following datatypes are supported:
* `DATE`
* `BOOL`
* `GEOGRAPHY`
* `INT64`
* `NUMERIC`
* `BIGNUMERIC`
* `STRING`
* `TIMESTAMP`
* `DATETIME`

A partitioned table can also be clustered. Here's an example query for creating a partitioned and clustered table:

```sql
CREATE OR REPLACE TABLE nytaxi.yellow_tripdata_partitoned_clustered
PARTITION BY DATE(tpep_pickup_datetime)
CLUSTER BY VendorID AS
SELECT * FROM nytaxi.external_yellow_tripdata;
```

Just like for partitioned tables, the _Details_ tab for the table will also display the fields by which the table is clustered.

Here are 2 identical queries, one for a partitioned table and the other for a partitioned and clustered table:

```sql
SELECT count(*) as trips
FROM nytaxi.yellow_tripdata_partitoned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-03-01' AND '2021-01-31'
  AND VendorID=1;
```
* Query to non-clustered, partitioned table.
* This will process about 255.1 MB of data.

```sql
SELECT count(*) as trips
FROM nytaxi.yellow_tripdata_partitoned_clustered
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-03-01' AND '2021-01-31'
  AND VendorID=1;
```
* Query to partitioned and clustered data.
* This will process about 196.51 MB of data.

_[Back to the top](#partitioning-and-clustering)_

### Partitioning vs Clustering

_[Video source](https://youtu.be/-CqXf7vhhDs)_

As mentioned before, you may combine both partitioning and clustering in a table, but there are important differences between both techniques that you need to be aware of in order to decide what to use for your specific scenario:

| Clustering                                                                                                                      | Partitioning                                                                                       |
|---------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------|
| **Cost** benefit **unknown**. BQ cannot estimate the reduction in cost before running a query.                                  | **Cost known** upfront. BQ can estimate the amount of data to be processed before running a query. |
| **High granularity**. Multiple criteria can be used to sort the table.                                                          | **Low granularity**. Only a single column can be used to partition the table.                      |
| Clusters are **"fixed in place"**.                                                                                              | Partitions can be **added, deleted, modified or even moved** between storage options.              |
| Benefits from queries that commonly use filters or aggregation against **multiple particular columns**.                         | Benefits when you filter or aggregate on a **single column**.                                      |
| **Unlimited amount** of clusters; useful when the cardinality of the number of values in a column or group of columns is large. | Limited to **4000 partitions**; cannot be used in columns with larger cardinality.                 |

### Clustering over partitioning:
- Partitioning results in a **small** amount of data per partition (~ < 1 GB)
- Partitioning results in **> 4000** partitions
- Partitioning results in your **mutation operations** modifying the **majority** of partitions in the table frequently (for example, writing to the table every few minutes and writing to most of the partitions each time rather than just a handful).

### Automatic reclustering

As data is **added** to a clustered table: 
- the newly inserted data can be written to blocks that contain key ranges that **overlap** with the key ranges in previously written blocks
- These overlapping keys **weaken the sort** property of the table.

To maintain the **performance** characteristics of a clustered table:
- BQ performs _automatic reclustering_ in the background to restore the sort properties of the table
- For partitioned tables, clustering is maintained for data within the scope of each partition.

_[Back to the top](#partitioning-and-clustering)_