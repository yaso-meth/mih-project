from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
#from ..database import dbConnection
import database
#SuperToken Auth from front end
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.session import SessionContainer
from fastapi import Depends
import uuid

import database.dbConnection

router = APIRouter()

# class userRequest(BaseModel):
#     email: str
#     DocOfficeID: int

class businessInsertRequest(BaseModel):
    Name: str
    type: str
    registration_no: str
    logo_name: str
    logo_path: str

class businessUpdateRequest(BaseModel):
    business_id: str
    Name: str
    type: str
    registration_no: str
    logo_name: str
    logo_path: str
    

# Get List of all files
@router.get("/business/business_id/{business_id}", tags=["MIH Business"])
async def read_business_by_business_id(business_id: str, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbAppDataConnect()
    cursor = db.cursor()
    query = "SELECT business.business_id, business.Name, business.type, business.registration_no, business.logo_name, business.logo_path, business_users.app_id "
    query += "FROM business "
    query += "inner join business_users "
    query += "on business.business_id=business_users.business_id "
    query += "where business.business_id = %s"
    try:
        cursor.execute(query, (business_id,))
    except Exception as error:
        raise HTTPException(status_code=404, detail="Failed to pull records")
    items = [
        {
            "business_id": item[0],
            "Name": item[1],
            "type": item[2],
            "registration_no": item[3],
            "logo_name": item[4],
            "logo_path": item[5],
            "app_id": item[6],
        }
        for item in cursor.fetchall()
    ]
    #
    cursor.close()
    db.close()
    if(len(items)!= 0):
        return items[0]
    else:
        raise HTTPException(status_code=404, detail="No record found")


# Get List of all files
@router.get("/business/app_id/{app_id}", tags=["MIH Business"])
async def read_business_by_app_id(app_id: str, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbAppDataConnect()
    cursor = db.cursor()
    query = "SELECT business.business_id, business.Name, business.type, business.registration_no, business.logo_name, business.logo_path, business_users.app_id "
    query += "FROM business "
    query += "inner join business_users "
    query += "on business.business_id=business_users.business_id "
    query += "where business_users.app_id = %s"
    try:
        cursor.execute(query, (app_id,))
    except Exception as error:
        raise HTTPException(status_code=404, detail="Failed to pull records")
    items = [
        {
            "business_id": item[0],
            "Name": item[1],
            "type": item[2],
            "registration_no": item[3],
            "logo_name": item[4],
            "logo_path": item[5],
            "app_id": item[6],
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    if(len(items)!= 0):
        return items[0]
    else:
        raise HTTPException(status_code=404, detail="No record found")

# Insert Patient into table
@router.post("/business/insert/", tags=["MIH Business"], status_code=201)
async def insert_business_details(itemRequest : businessInsertRequest, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbAppDataConnect()
    cursor = db.cursor()
    query = "insert into business "
    query += "(business_id, Name, type, registration_no, logo_name, logo_path) "
    query += "values (%s, %s, %s, %s, %s, %s)"
    uuidString = str(uuid.uuid1())
    userData = (uuidString,
                itemRequest.Name,
                itemRequest.type,
                itemRequest.registration_no,
                itemRequest.logo_name,
                itemRequest.logo_path)
    try:
        cursor.execute(query, userData) 
    except Exception as error:
         raise HTTPException(status_code=404, detail=error)
        # return {"message": error}
    db.commit()
    cursor.close()
    db.close()
    return {"business_id": uuidString}

@router.put("/business/update/", tags=["MIH Business"])
async def Update_Business_details(itemRequest : businessUpdateRequest, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbAppDataConnect()
    cursor = db.cursor()
    query = "update business "
    query += "set Name=%s, type=%s, registration_no=%s, logo_name=%s, logo_path=%s "
    query += "where business_id=%s"
    userData = (itemRequest.Name, 
                itemRequest.type,
                itemRequest.registration_no,
                itemRequest.logo_name,
                itemRequest.logo_path,
                itemRequest.business_id)
    try:
       cursor.execute(query, userData) 
    except Exception as error:
        raise HTTPException(status_code=404, detail=error)
        #return {"query": query, "message": error}
    db.commit()
    cursor.close()
    db.close()
    return {"message": "Successfully Updated Record"}