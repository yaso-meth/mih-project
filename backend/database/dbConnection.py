import mysql.connector

def dbConnect():
    return mysql.connector.connect(
        host="mysqldb",
        user="root",
        passwd="C@rtoon1995",
        database="patient_manager"
    )