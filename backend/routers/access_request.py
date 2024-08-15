import mysql.connector
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
#from ..database import dbConnection
import database
from datetime import date
#SuperToken Auth from front end
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.session import SessionContainer
from fastapi import Depends

router = APIRouter()

# class fileDeleteRequest(BaseModel):
#     idpatient_files: int

# class queueInsertRequest(BaseModel):
#     business_id: str
#     app_id: str
#     date: str
#     time: str
#     access: str

@router.get("/access/requests/{app_id}", tags=["Access Requests"])
async def read_all_access_request_by_app_id(app_id: str): #, session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbPatientManagerConnect()
    cursor = db.cursor()
    query = "SELECT patient_queue.idpatient_queue, patient_queue.business_id, "
    query += "patient_queue.app_id, patient_queue.date_time, patient_queue.access, "
    query += "business.Name, business.type, business.logo_path "
    query += "from patient_manager.patient_queue "
    query += "inner join app_data.business "
    query += "on patient_queue.business_id = business.business_id "
    query += "where app_id = %s ORDER BY date_time ASC"
    cursor.execute(query, (app_id,))
    items = [
        {
            "idpatient_queue": item[0],
            "business_id": item[1],
            "app_id": item[2],
            "date_time": item[3],
            "access": item[4],
            "Name": item[5],
            "type": item[6],
            "logo_path": item[7],
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items

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
