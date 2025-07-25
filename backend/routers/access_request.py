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

class accessUpdateRequest(BaseModel):
    business_id: str
    app_id: str
    date_time: str
    access: str

class accessExtensionRequest(BaseModel):
    business_id: str
    app_id: str
    date_time: str
    revoke_date: str

# class queueInsertRequest(BaseModel):
#     business_id: str
#     app_id: str
#     date: str
#     time: str
#     access: str

@router.get("/access-requests/{app_id}", tags=["Access Requests"])
async def read_all_access_request_by_app_id(app_id: str, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = mih_database.dbConnection.dbPatientManagerConnect()
    cursor = db.cursor()
    query = "SELECT patient_queue.idpatient_queue, patient_queue.business_id, "
    query += "patient_queue.app_id, patient_queue.date_time, patient_queue.access, patient_queue.revoke_date, "
    query += "business.Name, business.type, business.logo_path, business.contact_no "
    query += "from patient_manager.patient_queue "
    query += "inner join app_data.business "
    query += "on patient_queue.business_id = business.business_id "
    query += "where app_id = %s ORDER BY date_time DESC"
    cursor.execute(query, (app_id,))
    items = [
        {
            "idpatient_queue": item[0],
            "business_id": item[1],
            "app_id": item[2],
            "date_time": item[3],
            "access": item[4],
            "revoke_date": item[5],
            "Name": item[6],
            "type": item[7],
            "logo_path": item[8],
            "contact_no": item[9],
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items

@router.put("/access-requests/update/", tags=["Access Requests"])
async def Update_access_request_approcal(itemRequest : accessUpdateRequest): #, session: SessionContainer = Depends(verify_session())
    db = mih_database.dbConnection.dbPatientManagerConnect()
    cursor = db.cursor()
    query = "update patient_queue "
    query += "set access=%s"
    query += "where business_id=%s "
    query += "and app_id=%s "
    query += "and date_time=%s "
    userData = (itemRequest.access, 
                itemRequest.business_id,
                itemRequest.app_id,
                itemRequest.date_time)
    try:
       cursor.execute(query, userData) 
    except Exception as error:
        raise HTTPException(status_code=404, detail=error)
        #return {"query": query, "message": error}
    db.commit()
    cursor.close()
    db.close()
    return {"message": "Successfully Updated Record"}

@router.put("/access-requests/extension/", tags=["Access Requests"])
async def Update_access_request_approcal(itemRequest : accessExtensionRequest): #, session: SessionContainer = Depends(verify_session())
    db = mih_database.dbConnection.dbPatientManagerConnect()
    cursor = db.cursor()
    query = "update patient_queue "
    query += "set access=%s, revoke_date=%s"
    query += "where business_id=%s "
    query += "and app_id=%s "
    query += "and date_time=%s "
    userData = ("pending", 
                itemRequest.revoke_date,
                itemRequest.business_id,
                itemRequest.app_id,
                itemRequest.date_time)
    try:
       cursor.execute(query, userData) 
    except Exception as error:
        raise HTTPException(status_code=404, detail=error)
        #return {"query": query, "message": error}
    db.commit()
    cursor.close()
    db.close()
    return {"message": "Successfully Updated Record"}

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
