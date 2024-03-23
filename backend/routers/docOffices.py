import mysql.connector
from fastapi import APIRouter, HTTPException

router = APIRouter()

def dbConnect():
    return mysql.connector.connect(
        host="mysqldb",
        user="root",
        passwd="root",
        database="patient_manager"
    )

# Get Doctors Office By ID
@router.get("/docOffices/{docOffic_id}", tags="DocOffice")
async def read_docOfficeByID(docOffic_id: int):
    db = dbConnect()
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

# Get List of all Doctors Office
@router.get("/docOffices/", tags="DocOffice")
async def read_All_DoctorsOffice():
    db = dbConnect()
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
