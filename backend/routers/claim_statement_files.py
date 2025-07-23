import mysql.connector
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
#from ..mih_database import dbConnection
import mih_database
from datetime import date
#SuperToken Auth from front end
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.session import SessionContainer
from fastapi import Depends

router = APIRouter()

class claimStatementDeleteRequest(BaseModel):
    idclaim_statement_file: int

class claimStatementInsertRequest(BaseModel):
    app_id: str
    business_id: str
    file_path: str
    file_name: str
    

# Get List of all files by patient
@router.get("/files/claim-statement/patient/{app_id}", tags=["Claim Statement Files"])
async def read_all_claim_statement_files_by_app_id(app_id: str, session: SessionContainer = Depends(verify_session())):
    db = mih_database.dbConnection.dbPatientManagerConnect()
    cursor = db.cursor()
    query = "SELECT * FROM claim_statement_file where app_id = %s ORDER BY insert_date DESC"
    cursor.execute(query, (app_id,))
    items = [
        {
            "idclaim_statement_file": item[0],
            "app_id": item[1],
            "business_id": item[2],
            "insert_date": item[3],
            "file_path": item[4],
            "file_name": item[5],
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items

# Get List of all files by patient
@router.get("/files/claim-statement/business/{business_id}", tags=["Claim Statement Files"])
async def read_all_claim_statement_files_by_business_id(business_id: str, session: SessionContainer = Depends(verify_session())):
    db = mih_database.dbConnection.dbPatientManagerConnect()
    cursor = db.cursor()
    query = "SELECT * FROM claim_statement_file where business_id = %s ORDER BY insert_date DESC"
    cursor.execute(query, (business_id,))
    items = [
        {
            "idclaim_statement_file": item[0],
            "app_id": item[1],
            "business_id": item[2],
            "insert_date": item[3],
            "file_path": item[4],
            "file_name": item[5],
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items

# Delete Patient note on table
@router.delete("/files/claim-statement/delete/", tags=["Claim Statement Files"])
async def Delete_Patient_File(itemRequest : claimStatementDeleteRequest, session: SessionContainer = Depends(verify_session())): #session: SessionContainer = Depends(verify_session())
    # today = date.today()
    db = mih_database.dbConnection.dbPatientManagerConnect()
    cursor = db.cursor()
    query = "delete from claim_statement_file "
    query += "where idclaim_statement_file=%s"
    # notetData = (itemRequest.idpatient_notes)
    try:
       cursor.execute(query, (str(itemRequest.idclaim_statement_file),)) 
    except Exception as error:
        raise HTTPException(status_code=404, detail="Failed to Delete Record")
        #return {"query": query, "message": error}
    db.commit()
    cursor.close()
    db.close()
    return {"message": "Successfully deleted Record"}

# Insert Patient note into table
@router.post("/files/claim-statement/insert/", tags=["Claim Statement Files"], status_code=201)
async def insert_Patient_Files(itemRequest : claimStatementInsertRequest, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    today = date.today()
    db = mih_database.dbConnection.dbPatientManagerConnect()
    cursor = db.cursor()
    query = "insert into claim_statement_file "
    query += "(app_id, business_id, file_path, file_name, insert_date) "
    query += "values (%s, %s, %s, %s, %s)"
    notetData = (
                itemRequest.app_id, 
                itemRequest.business_id,
                itemRequest.file_path,
                itemRequest.file_name,
                today,
                )
    try:
       cursor.execute(query, notetData) 
    except Exception as error:
        print(error)
        raise HTTPException(status_code=404, detail="Failed to Create Record")
        # return {"message": error}
    db.commit()
    cursor.close()
    db.close()
    return {"message": "Successfully Created file Record"}
