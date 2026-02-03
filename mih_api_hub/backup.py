from typing import Union
#import DatabaseConnect
import mysql.connector
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI()

def dbPatientManagerConnect():
    return mysql.connector.connect(
        host="mysqldb",
        user="root",
        passwd="root",
        database="patient_manager"
    )

class fileRequest(BaseModel):
    DocOfficeID: int
    patientID: int

# Check if server is up
@app.get("/")
def read_root():
    return serverRunning()

# Get Doctors Office By ID
@app.get("/docOffices/{docOffic_id}")
def read_docOfficeByID(docOffic_id: int):
    db = dbPatientManagerConnect()
    cursor = db.cursor()
    query = "SELECT * FROM doctor_offices WHERE iddoctor_offices=%s"
    cursor.execute(query, (docOffic_id,))
    item = cursor.fetchone()
    cursor.close()
    db.close()
    if item is None:
        raise HTTPException(status_code=404, detail="Item not found")
    return {"iddoctor_offices": item[0],
            "office_name": item[1]}

# Get List of all Doctors Office
@app.get("/docOffices/")
def read_All_DoctorsOffice():
    db = dbPatientManagerConnect()
    cursor = db.cursor()
    query = "SELECT * FROM doctor_offices"
    cursor.execute(query)
    items = [
        {
            "iddoctor_offices": item[0],
            "office_name": item[1]
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items

# Get Patient By ID Number
@app.get("/patients/{id_no}")
def read_patientByID(id_no: str):
    db = dbPatientManagerConnect()
    cursor = db.cursor()
    query = "SELECT * FROM patients WHERE id_no=%s"
    cursor.execute(query, (id_no,))
    item = cursor.fetchone()
    cursor.close()
    db.close()
    if item is None:
        raise HTTPException(status_code=404, detail="Item not found")
    return {"idpatients": item[0],
    "id_no": item[1],
    "first_name": item[2],
    "last_name": item[3],
    "email": item[4],
    "cell_no": item[5],
    "medical_aid_name": item[6],
    "medical_aid_no": item[7],
    "medical_aid_scheme": item[8],
    "address": item[9],
    "doc_office_id": item[10]}

# Get List of all patients
@app.get("/patients/")
def read_all_patients():
    db = dbPatientManagerConnect()
    cursor = db.cursor()
    query = "SELECT * FROM patients"
    cursor.execute(query)
    items = [
        {
            "idpatients": item[0],
            "id_no": item[1],
            "first_name": item[2],
            "last_name": item[3],
            "email": item[4],
            "cell_no": item[5],
            "medical_aid_name": item[6],
            "medical_aid_no": item[7],
            "medical_aid_scheme": item[8],
            "address": item[9],
            "doc_office_id": item[10]
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items

# Get List of all patients by Doctors Office
@app.get("/docOffice/patients/{docoff_id}")
def read_all_patientsby(docoff_id: str):
    db = dbPatientManagerConnect()
    cursor = db.cursor()
    query = "SELECT * FROM patients where doc_office_id=%s"
    cursor.execute(query, (docoff_id,))
    items = [
        {
            "idpatients": item[0],
            "id_no": item[1],
            "first_name": item[2],
            "last_name": item[3],
            "email": item[4],
            "cell_no": item[5],
            "medical_aid_name": item[6],
            "medical_aid_no": item[7],
            "medical_aid_scheme": item[8],
            "address": item[9],
            "doc_office_id": item[10]
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items

# Get List of all files
@app.get("/patients/files/")
def read_all_files():
    db = dbPatientManagerConnect()
    cursor = db.cursor()
    query = "SELECT * FROM patient_files"
    cursor.execute(query)
    items = [
        {
            "idpatient_files": item[0],
            "file_path": item[1],
            "file_name": item[2],
            "patient_id": item[3],
            "insert_date": item[4],
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items

# Get List of all files by patient
@app.get("/patients/files/{patientID}")
def read_all_files_by_patient(patientID: int):
    db = dbPatientManagerConnect()
    cursor = db.cursor()
    query = "SELECT * FROM patient_files where patient_id = %s"
    cursor.execute(query, (patientID,))
    items = [
        {
            "idpatient_files": item[0],
            "file_path": item[1],
            "file_name": item[2],
            "patient_id": item[3],
            "insert_date": item[4],
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items

# Get List of all notes
@app.get("/patients/notes/")
def read_all_notes():
    db = dbPatientManagerConnect()
    cursor = db.cursor()
    query = "SELECT * FROM patient_notes"
    cursor.execute(query)
    items = [
        {
            "idpatient_notes": item[0],
            "note_name": item[1],
            "note_text": item[2],
            "insert_date": item[3],
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items

# Get List of all notes by patient
@app.get("/patients/notes/{patientID}")
def read_all_patientsby(patientID: int):
    db = dbPatientManagerConnect()
    cursor = db.cursor()
    query = "SELECT * FROM patient_notes where patient_id = %s"
    cursor.execute(query, (patientID,))
    items = [
        {
            "idpatient_notes": item[0],
            "note_name": item[1],
            "note_text": item[2],
            "insert_date": item[3],
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items


def serverRunning():
    return {"Status": "Server is Up and Running"}


