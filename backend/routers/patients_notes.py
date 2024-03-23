import mysql.connector
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

router = APIRouter()

def dbConnect():
    return mysql.connector.connect(
        host="mysqldb",
        user="root",
        passwd="root",
        database="patient_manager"
    )

class fileRequest(BaseModel):
    DocOfficeID: int
    patientID: int

# Get List of all notes
@router.get("/notes/patients/", tags="patients_notes")
async def read_all_notes():
    db = dbConnect()
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
@router.get("/notes/patients/{patientID}", tags="patients_notes")
async def read_all_patientsby(patientID: int):
    db = dbConnect()
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

# Get List of all notes by patient
@router.get("/notes/patients-docOffice/", tags="patients_notes")
async def read_all_patientsby(itemRequest: fileRequest):
    db = dbConnect()
    cursor = db.cursor()
    query = "select patient_notes.idpatient_notes, patient_notes.note_name, patient_notes.note_text, patient_notes.patient_id, patient_notes.insert_date, patients.doc_office_id "
    query += "from patient_manager.patient_notes "
    query += "inner join patient_manager.patients "
    query += "on patient_notes.patient_id = patients.idpatients "
    query += "where patient_notes.patient_id = %s and patients.doc_office_id = %s"
    cursor.execute(query, (itemRequest.patientID, itemRequest.DocOfficeID,))
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

