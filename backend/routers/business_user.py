from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
#from ..database import dbConnection
import database
#SuperToken Auth from front end
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.session import SessionContainer
from fastapi import Depends

import database.dbConnection

router = APIRouter()

# class userRequest(BaseModel):
#     email: str
#     DocOfficeID: int

class businessUserInsertRequest(BaseModel):
    business_id: str
    app_id: str
    signature: str
    title: str
    access: str

class BusinessUserUpdateRequest(BaseModel):
    business_id: str
    app_id: str
    signature: str
    title: str
    access: str
    

# Get List of all files
@router.get("/business-user/{app_id}", tags=["MIH Business_User"])
async def read_business_users_by_app_id(app_id: str, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbAppDataConnect()
    cursor = db.cursor()
    query = "SELECT * FROM business_users where app_id = %s"
    try:
        cursor.execute(query, (app_id,))
    except Exception as error:
        raise HTTPException(status_code=404, detail="Failed - " + error)
    items = [
        {
            "idbusiness_users": item[0],
            "business_id": item[1],
            "app_id": item[2],
            "signature": item[3],
            "title": item[4],
            "access": item[5],
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
@router.post("/business-user/insert/", tags=["MIH Business_User"], status_code=201)
async def insert_User_details(itemRequest : businessUserInsertRequest, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbAppDataConnect()
    cursor = db.cursor()
    query = "insert into business_users "
    query += "(business_id, app_id, signature, title, access) "
    query += "values (%s, %s, %s, %s, %s)"
    userData = (itemRequest.business_id,
                itemRequest.app_id,
                itemRequest.signature,
                itemRequest.title,
                itemRequest.access)
    try:
       cursor.execute(query, userData) 
    except Exception as error:
        raise HTTPException(status_code=404, detail="Failed to Create Record")
        #return {"message": "Failed to Create Record"}
    db.commit()
    cursor.close()
    db.close()
    return {"message": "Successfully Created Record"}

# Update User on table
@router.put("/business-user/update/", tags=["MIH Business_User"])
async def Update_User_details(itemRequest : BusinessUserUpdateRequest, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbAppDataConnect()
    cursor = db.cursor()
    query = "update business_users "
    query += "set signature=%s, title=%s, access=%s"
    query += "where app_id=%s and business_id=%s"
    userData = (itemRequest.signature, 
                itemRequest.title,
                itemRequest.access,
                itemRequest.app_id,
                itemRequest.business_id,
                )
    try:
       cursor.execute(query, userData) 
    except Exception as error:
        raise HTTPException(status_code=404, detail=error)
        #return {"query": query, "message": error}
    db.commit()
    cursor.close()
    db.close()
    return {"message": "Successfully Updated Record"}