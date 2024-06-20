import mysql.connector
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from ..database import dbConnection

router = APIRouter()

class patientInsertRequest(BaseModel):
    id_no: str
    first_name: str
    last_name: str
    email: str
    cell_no: str
    medical_aid_name: str
    medical_aid_no: str
    medical_aid_scheme: str
    address: str
    doc_office_id: int

class patientUpdateRequest(BaseModel):
    id_no: str
    first_name: str
    last_name: str
    email: str
    cell_no: str
    medical_aid_name: str
    medical_aid_no: str
    medical_aid_scheme: str
    address: str
    doc_office_id: int


# Get Patient By ID Number
@router.get("/patients/{id_no}", tags="patients")
async def read_patientByID(id_no: str):
    db = dbConnection.dbConnect()
    cursor = db.cursor()
    query = "SELECT * FROM patients WHERE id_no=%s"
    cursor.execute(query, (id_no,))
    item = cursor.fetchone()
    cursor.close()
    db.close()
    if item is None:
        raise HTTPException(status_code=404, detail="Item not found")
    return {"idpatients": item[0],
    "id_no": item[1],
    "first_name": item[2],
    "last_name": item[3],
    "email": item[4],
    "cell_no": item[5],
    "medical_aid_name": item[6],
    "medical_aid_no": item[7],
    "medical_aid_scheme": item[8],
    "address": item[9],
    "doc_office_id": item[10]}

# # Get Patient By ID Number
# @router.get("/patients/user/{email}", tags="patients")
# async def read_patientByID(email: str):
#     db = dbConnection.dbConnect()
#     cursor = db.cursor()
#     #query = "SELECT * FROM patients WHERE id_no=%s"
#     query = "Select * from patients " 
#     query += "inner join users " 
#     query += "on doc_office_id = docOffice_id "
#     query += "where users.email= %s"
#     cursor.execute(query, (email,))
#     item = cursor.fetchone()
#     cursor.close()
#     db.close()
#     if item is None:
#         raise HTTPException(status_code=404, detail="Item not found")
#     return {"idpatients": item[0],
#     "id_no": item[1],
#     "first_name": item[2],
#     "last_name": item[3],
#     "email": item[4],
#     "cell_no": item[5],
#     "medical_aid_name": item[6],
#     "medical_aid_no": item[7],
#     "medical_aid_scheme": item[8],
#     "address": item[9],
#     "doc_office_id": item[10]}

# Get List of all patients
@router.get("/patients/user/{email}", tags="patients")
async def read_all_patientsByUser(email: str):
    db = dbConnection.dbConnect()
    cursor = db.cursor()
    #query = "SELECT * FROM patients"
    query = "Select * from patients " 
    query += "inner join users " 
    query += "on doc_office_id = docOffice_id "
    query += "where users.email= %s"
    cursor.execute(query, (email,))
    items = [
        {
            "idpatients": item[0],
            "id_no": item[1],
            "first_name": item[2],
            "last_name": item[3],
            "email": item[4],
            "cell_no": item[5],
            "medical_aid_name": item[6],
            "medical_aid_no": item[7],
            "medical_aid_scheme": item[8],
            "address": item[9],
            "doc_office_id": item[10]
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items

# Get List of all patients
@router.get("/patients/", tags="patients")
async def read_all_patients():
    db = dbConnection.dbConnect()
    cursor = db.cursor()
    query = "SELECT * FROM patients"
    cursor.execute(query)
    items = [
        {
            "idpatients": item[0],
            "id_no": item[1],
            "first_name": item[2],
            "last_name": item[3],
            "email": item[4],
            "cell_no": item[5],
            "medical_aid_name": item[6],
            "medical_aid_no": item[7],
            "medical_aid_scheme": item[8],
            "address": item[9],
            "doc_office_id": item[10]
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items

# Get List of all patients by Doctors Office
@router.get("/patients/docOffice/{docoff_id}", tags="patients")
async def read_all_patientsby(docoff_id: str):
    db = dbConnection.dbConnect()
    cursor = db.cursor()
    query = "SELECT * FROM patients where doc_office_id=%s"
    cursor.execute(query, (docoff_id,))
    items = [
        {
            "idpatients": item[0],
            "id_no": item[1],
            "first_name": item[2],
            "last_name": item[3],
            "email": item[4],
            "cell_no": item[5],
            "medical_aid_name": item[6],
            "medical_aid_no": item[7],
            "medical_aid_scheme": item[8],
            "address": item[9],
            "doc_office_id": item[10]
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items

# Insert Patient into table
@router.post("/patients/insert/", tags="patients", status_code=201)
async def insertPatient(itemRequest : patientInsertRequest):
    db = dbConnection.dbConnect()
    cursor = db.cursor()
    query = "insert into patients "
    query += "(id_no, first_name, last_name, email, cell_no, medical_aid_name, "
    query += "medical_aid_no, medical_aid_scheme, address, doc_office_id) "
    query += "values (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
    patientData = (itemRequest.id_no, 
                   itemRequest.first_name,
                   itemRequest.last_name,
                   itemRequest.email,
                   itemRequest.cell_no,
                   itemRequest.medical_aid_name,
                   itemRequest.medical_aid_no,
                   itemRequest.medical_aid_scheme,
                   itemRequest.address,
                   itemRequest.doc_office_id)
    try:
       cursor.execute(query, patientData) 
    except Exception as error:
        raise HTTPException(status_code=404, detail="Failed to Create Record")
        #return {"message": "Failed to Create Record"}
    db.commit()
    cursor.close()
    db.close()
    return {"message": "Successfully Created Record"}

# Update Patient on table
@router.put("/patients/update/", tags="patients")
async def UpdatePatient(itemRequest : patientUpdateRequest):
    db = dbConnection.dbConnect()
    cursor = db.cursor()
    query = "update patients "
    query += "set id_no=%s, first_name=%s, last_name=%s, email=%s, cell_no=%s, medical_aid_name=%s, "
    query += "medical_aid_no=%s, medical_aid_scheme=%s, address=%s, doc_office_id=%s "
    query += "where id_no=%s and doc_office_id=%s"
    patientData = (itemRequest.id_no, 
                   itemRequest.first_name,
                   itemRequest.last_name,
                   itemRequest.email,
                   itemRequest.cell_no,
                   itemRequest.medical_aid_name,
                   itemRequest.medical_aid_no,
                   itemRequest.medical_aid_scheme,
                   itemRequest.address,
                   itemRequest.doc_office_id,
                   itemRequest.id_no,
                   itemRequest.doc_office_id)
    try:
       cursor.execute(query, patientData) 
    except Exception as error:
        raise HTTPException(status_code=404, detail="Failed to Update Record")
        #return {"query": query, "message": error}
    db.commit()
    cursor.close()
    db.close()
    return {"message": "Successfully Updated Record"}