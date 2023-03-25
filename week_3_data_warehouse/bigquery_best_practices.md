>[Back to Week Menu](README.md)
>
>Previous Theme: [Partitioning and clustering](partitioning_clustering.md)
>
>Next Theme: [Internals of BigQuery](internals_bigquery.md)

## Best practices

_[Video source](https://youtu.be/k81mLJVX08w)_

Here's a list of [best practices for BigQuery](https://cloud.google.com/bigquery/docs/best-practices-performance-overview):

* **Cost reduction**
  * **Avoid** `SELECT *` . Reducing the amount of columns to display will drastically reduce the amount of processed data and lower costs. **BigQuery** stores data in a **column storage**.
  * **Price** your queries **before running** them.
  * Use **clustered and/or partitioned** tables if possible.
  * Use [streaming inserts](https://cloud.google.com/bigquery/streaming-data-into-bigquery) **with caution**. They can easily increase cost.
  * [Materialize query results](https://cloud.google.com/bigquery/docs/materialized-views-intro) in different stages.
* **Query performance**
  * **Filter on partitioned** columns.
  * [Denormalize data](https://cloud.google.com/blog/topics/developers-practitioners/bigquery-explained-working-joins-nested-repeated-data).
  * Use [nested or repeated columns](https://cloud.google.com/blog/topics/developers-practitioners/bigquery-explained-working-joins-nested-repeated-data).
  * Use **external data sources appropriately**. Constantly reading data from a bucket may incur in additional costs and has worse performance.
  * **Reduce data** before using a `JOIN`.
  * Do not threat `WITH` clauses as [prepared statements](https://www.wikiwand.com/en/Prepared_statement).
  * Avoid [oversharding tables](https://cloud.google.com/bigquery/docs/partitioned-tables#dt_partition_shard).
  * **Avoid** JavaScript user-defined functions.
  * Use [approximate aggregation functions](https://cloud.google.com/bigquery/docs/reference/standard-sql/approximate_aggregate_functions) like [HyperLogLog++](https://cloud.google.com/bigquery/docs/reference/standard-sql/hll_functions).
  * **Order** statements should be the **last part** of the query.
  * [Optimize join patterns](https://cloud.google.com/bigquery/docs/best-practices-performance-compute#optimize_your_join_patterns).
  * Place the table with the _largest_ number of rows first, followed by the table with the _fewest_ rows, and then place the remaining tables by decreasing size.
    * This is due to how BigQuery works internally: the first table will be distributed evenly and the second table will be broadcasted to all the nodes.

_[Back to the top](#best-practices)_