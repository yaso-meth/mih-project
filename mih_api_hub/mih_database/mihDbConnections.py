from sqlalchemy import create_engine
import mysql.connector
from urllib.parse import quote_plus
import os
from dotenv import load_dotenv

load_dotenv()
dbUser = os.getenv("DB_USER")
dbPass = os.getenv("DB_PASSWD")
dbHost = "mih-db"
dbPort = 3306
encoded_dbPass = quote_plus(dbPass)
base_connect_url = f"mysql+mysqlconnector://{dbUser}:{encoded_dbPass}@{dbHost}:{dbPort}/"

def dbPatientManagerConnect():
    return create_engine(base_connect_url+"patient_manager", echo=False, pool_recycle=3600)
    # return mysql.connector.connect(
    #     host="mih-db",
    #     user=dbUser,
    #     passwd=dbPass,
    #     database="patient_manager"
    # )

def dbAppDataConnect():
    return create_engine(base_connect_url+"app_data", echo=False, pool_recycle=3600)
    # return mysql.connector.connect(
    #     host="mih-db",
    #     user=dbUser,
    #     passwd=dbPass,
    #     database="app_data"
    # )

def dbDataAccessConnect():
    return create_engine(base_connect_url+"data_access", echo=False, pool_recycle=3600)
    # return mysql.connector.connect(
    #     host="mih-db",
    #     user=dbUser,
    #     passwd=dbPass,
    #     database="data_access"
    # )

def dbMzansiWalletConnect():
    return create_engine(base_connect_url+"mzansi_wallet", echo=False, pool_recycle=3600)
    # return mysql.connector.connect(
    #     host="mih-db",
    #     user=dbUser,
    #     passwd=dbPass,
    #     database="mzansi_wallet"
    # )

def dbMzansiDirectoryConnect():
    return create_engine(base_connect_url+"mzansi_directory", echo=False, pool_recycle=3600)
    # return mysql.connector.connect(
    #     host="mih-db",
    #     user=dbUser,
    #     passwd=dbPass,
    #     database="mzansi_directory"
    # )

def dbMzansiCalendarConnect():
    return create_engine(base_connect_url+"mzansi_calendar", echo=False, pool_recycle=3600)
    # return mysql.connector.connect(
    #     host="mih-db",
    #     user=dbUser,
    #     passwd=dbPass,
    #     database="mzansi_calendar"
    # )

def dbAllConnect():
    return create_engine(base_connect_url, echo=False, pool_recycle=3600)
    # return mysql.connector.connect(
    #     host="mih-db",
    #     user=dbUser,
    #     passwd=dbPass,
    # )