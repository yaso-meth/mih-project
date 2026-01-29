import mysql.connector
import os
from dotenv import load_dotenv

load_dotenv()
dbUser = os.getenv("DB_USER")
dbPass = os.getenv("DB_PASSWD")

def dbPatientManagerConnect():
    return mysql.connector.connect(
        host="mih-db",
        user=dbUser,
        passwd=dbPass,
        database="patient_manager"
    )

def dbAppDataConnect():
    return mysql.connector.connect(
        host="mih-db",
        user=dbUser,
        passwd=dbPass,
        database="app_data"
    )

def dbDataAccessConnect():
    return mysql.connector.connect(
        host="mih-db",
        user=dbUser,
        passwd=dbPass,
        database="data_access"
    )

def dbMzansiWalletConnect():
    return mysql.connector.connect(
        host="mih-db",
        user=dbUser,
        passwd=dbPass,
        database="mzansi_wallet"
    )

def dbMzansiDirectoryConnect():
    return mysql.connector.connect(
        host="mih-db",
        user=dbUser,
        passwd=dbPass,
        database="mzansi_directory"
    )

def dbMzansiCalendarConnect():
    return mysql.connector.connect(
        host="mih-db",
        user=dbUser,
        passwd=dbPass,
        database="mzansi_calendar"
    )

def dbAllConnect():
    return mysql.connector.connect(
        host="mih-db",
        user=dbUser,
        passwd=dbPass,
    )