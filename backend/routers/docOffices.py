import mysql.connector
from fastapi import APIRouter, HTTPException
#from ..database import dbConnection
import database
#SuperToken Auth from front end
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.session import SessionContainer
from fastapi import Depends

import database.dbConnection

router = APIRouter()

# Get Doctors Office By ID
@router.get("/docOffices/{docOffic_id}", tags=["Doctor Office"])
async def read_docOffice_By_ID(docOffic_id: int, session: SessionContainer = Depends(verify_session())):
    db = database.dbConnection.dbConnect()
    cursor = db.cursor()
    query = "SELECT * FROM doctor_offices WHERE iddoctor_offices=%s"
    cursor.execute(query, (docOffic_id,))
    item = cursor.fetchone()
    cursor.close()
    db.close()
    if item is None:
        raise HTTPException(status_code=404, detail="Item not found")
    return {"iddoctor_offices": item[0],
            "office_name": item[1]}

# Get Doctors Office By user
@router.get("/docOffices/user/{user}", tags=["Doctor Office"])
async def read_docOffice_By_ID(user: str, session: SessionContainer = Depends(verify_session())):
    db = database.dbConnection.dbConnect()
    cursor = db.cursor()
    query = "SELECT * FROM users WHERE email=%s"
    cursor.execute(query, (user,))
    item = cursor.fetchone()
    cursor.close()
    db.close()
    if item is None:
        raise HTTPException(status_code=404, detail="Item not found")
    return {
         "idUser": item[0],
            "UserName": item[1],
            "docOffice_id": item[2],
            "fname": item[3],
            "lname": item[4],
            "title": item[5],
        }

# Get List of all Doctors Office
@router.get("/docOffices/", tags=["Doctor Office"])
async def read_All_Doctors_Office(session: SessionContainer = Depends(verify_session())):
    db = database.dbConnection.dbConnect()
    cursor = db.cursor()
    query = "SELECT * FROM doctor_offices"
    cursor.execute(query)
    items = [
        {
            "iddoctor_offices": item[0],
            "office_name": item[1]
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items
