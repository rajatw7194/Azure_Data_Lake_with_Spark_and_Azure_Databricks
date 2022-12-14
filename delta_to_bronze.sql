dbutils.fs.ls("dbfs:/FileStore/tables")

delta_files = [
    {'path':'dbfs:/FileStore/payments.csv', 'table':'bronze_payments', 'columns': ['payment_id', 'payment_date', 'amount', 'rider_id']},
    {'path':'dbfs:/FileStore/stations.csv', 'table':'bronze_stations', 'columns': ['station_id', 'name', 'latitude', 'longitude']},
    {'path':'dbfs:/FileStore/riders.csv', 'table':'bronze_riders', 'columns': ['rider_id', 'firstname', 'lastname', 'address', 'birthday', 'account_start_date', 'account_end_date', 'is_member']},
    {'path':'dbfs:/FileStore/trips.csv', 'table':'bronze_trips', 'columns': ['trip_id', 'rideable_type', 'trip_start_date', 'trip_end_date', 'start_station_id', 'end_station_id', 'rider_id']}
]

def create_bronze_table(table_name: str, file_location: str, columns: list): 
    (
     spark.read
        .option("inferSchema", "false")
        .option("header", "false")
        .option("sep", ",")
        .csv(file_location) 
        .toDF(*columns)
        .write 
        .format("delta") 
        .mode("overwrite") 
        .save(f"/delta/{table_name}")
    )

for file in delta_files:
    create_bronze_table(file['table'], file['path'], file['columns'])
