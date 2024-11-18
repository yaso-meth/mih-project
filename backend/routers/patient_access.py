import mysql.connector
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
#from ..database import dbConnection
import database
from datetime import date, datetime, timedelta
#SuperToken Auth from front end
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.session import SessionContainer
from fastapi import Depends

router = APIRouter()

class accessRequestInsertRequest(BaseModel):
    business_id: str
    app_id: str
    type: str
    requested_by: str

class accessRequestUpdateRequest(BaseModel):
    business_id: str
    app_id: str
    status: str
    approved_by: str

class accessRequestReapplyRequest(BaseModel):
    business_id: str
    app_id: str

@router.get("/access-requests/{access_type}/check/{business_id}", tags=["Patient Access"])
async def check_business_id_has_access(access_type: str,business_id: str, app_id: str, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbPatientManagerConnect()
    cursor = db.cursor()
    query = "select "
    query += "patient_business_access.business_id, business.Name, "
    query += "patient_business_access.app_id, users.fname, users.lname, "
    query += "patients.id_no, "
    query += "patient_business_access.type, patient_business_access.status, "
    query += "patient_business_access.approved_by, patient_business_access.approved_on, "
    query += "patient_business_access.requested_by, patient_business_access.requested_on "
    query += "from data_access.patient_business_access "
    query += "join app_data.business "
    query += "on patient_business_access.business_id = business.business_id "
    query += "join app_data.users "
    query += "on patient_business_access.app_id = users.app_id "
    query += "join patient_manager.patients "
    query += "on patient_business_access.app_id = patients.app_id "
    query += "where patient_business_access.type=%s and patient_business_access.business_id=%s and patient_business_access.app_id=%s"
    cursor.execute(query, (access_type,
                           business_id,
                           app_id,
                           ))
    items = [
        {
            "business_id": item[0],
            "business_name": item[1],
            "app_id": item[2],
            "fname": item[3],
            "lname": item[4],
            "id_no": item[5],
            "type": item[6],
            "status": item[7],
            "approved_by": item[8],
            "approved_on": item[9],
            "requested_by": item[10],
            "requested_on": item[11],
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items

@router.get("/access-requests/business/{access_type}/{business_id}", tags=["Patient Access"])
async def read_all_patient_access_by_business_id(access_type: str,business_id: str, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbPatientManagerConnect()
    cursor = db.cursor()
    query = "select "
    query += "patient_business_access.business_id, business.Name, "
    query += "patient_business_access.app_id, users.fname, users.lname, "
    query += "patients.id_no, "
    query += "patient_business_access.type, patient_business_access.status, "
    query += "patient_business_access.approved_by, patient_business_access.approved_on, "
    query += "patient_business_access.requested_by, patient_business_access.requested_on "
    query += "from data_access.patient_business_access "
    query += "join app_data.business "
    query += "on patient_business_access.business_id = business.business_id "
    query += "join app_data.users "
    query += "on patient_business_access.app_id = users.app_id "
    query += "join patient_manager.patients "
    query += "on patient_business_access.app_id = patients.app_id "
    query += "where patient_business_access.type=%s and patient_business_access.business_id=%s"
    cursor.execute(query, (access_type,
                           business_id,))
    items = [
        {
            "business_id": item[0],
            "business_name": item[1],
            "app_id": item[2],
            "fname": item[3],
            "lname": item[4],
            "id_no": item[5],
            "type": item[6],
            "status": item[7],
            "approved_by": item[8],
            "approved_on": item[9],
            "requested_by": item[10],
            "requested_on": item[11],
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items

@router.get("/access-requests/personal/{access_type}/{app_id}", tags=["Patient Access"])
async def read_all_patient_access_by_app_id(access_type: str,app_id: str, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbPatientManagerConnect()
    cursor = db.cursor()
    query = "select "
    query += "patient_business_access.business_id, business.Name, "
    query += "patient_business_access.app_id, users.fname, users.lname, "
    query += "patients.id_no, "
    query += "patient_business_access.type, patient_business_access.status, "
    query += "patient_business_access.approved_by, patient_business_access.approved_on, "
    query += "patient_business_access.requested_by, patient_business_access.requested_on "
    query += "from data_access.patient_business_access "
    query += "join app_data.business "
    query += "on patient_business_access.business_id = business.business_id "
    query += "join app_data.users "
    query += "on patient_business_access.app_id = users.app_id "
    query += "join patient_manager.patients "
    query += "on patient_business_access.app_id = patients.app_id "
    query += "where patient_business_access.type=%s and patient_business_access.app_id=%s"
    cursor.execute(query, (access_type,
                           app_id,))
    items = [
        {
            "business_id": item[0],
            "business_name": item[1],
            "app_id": item[2],
            "fname": item[3],
            "lname": item[4],
            "id_no": item[5],
            "type": item[6],
            "status": item[7],
            "approved_by": item[8],
            "approved_on": item[9],
            "requested_by": item[10],
            "requested_on": item[11],
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items

# Insert Patient into table
@router.post("/access-requests/insert/", tags=["Patient Access"], status_code=201)
async def insert_Patient_access(itemRequest : accessRequestInsertRequest, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbDataAccessConnect()
    now = datetime.now() + timedelta(hours=2)
    notificationDateTime = now.strftime("%Y-%m-%d %H:%M:%S")
    print(notificationDateTime)
    cursor = db.cursor()
    query = "insert into patient_business_access "
    query += "(business_id, app_id, type, status, approved_by, approved_on, requested_by, requested_on) "
    query += "values (%s, %s, %s, %s, %s, %s, %s, %s)"
    patientData = (
                   itemRequest.business_id,
                   itemRequest.app_id,
                   itemRequest.type,
                   "pending",
                   "",
                   "9999-01-01 00:00:00",
                   itemRequest.requested_by,
                   now,
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
@router.put("/access-requests/update/permission/", tags=["Patient Access"])
async def Update_Patient_access(itemRequest: accessRequestUpdateRequest): #, session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbDataAccessConnect()
    now = datetime.now() + timedelta(hours=2)
    notificationDateTime = now.strftime("%Y-%m-%d %H:%M:%S")
    print(notificationDateTime)
    cursor = db.cursor()
    query = "update patient_business_access "
    query += "set status=%s, approved_by=%s, approved_on=%s "
    query += "where business_id=%s and app_id=%s"
    patientData = (itemRequest.status, 
                   itemRequest.approved_by,
                   now,
                   itemRequest.business_id,
                   itemRequest.app_id,
                   )
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

# Reapply Patient on table
@router.put("/access-requests/re-apply/", tags=["Patient Access"])
async def Reapply_Patient_access(itemRequest: accessRequestReapplyRequest): #, session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbDataAccessConnect()
    now = datetime.now() + timedelta(hours=2)
    notificationDateTime = now.strftime("%Y-%m-%d %H:%M:%S")
    print(notificationDateTime)
    cursor = db.cursor()
    query = "update patient_business_access "
    query += "set status='pending', approved_by='', approved_on='9999-01-01 00:00:00', requested_on=%s "
    query += "where business_id=%s and app_id=%s"
    patientData = (now,
                   itemRequest.business_id,
                   itemRequest.app_id,
                   )
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