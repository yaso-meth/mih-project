import mysql.connector
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from datetime import date
from ..database import dbConnection

router = APIRouter()

class fileRequest(BaseModel):
    DocOfficeID: int
    patientID: int

class patientNoteInsertRequest(BaseModel):
    note_name: str
    note_text: str
    patient_id: int

class patientNoteUpdateRequest(BaseModel):
    idpatient_notes: int
    note_name: str
    note_text: str
    patient_id: int

# Get List of all notes
@router.get("/notes/patients/", tags="patients_notes")
async def read_all_notes():
    db = dbConnection.dbConnect()
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
    db = dbConnection.dbConnect()
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
    db = dbConnection.dbConnect()
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

# Insert Patient note into table
@router.post("/notes/insert/", tags="patients_notes", status_code=201)
async def insertPatientNotes(itemRequest : patientNoteInsertRequest):
    today = date.today()
    db = dbConnection.dbConnect()
    cursor = db.cursor()
    query = "insert into patient_notes "
    query += "(note_name, note_text, patient_id, insert_date) "
    query += "values (%s, %s, %s, %s)"
    notetData = (itemRequest.note_name, 
                   itemRequest.note_text,
                   itemRequest.patient_id,
                   today)
    try:
       cursor.execute(query, notetData) 
    except Exception as error:
        #raise HTTPException(status_code=404, detail="Failed to Create Record")
        return {"message": error}
    db.commit()
    cursor.close()
    db.close()
    return {"message": "Successfully Created Record"}

# Update Patient note on table
@router.put("/notes/update/", tags="patients_notes")
async def UpdatePatient(itemRequest : patientNoteUpdateRequest):
    today = date.today()
    db = dbConnection.dbConnect()
    cursor = db.cursor()
    query = "update patient_notes "
    query += "set note_name=%s, note_text=%s, patient_id=%s, insert_date=%s "
    query += "where idpatient_notes=%s"
    notetData = (itemRequest.note_name, 
                    itemRequest.note_text,
                    itemRequest.patient_id,
                    today,
                    itemRequest.idpatient_notes)
    try:
       cursor.execute(query, notetData) 
    except Exception as error:
        raise HTTPException(status_code=404, detail="Failed to Update Record")
        #return {"query": query, "message": error}
    db.commit()
    cursor.close()
    db.close()
    return {"message": "Successfully Updated Record"}