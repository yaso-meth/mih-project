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

def dbMzansiWalletConnect():
    return mysql.connector.connect(
        host="mysqldb",
        user="root",
        passwd="C@rtoon1995",
        database="mzansi_wallet"
    )

def dbMzansiCalendarConnect():
    return mysql.connector.connect(
        host="mysqldb",
        user="root",
        passwd="C@rtoon1995",
        database="mzansi_calendar"
    )

def dbAllConnect():
    return mysql.connector.connect(
        host="mysqldb",
        user="root",
        passwd="C@rtoon1995",
    )