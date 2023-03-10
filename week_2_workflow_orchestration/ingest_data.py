#!/usr/bin/env python
# coding: utf-8

import pandas as pd
import argparse
import os
from time import time
from sqlalchemy import create_engine
from prefect import flow, task

@task(log_prints=True, retries=3)
def ingest_data(user, password, host, port, db, table_name, url):

    if url.endswith('.csv.gz'):
        csv_name = 'yellow_tripdata_2021-01.csv.gz'
    else:
        csv_name = 'output.csv'

    # download the csv
    os.system(f"wget {url} -O {csv_name}")

    engine = create_engine(f"postgresql://{user}:{password}@{host}:{port}/{db}")

    df_iter = pd.read_csv(csv_name, iterator=True, chunksize=100000)

    df = next(df_iter)

    df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
    df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)

    # create table
    df.head(n=0).to_sql(name=table_name, con=engine, if_exists='replace')

    df.to_sql(name=table_name, con=engine, if_exists='append')

    # for chunk in df_iter:
    #     t_start = time()
    #     chunk.tpep_pickup_datetime = pd.to_datetime(chunk.tpep_pickup_datetime)
    #     chunk.tpep_dropoff_datetime = pd.to_datetime(chunk.tpep_dropoff_datetime)
    #     chunk.to_sql(name=table_name, con=engine, if_exists='append')
    #     t_end = time()
    #     print("inserted another chunk, took %.3f second" % (t_end - t_start))

@flow(name="Ingest Flow")
def main_flow():
    user = "root"
    password = "root"
    host = "localhost"
    port = "5432"
    db = "ny_taxi"
    table_name = "yellow_taxi_trip"
    csv_url = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz"

    ingest_data(user, password, host, port, db, table_name, csv_url)


if __name__ == '__main__':
    main_flow()

