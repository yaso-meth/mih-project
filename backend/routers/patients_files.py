import mysql.connector
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

router = APIRouter()

class fileRequest(BaseModel):
    DocOfficeID: int
    patientID: int

def dbConnect():
    return mysql.connector.connect(
        host="mysqldb",
        user="root",
        passwd="root",
        database="patient_manager"
    )

# Get List of all files
@router.get("/files/patients/", tags="patients_files")
async def read_all_files():
    db = dbConnect()
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
@router.get("/files/patients/{patientID}", tags="patients_files")
async def read_all_files_by_patient(patientID: int):
    db = dbConnect()
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

# Get List of all files by patient & DocOffice
@router.get("/files/patients-docOffice/", tags="patients_files")
async def read_all_files_by_patient(itemRequest: fileRequest):
    db = dbConnect()
    cursor = db.cursor()
    query = "select patient_files.idpatient_files, patient_files.file_path, patient_files.file_name, patient_files.patient_id, patient_files.insert_date, patients.doc_office_id "
    query += "from patient_manager.patient_files "
    query += "inner join patient_manager.patients "
    query += "on patient_files.patient_id = patients.idpatients "
    query += "where patient_files.patient_id = %s and patients.doc_office_id = %s"
    cursor.execute(query, (itemRequest.patientID, itemRequest.DocOfficeID,))
    
    items = [
        {
            "idpatient_files": item[0],
            "file_path": item[1],
            "file_name": item[2],
            "patient_id": item[3],
            "insert_date": item[4],
            "doc_office_id": item[5]
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items