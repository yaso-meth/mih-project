from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from ..database import dbConnection

router = APIRouter()

class userRequest(BaseModel):
    email: str
    DocOfficeID: int
    
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