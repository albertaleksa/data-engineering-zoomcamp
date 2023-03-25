>[Back to Week Menu](README.md)
>
>Previous Theme: [Internals of BigQuery](internals_bigquery.md)
>
>Next Theme: [Deploying ML model](bigquery_ml_deploy.md)

## Machine Learning with BigQuery

_[Video source](https://youtu.be/B-WtpB0PuG4)_

[SQL for ML in BigQuery](big_query_ml.sql)


### Introduction to BigQuery ML

***BigQuery ML***:
- Target audience - Data analyst, managers
- Allow to create and execute Machine Learning models using standard SQL queries (without knowledge of Python or other programming languages) 
- Without the need to export data into a different system.

The pricing for BigQuery ML is slightly different and more complex than regular BigQuery. Some resources are free of charge up to a specific limit as part of the [Google Cloud Free Tier](https://cloud.google.com/free). You may check the current pricing [in this link](https://cloud.google.com/bigquery-ml/pricing).

BQ ML offers a variety of ML models depending on the use case, as the image below shows:

![bq ml](../images/dw_05.png)

_[Back to the top](#machine-learning-with-bigquery)_

### Example of BQ ML work

- Get interested information
    ```sql
    -- SELECT THE COLUMNS INTERESTED FOR YOU
    SELECT passenger_count, trip_distance, PULocationID, DOLocationID, payment_type, fare_amount, tolls_amount, tip_amount
    FROM `nytaxi.yellow_tripdata_partitoned` WHERE fare_amount != 0;
    ```

- Create a custom table with correct data types which we can use for ML model:
  * BQ supports [***feature preprocessing***](https://cloud.google.com/bigquery-ml/docs/reference/standard-sql/bigqueryml-syntax-preprocess-overview), both ***manual*** and ***automatic***.
  * A few columns such as `PULocationID` are categorical in nature but are represented with integer numbers in the original table. We ***cast*** them as strings in order to get BQ to automatically preprocess them as categorical features that will be one-hot encoded.
    ```sql
    -- CREATE A ML TABLE WITH APPROPRIATE TYPE
    CREATE OR REPLACE TABLE `nytaxi.yellow_tripdata_ml` (
    `passenger_count` INTEGER,
    `trip_distance` FLOAT64,
    `PULocationID` STRING,
    `DOLocationID` STRING,
    `payment_type` STRING,
    `fare_amount` FLOAT64,
    `tolls_amount` FLOAT64,
    `tip_amount` FLOAT64
    ) AS (
    SELECT CAST(passenger_count AS INTEGER), trip_distance, cast(PULocationID AS STRING), CAST(DOLocationID AS STRING),
    CAST(payment_type AS STRING), fare_amount, tolls_amount, tip_amount
    FROM `nytaxi.yellow_tripdata_partitoned` WHERE fare_amount != 0
    );
    ```
    
- Create a simple linear regression model with default settings:
  * Our target feature for the model will be `tip_amount`. We drop all records where `tip_amount` equals zero in order to improve training.
  * The `CREATE MODEL` clause will create the `nytaxi.tip_model` model
  * The `OPTIONS()` clause contains all of the necessary arguments to create our model:
    * `model_type='linear_reg'` is for specifying that we will create a linear regression model.
    * `input_label_cols=['tip_amount']` lets BQ know that our target feature is `tip_amount`. For linear regression models, target features must be real numbers.
    * `DATA_SPLIT_METHOD='AUTO_SPLIT'` is for automatically splitting the dataset into train/test datasets.
  * The `SELECT` statement indicates which features need to be considered for training the model.
    * Since we already created a dedicated table with all of the needed features, we simply select them all.

    ```sql
    -- CREATE MODEL WITH DEFAULT SETTING
    CREATE OR REPLACE MODEL `nytaxi.tip_model`
    OPTIONS
    (model_type='linear_reg',
    input_label_cols=['tip_amount'],
    DATA_SPLIT_METHOD='AUTO_SPLIT') AS
    SELECT
    *
    FROM
    `nytaxi.yellow_tripdata_ml`
    WHERE
    tip_amount IS NOT NULL;
    ```

  * After the query runs successfully, the BQ explorer in the side panel will show all available models (just one in our case) with a special icon. Selecting a model will open a new tab with additional info such as **model details**, **training graphs** and **evaluation metrics**.

- We can also get a description of the **features** with the following query:

    ```sql
    SELECT * FROM ML.FEATURE_INFO(MODEL `nytaxi.tip_model`);
    ```
  * The output will be similar to `describe()` in Pandas.

- Evaluation model against the training data:

    ```sql
    SELECT
    *
    FROM
    ML.EVALUATE(MODEL `nytaxi.tip_model`,
    (
    SELECT
    *
    FROM
    `nytaxi.yellow_tripdata_ml`
    WHERE
    tip_amount IS NOT NULL
    ));
    ```
  * This will output similar metrics to those shown in the model info tab but with the updated values for the evaluation against the provided dataset.
  * In this example we evaluate with the same dataset we used for training the model, so this is a silly example for illustration purposes.

- The main purpose of a ML model is to make predictions. A `ML.PREDICT` statement is used for doing them:
  * The `SELECT` statement within `ML.PREDICT` provides the records for which we want to make predictions.
  * Once again, we're using the same dataset we used for training to calculate predictions, so we already know the actual tips for the trips, but this is just an example.

    ```sql
    SELECT
    *
    FROM
    ML.PREDICT(MODEL `nytaxi.tip_model`,
    (
    SELECT
    *
    FROM
    `nytaxi.yellow_tripdata_ml`
    WHERE
    tip_amount IS NOT NULL
    ));
    ```

- Additionally, BQ ML has a special `ML.EXPLAIN_PREDICT` statement that will return the prediction along with the most important features that were involved in calculating the prediction for each of the records we want predicted.
    ```sql
    SELECT
    *
    FROM
    ML.EXPLAIN_PREDICT(MODEL `nytaxi.tip_model`,
    (
    SELECT
    *
    FROM
    `nytaxi.yellow_tripdata_ml`
    WHERE
    tip_amount IS NOT NULL
    ), STRUCT(3 as top_k_features));
    ```
  * This will return a similar output to the previous query but for each prediction, 3 additional rows will be provided with the most significant features along with the assigned weights for each feature.

- Just like in regular ML models, BQ ML models can be improved with ***hyperparameter tuning***. Here's an example query for tuning:
  * We create a new model as normal but we add the `num_trials` option as an argument.
  * All of the regular arguments used for creating a model are available for tuning. In this example we opt to tune the L1 and L2 regularizations.
  * All of the necessary reference documentation is available [in this link](https://cloud.google.com/bigquery-ml/docs/reference).

    ```sql
    CREATE OR REPLACE MODEL `nytaxi.tip_hyperparam_model`
    OPTIONS
    (model_type='linear_reg',
    input_label_cols=['tip_amount'],
    DATA_SPLIT_METHOD='AUTO_SPLIT',
    num_trials=5,
    max_parallel_trials=2,
    l1_reg=hparam_range(0, 20),
    l2_reg=hparam_candidates([0, 0.1, 1, 10])) AS
    SELECT
    *
    FROM
    `nytaxi.yellow_tripdata_ml`
    WHERE
    tip_amount IS NOT NULL;
    ```

_[Back to the top](#machine-learning-with-bigquery)_