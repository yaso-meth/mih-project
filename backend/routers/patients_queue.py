import mysql.connector
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
#from ..database import dbConnection
import database
from datetime import datetime, timedelta
#SuperToken Auth from front end
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.session import SessionContainer
from fastapi import Depends

router = APIRouter()

class fileDeleteRequest(BaseModel):
    idpatient_files: int

class queueInsertRequest(BaseModel):
    business_id: str
    app_id: str
    date: str
    time: str
    access: str

class queueUpdateRequest(BaseModel):
    idpatient_queue: int
    date: str
    time: str

# # Get List of all files
# @router.get("/files/patients/", tags="patients_files")
# async def read_all_files(session: SessionContainer = Depends(verify_session())):
#     db = database.dbConnection.dbPatientManagerConnect()
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
@router.get("/queue/patients/{business_id}", tags=["Patients Queue"])
async def read_all_patient_queue_by_business_id(business_id: str, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbPatientManagerConnect()
    cursor = db.cursor()
    query = "SELECT patient_queue.idpatient_queue, patient_queue.business_id, "
    query += "patient_queue.app_id, patient_queue.date_time, patient_queue.access, "
    query += "patients.id_no, patients.first_name, patients.last_name, patients.medical_aid_no, patient_queue.revoke_date "
    query += "from patient_manager.patient_queue "
    query += "inner join patient_manager.patients "
    query += "on patient_queue.app_id = patients.app_id "
    query += "where business_id = %s ORDER BY date_time ASC"
    cursor.execute(query, (business_id,))
    items = [
        {
            "idpatient_queue": item[0],
            "business_id": item[1],
            "app_id": item[2],
            "date_time": item[3],
            "access": item[4],
            "id_no": item[5],
            "first_name": item[6],
            "last_name": item[7],
            "medical_aid_no": item[8],
            "revoke_date": item[9],
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items

# # Get List of all files by patient & DocOffice
# @router.get("/files/patients-docOffice/", tags="patients_files")
# async def read_all_files_by_patient(itemRequest: fileRequest, session: SessionContainer = Depends(verify_session())):
#     db = database.dbConnection.dbPatientManagerConnect()
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
# @router.delete("/files/delete/", tags=["Patients Files"])
# async def Delete_Patient_File(itemRequest : fileDeleteRequest, session: SessionContainer = Depends(verify_session())): #session: SessionContainer = Depends(verify_session())
#     # today = date.today()
#     db = database.dbConnection.dbPatientManagerConnect()
#     cursor = db.cursor()
#     query = "delete from patient_files "
#     query += "where idpatient_files=%s"
#     # notetData = (itemRequest.idpatient_notes)
#     try:
#        cursor.execute(query, (str(itemRequest.idpatient_files),)) 
#     except Exception as error:
#         raise HTTPException(status_code=404, detail="Failed to Delete Record")
#         #return {"query": query, "message": error}
#     db.commit()
#     cursor.close()
#     db.close()
#     return {"message": "Successfully deleted Record"}

# Insert Patient note into table
@router.post("/queue/insert/", tags=["Patients Queue"], status_code=201)
async def insert_Patient_Files(itemRequest : queueInsertRequest, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    date_time = itemRequest.date + " " + itemRequest.time + ":00"
    year = itemRequest.date[0:4]
    month = itemRequest.date[5:7]
    day = itemRequest.date[8:10]
    hour = itemRequest.time[0:2]
    minutes = itemRequest.time[3:5]

    revDate = datetime(int(year), int(month), int(day), int(hour),int( minutes))
    newRevDate = revDate + timedelta(days=7)
    db = database.dbConnection.dbPatientManagerConnect()
    cursor = db.cursor()
    query = "insert into patient_queue "
    query += "(business_id, app_id, date_time, access, revoke_date) "
    query += "values (%s, %s, %s, %s, %s)"
    notetData = (itemRequest.business_id, 
                   itemRequest.app_id,
                   date_time,
                   itemRequest.access,
                   newRevDate)
    try:
       cursor.execute(query, notetData) 
    except Exception as error:
        #raise HTTPException(status_code=404, detail="Failed to Create Record")
        return {"message": error}
    db.commit()
    cursor.close()
    db.close()
    return {"message": "Successfully Created file Record"}

# Update Patient on table
@router.put("/queue/update/", tags=["Patients Queue"])
async def Update_Queue(itemRequest : queueUpdateRequest): #, session: SessionContainer = Depends(verify_session())
    
    date_time = itemRequest.date + " " + itemRequest.time + ":00"
    year = itemRequest.date[0:4]
    month = itemRequest.date[5:7]
    day = itemRequest.date[8:10]
    hour = itemRequest.time[0:2]
    minutes = itemRequest.time[3:5]

    revDate = datetime(int(year), int(month), int(day), int(hour),int( minutes))
    newRevDate = revDate + timedelta(days=7)
    db = database.dbConnection.dbPatientManagerConnect()
    cursor = db.cursor()
    query = "update patient_queue "
    query += "set date_time=%s, revoke_date=%s, access='pending' "
    query += "where idpatient_queue=%s"
    patientData = (date_time, 
                   newRevDate,
                   itemRequest.idpatient_queue)
    try:
       cursor.execute(query, patientData) 
    except Exception as error:
        print(error)
        raise HTTPException(status_code=404, detail="Failed to Update Record")
        #return {"query": query, "message": error}
    db.commit()
    cursor.close()
    db.close()
    return {"message": "Successfully Updated Record"}