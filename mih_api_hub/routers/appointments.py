import mysql.connector
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
#from ..mih_database import dbConnection
import mih_database
from datetime import datetime, timedelta, date
#SuperToken Auth from front end
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.session import SessionContainer
from fastapi import Depends

router = APIRouter()

class appointmentInsertRequest(BaseModel):
    app_id: str
    business_id: str
    title: str
    description: str
    date: str
    time: str

class appointmentUpdateRequest(BaseModel):
    idappointments: int
    title: str
    description: str
    date: str
    time: str

class appointmentDeleteRequest(BaseModel):
    idappointments: int

# Get List of all files by patient
@router.get("/appointments/business/{business_id}", tags=["Appointments"])
async def read_all_appointments_by_business_id(business_id: str, date: str, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = mih_database.dbConnection.dbMzansiCalendarConnect()
    requestDate = datetime.strptime(date, '%Y-%m-%d').date()
    cursor = db.cursor()
    query = "SELECT appointments.idappointments, appointments.app_id, "
    query += "appointments.business_id, appointments.date_time, "
    query += "appointments.title, appointments.description "
    query += "from mzansi_calendar.appointments "
    query = query + "where appointments.business_id = %s and date_time like '" + str(requestDate) + "%' "
    query += "ORDER BY date_time ASC"
    cursor.execute(query, (business_id,))
    items = [
        {
            "idappointments": item[0],
            "app_id": item[1],
            "business_id": item[2],
            "date_time": item[3],
            "title": item[4],
            "description": item[5],
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items

# Get List of all files by patient
@router.get("/appointments/personal/{app_id}", tags=["Appointments"])
async def read_all_appointments_by_business_id(app_id: str, date: str, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = mih_database.dbConnection.dbMzansiCalendarConnect()
    requestDate = datetime.strptime(date, '%Y-%m-%d').date()
    cursor = db.cursor()
    query = "SELECT appointments.idappointments, appointments.app_id, "
    query += "appointments.business_id, appointments.date_time, "
    query += "appointments.title, appointments.description "
    query += "from mzansi_calendar.appointments "
    query = query + "where appointments.app_id = %s and date_time like '" + str(requestDate) + "%' "
    query += "ORDER BY date_time ASC"
   
    cursor.execute(query, (app_id,))
    items = [
        {
            "idappointments": item[0],
            "app_id": item[1],
            "business_id": item[2],
            "date_time": item[3],
            "title": item[4],
            "description": item[5],
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items

# Insert Patient note into table
@router.post("/appointment/insert/", tags=["Appointments"], status_code=201)
async def insert_appointment(itemRequest : appointmentInsertRequest, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    date_time = itemRequest.date + " " + itemRequest.time + ":00"
    db = mih_database.dbConnection.dbMzansiCalendarConnect()
    cursor = db.cursor()
    query = "insert into appointments "
    query += "(app_id, business_id, title, description, date_time) "
    query += "values (%s, %s, %s, %s, %s)"
    notetData = (itemRequest.app_id,
                 itemRequest.business_id,
                 itemRequest.title,
                 itemRequest.description,
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
@router.put("/appointment/update/", tags=["Appointments"])
async def Update_appointment(itemRequest : appointmentUpdateRequest, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    
    date_time = itemRequest.date + " " + itemRequest.time + ":00"

    db = mih_database.dbConnection.dbMzansiCalendarConnect()
    cursor = db.cursor()
    query = "update appointments "
    query += "set date_time=%s, title=%s, description=%s "
    query += "where idappointments=%s"
    patientData = (date_time, 
                   itemRequest.title,
                   itemRequest.description,
                   itemRequest.idappointments)
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
@router.delete("/appointment/delete/", tags=["Appointments"])
async def Delete_appointment(itemRequest : appointmentDeleteRequest, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = mih_database.dbConnection.dbMzansiCalendarConnect()
    cursor = db.cursor()
    query = "delete from appointments "
    query += "where idappointments=%s"
    try:
       cursor.execute(query, (str(itemRequest.idappointments),)) 
    except Exception as error:
        print(error)
        raise HTTPException(status_code=404, detail="Failed to Delete Appointment")
        #return {"query": query, "message": error}
    db.commit()
    cursor.close()
    db.close()
    return {"message": "Successfully deleted Appointment"}
    