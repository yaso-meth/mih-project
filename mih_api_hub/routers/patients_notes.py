import mysql.connector
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from datetime import date
#from ..mih_database import dbConnection
import mih_database
#SuperToken Auth from front end
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.session import SessionContainer
from fastapi import Depends

router = APIRouter()

class noteDeleteRequest(BaseModel):
    idpatient_notes: int

class patientNoteInsertRequest(BaseModel):
    note_name: str
    note_text: str
    doc_office: str
    doctor: str
    app_id: str

class patientNoteUpdateRequest(BaseModel):
    idpatient_notes: int
    note_name: str
    note_text: str
    doc_office: str
    doctor: str
    patient_id: int

# Get List of all notes
# @router.get("/notes/patients/", tags="patients_notes")
# async def read_all_notes(session: SessionContainer = Depends(verify_session())):
#     db = mih_database.dbConnection.dbPatientManagerConnect()
#     cursor = db.cursor()
#     query = "SELECT * FROM patient_notes"
#     cursor.execute(query)
#     items = [
#         {
#             "idpatient_notes": item[0],
#             "note_name": item[1],
#             "note_text": item[2],
#             "insert_date": item[3],
#         }
#         for item in cursor.fetchall()
#     ]
#     cursor.close()
#     db.close()
#     return items

# Get List of all notes by patient
@router.get("/notes/patients/{app_id}", tags=["Patients Notes"])
async def read_all_patient_notes_by_app_id(app_id: str, session: SessionContainer = Depends(verify_session())):
    db = mih_database.dbConnection.dbPatientManagerConnect()
    cursor = db.cursor()
    query = "SELECT * FROM patient_notes where app_id = %s ORDER BY insert_date DESC"
    cursor.execute(query, (app_id,))
    items = [
        {
            "idpatient_notes": item[0],
            "note_name": item[1],
            "note_text": item[2],
            "insert_date": item[3],
            "doc_office": item[5],
            "doctor": item[6],
            "app_id": item[4]
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items

# Get List of all notes by patient
# @router.get("/notes/patients-docOffice/", tags="patients_notes")
# async def read_all_patientsby(itemRequest: noteRequest, session: SessionContainer = Depends(verify_session())):
#     db = mih_database.dbConnection.dbPatientManagerConnect()
#     cursor = db.cursor()
#     query = "select patient_notes.idpatient_notes, patient_notes.note_name, patient_notes.note_text, patient_notes.patient_id, patient_notes.insert_date, patients.doc_office_id "
#     query += "from patient_manager.patient_notes "
#     query += "inner join patient_manager.patients "
#     query += "on patient_notes.patient_id = patients.idpatients "
#     query += "where patient_notes.patient_id = %s and patients.doc_office_id = %s"
#     cursor.execute(query, (itemRequest.patientID, itemRequest.DocOfficeID,))
#     items = [
#         {
#             "idpatient_notes": item[0],
#             "note_name": item[1],
#             "note_text": item[2],
#             "insert_date": item[3],
#         }
#         for item in cursor.fetchall()
#     ]
#     cursor.close()
#     db.close()
#     return items

# Insert Patient note into table
@router.post("/notes/insert/", tags=["Patients Notes"], status_code=201)
async def insert_Patient_Note(itemRequest : patientNoteInsertRequest, session: SessionContainer = Depends(verify_session())):
    today = date.today()
    db = mih_database.dbConnection.dbPatientManagerConnect()
    cursor = db.cursor()
    query = "insert into patient_notes "
    query += "(note_name, note_text, insert_date, doc_office, doctor, app_id) "
    query += "values (%s, %s, %s, %s, %s, %s)"
    notetData = (itemRequest.note_name, 
                   itemRequest.note_text,
                   today,
                   itemRequest.doc_office,
                   itemRequest.doctor,
                   itemRequest.app_id,
                   )
    try:
       cursor.execute(query, notetData) 
    except Exception as error:
        #raise HTTPException(status_code=404, detail="Failed to Create Record")
        return {"message": error}
    db.commit()
    cursor.close()
    db.close()
    return {"message": "Successfully Created Record"}

# Delete Patient note on table
@router.delete("/notes/delete/", tags=["Patients Notes"])
async def Delete_Patient_note(itemRequest : noteDeleteRequest, session: SessionContainer = Depends(verify_session()) ): #session: SessionContainer = Depends(verify_session())
    # today = date.today()
    db = mih_database.dbConnection.dbPatientManagerConnect()
    cursor = db.cursor()
    query = "delete from patient_notes "
    query += "where idpatient_notes=%s"
    # notetData = (itemRequest.idpatient_notes)
    try:
       cursor.execute(query, (str(itemRequest.idpatient_notes),)) 
    except Exception as error:
        raise HTTPException(status_code=404, detail="Failed to Delete Record")
        #return {"query": query, "message": error}
    db.commit()
    cursor.close()
    db.close()
    return {"message": "Successfully deleted Record"}

# Update Patient note on table
# @router.put("/notes/update/", tags="patients_notes")
# async def UpdatePatient(itemRequest : patientNoteUpdateRequest, session: SessionContainer = Depends(verify_session())):
#     today = date.today()
#     db = mih_database.dbConnection.dbPatientManagerConnect()
#     cursor = db.cursor()
#     query = "update patient_notes "
#     query += "set note_name=%s, note_text=%s, patient_id=%s, insert_date=%s "
#     query += "where idpatient_notes=%s"
#     notetData = (itemRequest.note_name, 
#                     itemRequest.note_text,
#                     itemRequest.patient_id,
#                     today,
#                     itemRequest.idpatient_notes)
#     try:
#        cursor.execute(query, notetData) 
#     except Exception as error:
#         raise HTTPException(status_code=404, detail="Failed to Update Record")
#         #return {"query": query, "message": error}
#     db.commit()
#     cursor.close()
#     db.close()
#     return {"message": "Successfully Updated Record"}