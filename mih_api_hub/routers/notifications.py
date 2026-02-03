import mysql.connector
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from datetime import datetime, timedelta
#from ..mih_database import dbConnection
import mih_database
#SuperToken Auth from front end
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.session import SessionContainer
from fastapi import Depends

router = APIRouter()

class notificationsGetNuberedRequest(BaseModel):
    notification_count: str
    app_id: str

class notificationInsertRequest(BaseModel):
    app_id: str
    notification_type: str
    notification_message: str
    action_path: str

# class patientUpdateRequest(BaseModel):
#     id_no: str
#     app_id: str
#     last_name: str
#     email: str
#     cell_no: str
#     medical_aid: str
#     medical_aid_main_member: str
#     medical_aid_no: str
#     medical_aid_code: str
#     medical_aid_name: str
#     medical_aid_scheme: str
#     address: str
#     app_id: str

# class patientDeleteRequest(BaseModel):
#     app_id: str


# Get Notifications By app ID
@router.get("/notifications/{app_id}", tags=["Notifications"])
async def read_notifications_By_app_ID(app_id: str, amount: int, session: SessionContainer = Depends(verify_session())): # , session: SessionContainer = Depends(verify_session())
    db = mih_database.dbConnection.dbAppDataConnect()
    cursor = db.cursor()
    #query = "SELECT * FROM patients"
    query = "Select * from notifications " 
    query += "where app_id = '%s' " % app_id
    query += "order by insert_date desc "
    query += "limit %s" % amount
    # return {"query": query}
    cursor.execute(query)
    items = [
        {
            "idnotifications": item[0],
            "app_id": item[1],
            "notification_message": item[2],
            "notification_read": item[3],
            "action_path": item[4],
            "insert_date": item[5],
            "notification_type": item[6],
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items


# Insert Patient into table
@router.post("/notifications/insert/", tags=["Notifications"], status_code=201)
async def insert_Patient(itemRequest : notificationInsertRequest, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = mih_database.dbConnection.dbAppDataConnect()
    now = datetime.now() + timedelta(hours=2)
    notificationDateTime = now.strftime("%Y-%m-%d %H:%M:%S")
    print(notificationDateTime)
    readType = "No"
    cursor = db.cursor()
    query = "insert into notifications "
    query += "(app_id, notification_message, notification_read, action_path, insert_date, notification_type) "
    query += "values (%s, %s, %s, %s, %s, %s)"
    patientData = (
                   itemRequest.app_id,
                   itemRequest.notification_message,
                   readType,
                   itemRequest.action_path,
                   notificationDateTime,
                   itemRequest.notification_type
                   )
    try:
       cursor.execute(query, patientData) 
    except Exception as error:
        print(error)
        raise HTTPException(status_code=404, detail="Failed to Create Record")
        # return {"message": error}
    db.commit()
    cursor.close()
    db.close()
    return {"message": "Successfully Created Record"}

# Update Patient on table
@router.put("/notifications/update/{notification_id}", tags=["Notifications"])
async def Update_Patient(notification_id : str, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = mih_database.dbConnection.dbAppDataConnect()
    cursor = db.cursor()
    query = "update notifications "
    query += "set notification_read=%s "
    query += "where idnotifications=%s"
    patientData = ("Yes", 
                   notification_id,
                   )
    try:
       cursor.execute(query, patientData) 
    except Exception as error:
        raise HTTPException(status_code=404, detail="Failed to Update Record")
        #return {"query": query, "message": error}
    db.commit()
    cursor.close()
    db.close()
    return {"message": "Successfully Updated Record"}

# # delete Patient on table
# @router.delete("/patients/delete/", tags=["Patients"])
# async def Delete_Patient(itemRequest : patientDeleteRequest, session: SessionContainer = Depends(verify_session())):
#     db = mih_database.dbConnection.dbPatientManagerConnect()
#     cursor = db.cursor()
#     query = "delete from patients "
#     query += "where app_id=%s"
#     patientData = (itemRequest.app_id,
#                    )
#     try:
#        cursor.execute(query, patientData) 
#     except Exception as error:
#         raise HTTPException(status_code=404, detail="Failed to delete Record")
#         #return {"query": query, "message": error}
#     db.commit()
#     cursor.close()
#     db.close()
#     return {"message": "Successfully delete Record"}