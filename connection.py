import sqlite3
import csv
from config import DBConfig, get_logger

database_url = 'flight_sample.db'
logger = get_logger(__name__)

# Util Functions
def csv_to_tuple(file: str):
    with open(file, newline="") as f:
        reader = csv.DictReader(f)
        flight_tuples = [
            (
                row["origin"], row["destination"], 
                row["airline"], int(row["duration_mins"]), 
                row['date']
            )   for row in reader
        ]
    return flight_tuples

#  Context Manager to Open and Close Connections
with sqlite3.connect(database_url) as conn:
    # Create a cursor object
    cursor = conn.cursor()

    logger.info("Database created and connected successfully!")

    # Create Database Tables
    create_table_query = '''
    CREATE TABLE IF NOT EXISTS flight_samples (
        flight_id INTEGER PRIMARY KEY AUTOINCREMENT,
        origin TEXT NOT NULL, 
        destination TEXT NOT NULL, 
        airline TEXT NOT NULL, 
        duration_mins INTEGER, 
        date DATE NOT NULL
    );
    '''
    cursor.execute(create_table_query)
    logger.info("Table 'flight_samples' created successfully!")

    #  Insert single row into a Table
    insert_query = '''
        INSERT INTO flight_samples (origin, destination, airline, duration_mins, date)
        VALUES (?, ?, ?, ?, ?);
    '''
    flight_sample_data = ('NBO', 'JNB', 'Kenya Airways', 195, '2024-01-03')
    cursor.execute(insert_query, flight_sample_data)
    logger.info("Record inserted successfully!")

    # Insert Multiple Records
    flight_samples_data = csv_to_tuple('flights_sample.csv')
    cursor.executemany(insert_query, flight_samples_data)
    logger.info(f"{len(flight_samples_data)} records inserted successfully!")

    # Commit the changes automatically
    conn.commit()
