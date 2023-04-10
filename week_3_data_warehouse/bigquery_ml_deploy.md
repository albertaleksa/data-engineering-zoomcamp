>[Back to Week Menu](README.md)
>
>Previous Theme: [BigQuery Machine Learning](bigquery_ml.md) 
>
> [Homework](../cohorts/2023/week_3_data_warehouse/homework.md)

## BigQuery ML deployment

_[Video source](https://youtu.be/BjARzEWaznU)_

ML models created within BQ can be exported and deployed to Docker containers running TensorFlow Serving.

The following steps are based on [this official tutorial](https://cloud.google.com/bigquery-ml/docs/export-model-tutorial). All of these commands are to be run from a terminal and the gcloud sdk must be installed.

### In VM:
1. Authenticate to your GCP project.
    ```sh
    gcloud auth login
    ```
2. Export the model to a Cloud Storage bucket.
    ```sh
    bq --project_id substantial-mix-378619 extract -m nytaxi.tip_model gs://dtc_data_lake_substantial-mix-378619/taxi_ml_model/tip_model
    ```
3. Download the exported model files to a temporary directory.
    ```sh
    mkdir /tmp/model

    gsutil cp -r gs://dtc_data_lake_substantial-mix-378619/taxi_ml_model/tip_model /tmp/model
    ```
4. Create a version subdirectory (In VM in project dir `~/data-engineering-zoomcamp/`) and copy all from `/tmp/model/tip_model/`
    ```sh
    mkdir -p serving_dir/tip_model/1

    cp -r /tmp/model/tip_model/* serving_dir/tip_model/1

    # Optionally you may erase the temporary directory
    rm -r /tmp/model
    ```
5. Pull the TensorFlow Serving Docker image
    ```sh
    docker pull tensorflow/serving
    ```
6. Run the Docker image. Mount the version subdirectory as a volume and provide a value for the `MODEL_NAME` environment variable.
    ```sh
    # Make sure you don't mess up the spaces!
    docker run \
      -p 8501:8501 \
      --mount type=bind,source=`pwd`/serving_dir/tip_model,target=/models/tip_model \
      -e MODEL_NAME=tip_model \
      -t tensorflow/serving &
    ```
7. Now we can check version of our model using http GET request
   (we can use Postman or curl )
    ```sh
    curl \
      -X GET http://localhost:8501/v1/models/tip_model
    ```
   Result:
    ```
    {
     "model_version_status": [
      {
       "version": "1",
       "state": "AVAILABLE",
       "status": {
        "error_code": "OK",
        "error_message": ""
       }
      }
     ]
    }
    ```

8. With the image running, run a prediction with curl (POST request), providing values for the features used for the predictions.
    ```sh
    curl \
      -d '{"instances": [{"passenger_count":1, "trip_distance":12.2, "PULocationID":"193", "DOLocationID":"264", "payment_type":"1","fare_amount":20.4,"tolls_amount":0.0}]}' \
      -X POST http://localhost:8501/v1/models/tip_model:predict
    ```
   Result:
    ```
    {
        "predictions": [[3.4244303745090292]
        ]
    }
    ```
    Let's change our `payment_type` from 1 to 2:
    ```sh
    curl \
      -d '{"instances": [{"passenger_count":1, "trip_distance":12.2, "PULocationID":"193", "DOLocationID":"264", "payment_type":"2","fare_amount":20.4,"tolls_amount":0.0}]}' \
      -X POST http://localhost:8501/v1/models/tip_model:predict
    ```
   Result:
    ```
    {
        "predictions": [[0.60357752793606778]
        ]
    }
    ```

_[Back to the top](#bigquery-ml-deployment)_