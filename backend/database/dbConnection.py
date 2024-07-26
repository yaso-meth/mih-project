import mysql.connector

def dbConnect():
    return mysql.connector.connect(
        host="mysqldb",
        user="root",
        passwd="C@rtoon1995",
        database="patient_manager"
    )

def dbAppDataConnect():
    return mysql.connector.connect(
        host="mysqldb",
        user="root",
        passwd="C@rtoon1995",
        database="app_data"
    )