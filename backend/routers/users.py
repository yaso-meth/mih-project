from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
#from ..database import dbConnection
import database
#SuperToken Auth from front end
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.session import SessionContainer
from supertokens_python.syncio import delete_user

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
    type: str
    pro_pic_path: str
    
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
    

# Get List of all files
@router.get("/users/search/{search}", tags=["MIH Users"])
async def read_all_users(search: str, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbAppDataConnect()
    cursor = db.cursor()
    query = "SELECT * FROM users WHERE LOWER(email) LIKE %s OR LOWER(username) LIKE %s"
    search_term = f"%{search.lower()}%"  # Add wildcards and lowercase
    cursor.execute(query, (search_term, search_term))
    # query = "SELECT * FROM users "
    # query += "where email like lower('%%%s%%') " % search
    # query += "or username like lower('%%%s%%')" % search
    # cursor.execute(query)
    items = [
        {
            "idUser": item[0],
            "email": item[1],
            "fname": item[2],
            "lname": item[3],
            "type": item[4],
            "app_id": item[5],
            "username": item[6],
            "pro_pic_path": item[7],
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items

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
            "pro_pic_path": item[7],
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
    query += "(email, fname, lname, type, app_id, username, pro_pic_path) "
    query += "values (%s, %s, %s, %s, %s, %s, %s)"
    userData = (itemRequest.email,"","","personal",
                   itemRequest.app_id, "", "")
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
    query += "set username=%s, fname=%s, lname=%s, type=%s, pro_pic_path=%s "
    query += "where idusers=%s"
    userData = (itemRequest.username, 
                   itemRequest.fnam,
                   itemRequest.lname,
                   itemRequest.type,
                   itemRequest.pro_pic_path,
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

# Get List of all files
@router.delete("/user/delete/all/{app_id}", tags=["MIH Users"])
async def delete_users_data_by_app_id(app_id: str, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbAllConnect()
    cursor = db.cursor()
    db.start_transaction()
    try:
        queries = [
            "DELETE FROM app_data.notifications where app_id = %s",
            "DELETE FROM app_data.business_users where app_id = %s",
            "DELETE FROM data_access.patient_business_access where app_id = %s",
            "DELETE FROM mzansi_calendar.appointments where app_id = %s",
            "DELETE FROM mzansi_wallet.loyalty_cards where app_id = %s",
            "DELETE FROM patient_manager.patients where app_id = %s",
            "DELETE FROM patient_manager.patient_notes where app_id = %s",
            "DELETE FROM patient_manager.patient_files where app_id = %s",
            "DELETE FROM patient_manager.claim_statement_file where app_id = %s",
            "DELETE FROM app_data.users where app_id = %s",
        ]
        #delete user from all tables
        for query in queries:
            cursor.execute(query, (app_id,))
        # Delete user from SuperTokens
        try:
            delete_user(app_id)
        except Exception as error:
            raise HTTPException(status_code=500, detail="Failed to delete user from SuperTokens - " + str(error))
        db.commit()
    except Exception as error:
        db.rollback()
        raise HTTPException(status_code=500, detail=error)
    finally:
        cursor.close()
        db.close()
    return {"message": "Successfully Deleted User Account & Data"}
