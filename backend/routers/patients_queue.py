import mysql.connector
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
#from ..database import dbConnection
import database
from datetime import datetime, timedelta, date
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

class queueUpdateRequest(BaseModel):
    idpatient_queue: int
    date: str
    time: str

class queueDeleteRequest(BaseModel):
    idpatient_queue: int

# Get List of all files by patient
@router.get("/queue/appointments/business/{business_id}", tags=["Patients Queue"])
async def read_all_patient_queue_by_business_id(business_id: str, date: str, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbPatientManagerConnect()
    requestDate = datetime.strptime(date, '%Y-%m-%d').date()
    #print("request date: " + str(requestDate))
    cursor = db.cursor()
    query = "SELECT patient_queue.idpatient_queue, patient_queue.business_id, "
    query += "patient_queue.app_id, patient_queue.date_time, "
    query += "patients.id_no, patients.first_name, patients.last_name, patients.medical_aid_no "
    query += "from patient_manager.patient_queue "
    query += "inner join patient_manager.patients "
    query += "on patient_queue.app_id = patients.app_id "
    query = query + "where business_id = %s and date_time like '" + str(requestDate) + "%' "
    query += "ORDER BY date_time ASC"
    cursor.execute(query, (business_id,))
    items = [
        {
            "idpatient_queue": item[0],
            "business_id": item[1],
            "app_id": item[2],
            "date_time": item[3],
            "id_no": item[4],
            "first_name": item[5],
            "last_name": item[6],
            "medical_aid_no": item[7],
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items

# Get List of all files by patient
@router.get("/queue/appointments/personal/{app_id}", tags=["Patients Queue"])
async def read_all_patient_queue_by_business_id(app_id: str, date: str, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbPatientManagerConnect()
    requestDate = datetime.strptime(date, '%Y-%m-%d').date()
    cursor = db.cursor()
    query = "SELECT patient_queue.idpatient_queue, patient_queue.business_id, "
    query += "patient_queue.app_id, patient_queue.date_time, "
    query += "patients.id_no, patients.first_name, patients.last_name, patients.medical_aid_no, business.Name "
    query += "from patient_manager.patient_queue "
    query += "join patient_manager.patients "
    query += "on patient_queue.app_id = patients.app_id "
    query += "join app_data.business "
    query += "on patient_queue.business_id = business.business_id "
    query = query + "where patient_queue.app_id = %s and date_time like '" + str(requestDate) + "%' "
    query += "ORDER BY date_time ASC"
    cursor.execute(query, (app_id,))
    items = [
        {
            "idpatient_queue": item[0],
            "business_id": item[1],
            "app_id": item[2],
            "date_time": item[3],
            "id_no": item[4],
            "first_name": item[5],
            "last_name": item[6],
            "medical_aid_no": item[7],
            "business_name": item[8],
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items

# Insert Patient note into table
@router.post("/queue/appointment/insert/", tags=["Patients Queue"], status_code=201)
async def insert_Patient_Files(itemRequest : queueInsertRequest, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    date_time = itemRequest.date + " " + itemRequest.time + ":00"
    db = database.dbConnection.dbPatientManagerConnect()
    cursor = db.cursor()
    query = "insert into patient_queue "
    query += "(business_id, app_id, date_time) "
    query += "values (%s, %s, %s)"
    notetData = (itemRequest.business_id, 
                   itemRequest.app_id,
                   date_time,
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

# Update Patient on table
@router.put("/queue/appointment/update/", tags=["Patients Queue"])
async def Update_Queue(itemRequest : queueUpdateRequest, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    
    date_time = itemRequest.date + " " + itemRequest.time + ":00"

    db = database.dbConnection.dbPatientManagerConnect()
    cursor = db.cursor()
    query = "update patient_queue "
    query += "set date_time=%s "
    query += "where idpatient_queue=%s"
    patientData = (date_time, 
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

# Update Patient on table
@router.delete("/queue/appointment/delete/", tags=["Patients Queue"])
async def Delete_Queue(itemRequest : queueDeleteRequest, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbPatientManagerConnect()
    cursor = db.cursor()
    query = "delete from patient_queue "
    query += "where idpatient_queue=%s"
    try:
       cursor.execute(query, (str(itemRequest.idpatient_queue),)) 
    except Exception as error:
        print(error)
        raise HTTPException(status_code=404, detail="Failed to Delete Appointment")
        #return {"query": query, "message": error}
    db.commit()
    cursor.close()
    db.close()
    return {"message": "Successfully deleted Appointment"}
    