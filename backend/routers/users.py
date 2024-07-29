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

class userRequest(BaseModel):
    email: str
    DocOfficeID: int

class userInsertRequest(BaseModel):
    email: str
    app_id: str

class userUpdateRequest(BaseModel):
    idusers: int
    username: str
    fnam: str
    lname: str
    
# #get user by email & doc Office ID
# @router.get("/users/profile/{email}", tags="users")
# async def read_all_users(email: str, session: SessionContainer = Depends(verify_session())):
#     db = database.dbConnection.dbAppDataConnect()
#     cursor = db.cursor()
#     query = "SELECT * FROM users where email = %s"
#     cursor.execute(query, (email.lower(),)) 
#     items = [
#         {"idusers": item[0],
#         "email": item[1],
#         "docOffice_id": item[2],
#         "fname":item[3],
#         "lname":item[4],
#         "type": item[5],
#         "app_id": item[6],
#         "username": item[7],
#         }
#         for item in cursor.fetchall()
#     ]#
#     cursor.close()
#     db.close()
#     return items[0]
    

# # Get List of all files
# @router.get("/users/", tags="users")
# async def read_all_users(session: SessionContainer = Depends(verify_session())):
#     db = database.dbConnection.dbAppDataConnect()
#     cursor = db.cursor()
#     query = "SELECT * FROM users"
#     cursor.execute(query)
#     items = [
#         {
#             "idUser": item[0],
#             "email": item[1],
#             "docOffice_id": item[2],
#             "fname": item[3],
#             "lname": item[4],
#             "type": item[5],
#             "app_id": item[6],
#             "username": item[7],
#         }
#         for item in cursor.fetchall()
#     ]
#     cursor.close()
#     db.close()
#     return items

# Get List of all files
@router.get("/user/{app_id}", tags=["MIH Users"])
async def read_users_by_app_id(app_id: str, session: SessionContainer = Depends(verify_session())):
    db = database.dbConnection.dbAppDataConnect()
    cursor = db.cursor()
    query = "SELECT * FROM users where app_id = %s"
    cursor.execute(query, (app_id,))
    items = [
        {
            "idUser": item[0],
            "email": item[1],
            "fname": item[2],
            "lname": item[3],
            "type": item[4],
            "app_id": item[5],
            "username": item[6],
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items[0]

# Insert Patient into table
@router.post("/user/insert/", tags=["MIH Users"], status_code=201)
async def insert_User_details(itemRequest : userInsertRequest, session: SessionContainer = Depends(verify_session())):
    db = database.dbConnection.dbAppDataConnect()
    cursor = db.cursor()
    query = "insert into users "
    query += "(email, fname, lname, type, app_id, username) "
    query += "values (%s, %s, %s, %s, %s, %s)"
    userData = (itemRequest.email,"","","personal",
                   itemRequest.app_id, "")
    try:
       cursor.execute(query, userData) 
    except Exception as error:
        raise HTTPException(status_code=404, detail="Failed to Create Record - " + error)
        #return {"message": "Failed to Create Record"}
    db.commit()
    cursor.close()
    db.close()
    return {"message": "Successfully Created Record"}

# Update User on table
@router.put("/user/update/", tags=["MIH Users"])
async def Update_User_details(itemRequest : userUpdateRequest, session: SessionContainer = Depends(verify_session())):
    db = database.dbConnection.dbAppDataConnect()
    cursor = db.cursor()
    query = "update users "
    query += "set username=%s, fname=%s, lname=%s "
    query += "where idusers=%s"
    userData = (itemRequest.username, 
                   itemRequest.fnam,
                   itemRequest.lname,
                   itemRequest.idusers,
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