# Commands

## Jupyter notebook

To run jupyter notebook, in the terminal run:
```
jupyter notebook
```

Convert a Jupyter notebook to a script:
```
jupyter nbconvert --to=script upload-data.ipynb
```

`upload-data.ipynb` was the name of the notebook we created. The script name will be `upload-data.py`.

## Docker

Run docker images for Postgres & PgAdmin using docker network:
```
docker network create pg-network

# network
# postgres
docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
  -p 5432:5432 \
  --network=pg-network \
  --name pg-database \
  postgres:13


# network
# pgadmin
docker run -it \
  -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
  -e PGADMIN_DEFAULT_PASSWORD="root" \
  -p 8080:80 \
  --network=pg-network \
  --name pgadmin \
  dpage/pgadmin4
```

## Run Python script

Path to data: `URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz"`

### Run python script
```
python ingest_data.py \
  --user=root \
  --password=root \
  --host=localhost \
  --port=5432 \
  --db=ny_taxi \
  --table_name=yellow_taxi_trips \
  --url=${URL}
```

### Run python script in **docker** container

Build docker image using Docker file:
```
docker build -t taxi_ingest:v001 .
```
Run docker container `taxi_ingest:v001` with network **pg-network**:
```
docker run -it \
  --network=pg-network \
  taxi_ingest:v001 \
  --user=root \
  --password=root \
  --host=pgdatabase \
  --port=5432 \
  --db=ny_taxi \
  --table_name=yellow_taxi_trips \
  --url=${URL}
```

## Docker-compose

```
services:
  pgdatabase:
    image: postgres:13
    environment:
      - POSTGRES_USER=root
      - POSTGRES_PASSWORD=root
      - POSTGRES_DB=ny_taxi
    volumes:
      - "./ny_taxi_postgres_data:/var/lib/postgresql/data:rw"
    ports:
      - "5432:5432"
  pgadmin:
    image: dpage/pgadmin4
    environment:
      - PGADMIN_DEFAULT_EMAIL=admin@admin.com
      - PGADMIN_DEFAULT_PASSWORD=root
    volumes:
      - "pgadmin_conn_data:/var/lib/pgadmin:rw"
    ports:
      - "8080:80"
volumes:
  pgadmin_conn_data:
```

  
  
  


