from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from ..database import dbConnection

router = APIRouter()

class userRequest(BaseModel):
    DocOfficeID: int
    patientID: int

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
            "UserName": item[1],
            "Password": item[2],
            "docOffice_ID": item[3],
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items