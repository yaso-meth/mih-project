from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from ..database import dbConnection

router = APIRouter()

class userRequest(BaseModel):
    email: str
    DocOfficeID: int

class userInsertRequest(BaseModel):
    email: str
    app_id: str
    
#get user by email & doc Office ID
@router.get("/users/profile/{email}", tags="users")
async def read_all_users(email: str):
    db = dbConnection.dbConnect()
    cursor = db.cursor()
    query = "SELECT * FROM users where email = %s"
    cursor.execute(query, (email.lower(),)) 
    items = [
        {"idusers": item[0],
        "email": item[1],
        "docOffice_id": item[2],
        "fname":item[3],
        "lname":item[4],
        "title": item[5]
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items[0]
    

# Get List of all files
@router.get("/users/", tags="users")
async def read_all_users():
    db = dbConnection.dbConnect()
    cursor = db.cursor()
    query = "SELECT * FROM users"
    cursor.execute(query)
    items = [
        {
            "idUser": item[0],
            "email": item[1],
            "docOffice_ID": item[2],
            "fname": item[3],
            "lname": item[4],
            "title": item[5],
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items

# Get List of all files
@router.get("/user/{uid}", tags="users")
async def read_all_users(uid: str):
    db = dbConnection.dbConnect()
    cursor = db.cursor()
    query = "SELECT * FROM users where app_id = %s"
    cursor.execute(query, (uid,))
    items = [
        {
            "idUser": item[0],
            "email": item[1],
            "docOffice_ID": item[2],
            "fname": item[3],
            "lname": item[4],
            "title": item[5],
            "app_id": item[6],
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items[0]

# Insert Patient into table
@router.post("/user/insert/", tags="user", status_code=201)
async def insertPatient(itemRequest : userInsertRequest):
    db = dbConnection.dbConnect()
    cursor = db.cursor()
    query = "insert into users "
    query += "(email, app_id) "
    query += "values (%s, %s)"
    userData = (itemRequest.email, 
                   itemRequest.app_id)
    try:
       cursor.execute(query, userData) 
    except Exception as error:
        raise HTTPException(status_code=404, detail="Failed to Create Record")
        #return {"message": "Failed to Create Record"}
    db.commit()
    cursor.close()
    db.close()
    return {"message": "Successfully Created Record"}