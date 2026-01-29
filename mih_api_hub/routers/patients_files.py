import mysql.connector
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
#from ..mih_database import dbConnection
import mih_database
from datetime import date
#SuperToken Auth from front end
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.session import SessionContainer
from fastapi import Depends

router = APIRouter()

class fileDeleteRequest(BaseModel):
    idpatient_files: int

class fileInsertRequest(BaseModel):
    file_path: str
    file_name: str
    app_id: str

# # Get List of all files
# @router.get("/files/patients/", tags="patients_files")
# async def read_all_files(session: SessionContainer = Depends(verify_session())):
#     db = mih_database.dbConnection.dbPatientManagerConnect()
#     cursor = db.cursor()
#     query = "SELECT * FROM patient_files"
#     cursor.execute(query)
#     items = [
#         {
#             "idpatient_files": item[0],
#             "file_path": item[1],
#             "file_name": item[2],
#             "patient_id": item[3],
#             "insert_date": item[4],
#         }
#         for item in cursor.fetchall()
#     ]
#     cursor.close()
#     db.close()
#     return items

# Get List of all files by patient
@router.get("/patient_files/get/{app_id}", tags=["Patients Files"])
async def read_all_patient_files_by_app_id(app_id: str, session: SessionContainer = Depends(verify_session())):
    db = mih_database.dbConnection.dbPatientManagerConnect()
    cursor = db.cursor()
    query = "SELECT * FROM patient_files where app_id = %s ORDER BY insert_date DESC"
    cursor.execute(query, (app_id,))
    items = [
        {
            "idpatient_files": item[0],
            "file_path": item[1],
            "file_name": item[2],
            "insert_date": item[3],
            "app_id": item[4],
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items

# # Get List of all files by patient & DocOffice
# @router.get("/files/patients-docOffice/", tags="patients_files")
# async def read_all_files_by_patient(itemRequest: fileRequest, session: SessionContainer = Depends(verify_session())):
#     db = mih_database.dbConnection.dbPatientManagerConnect()
#     cursor = db.cursor()
#     query = "select patient_files.idpatient_files, patient_files.file_path, patient_files.file_name, patient_files.patient_id, patient_files.insert_date, patients.doc_office_id "
#     query += "from patient_manager.patient_files "
#     query += "inner join patient_manager.patients "
#     query += "on patient_files.patient_id = patients.idpatients "
#     query += "where patient_files.patient_id = %s and patients.doc_office_id = %s"
#     cursor.execute(query, (itemRequest.patientID, itemRequest.DocOfficeID,))
    
#     items = [
#         {
#             "idpatient_files": item[0],
#             "file_path": item[1],
#             "file_name": item[2],
#             "patient_id": item[3],
#             "insert_date": item[4],
#             "doc_office_id": item[5]
#         }
#         for item in cursor.fetchall()
#     ]
#     cursor.close()
#     db.close()
#     return items

# Delete Patient note on table
@router.delete("/patient_files/delete/", tags=["Patients Files"])
async def Delete_Patient_File(itemRequest : fileDeleteRequest, session: SessionContainer = Depends(verify_session())): #session: SessionContainer = Depends(verify_session())
    # today = date.today()
    db = mih_database.dbConnection.dbPatientManagerConnect()
    cursor = db.cursor()
    query = "delete from patient_files "
    query += "where idpatient_files=%s"
    # notetData = (itemRequest.idpatient_notes)
    try:
       cursor.execute(query, (str(itemRequest.idpatient_files),)) 
    except Exception as error:
        raise HTTPException(status_code=404, detail="Failed to Delete Record")
        #return {"query": query, "message": error}
    db.commit()
    cursor.close()
    db.close()
    return {"message": "Successfully deleted Record"}

# Insert Patient note into table
@router.post("/patient_files/insert/", tags=["Patients Files"], status_code=201)
async def insert_Patient_Files(itemRequest : fileInsertRequest, session: SessionContainer = Depends(verify_session())):
    today = date.today()
    db = mih_database.dbConnection.dbPatientManagerConnect()
    cursor = db.cursor()
    query = "insert into patient_files "
    query += "(file_path, file_name, insert_date, app_id) "
    query += "values (%s, %s, %s, %s)"
    notetData = (itemRequest.file_path, 
                   itemRequest.file_name,
                   today,
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
    return {"message": "Successfully Created file Record"}
