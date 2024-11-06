import mysql.connector

def dbPatientManagerConnect():
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

def dbDataAccessConnect():
    return mysql.connector.connect(
        host="mysqldb",
        user="root",
        passwd="C@rtoon1995",
        database="data_access"
    )

def dbAllConnect():
    return mysql.connector.connect(
        host="mysqldb",
        user="root",
        passwd="C@rtoon1995",
    )