import mysql.connector
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
#from ..database import dbConnection
import database
#SuperToken Auth from front end
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.session import SessionContainer
from fastapi import Depends

router = APIRouter()

class patientInsertRequest(BaseModel):
    id_no: str
    first_name: str
    last_name: str
    email: str
    cell_no: str
    medical_aid: str
    medical_aid_main_member: str
    medical_aid_no: str
    medical_aid_code: str
    medical_aid_name: str
    medical_aid_scheme: str
    address: str
    app_id: str

class patientUpdateRequest(BaseModel):
    id_no: str
    first_name: str
    last_name: str
    email: str
    cell_no: str
    medical_aid: str
    medical_aid_main_member: str
    medical_aid_no: str
    medical_aid_code: str
    medical_aid_name: str
    medical_aid_scheme: str
    address: str
    app_id: str

class patientDeleteRequest(BaseModel):
    app_id: str

# # Get Patient By ID Number
# @router.get("/patients/id/{pat_id}", tags="patients")
# async def read_patientByID(pat_id: str, session: SessionContainer = Depends(verify_session())):
#     db = database.dbConnection.dbConnect()
#     cursor = db.cursor()
#     query = "SELECT * FROM patients WHERE idpatients=%s"
#     cursor.execute(query, (pat_id,))
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


# Get Patient By app ID
@router.get("/patients/{app_id}", tags=["Patients"])
async def read_patient_By_app_ID(app_id: str, session: SessionContainer = Depends(verify_session())):
    db = database.dbConnection.dbConnect()
    cursor = db.cursor()
    query = "SELECT * FROM patients WHERE app_id=%s"
    cursor.execute(query, (app_id,))
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
    "medical_aid": item[10],
    "medical_aid_main_member": item[11],
    "medical_aid_code": item[12],
    "app_id": item[13],}

# # Get Patient By ID Number
# @router.get("/patients/email/{email}", tags="patients")
# async def read_patientByID(email: str, session: SessionContainer = Depends(verify_session())):
#     db = database.dbConnection.dbConnect()
#     cursor = db.cursor()
#     query = "SELECT * FROM patients WHERE lower(email)=%s"
#     cursor.execute(query, (email.lower(),))
#     item = cursor.fetchone()
#     cursor.close()
#     db.close()
#     if item is None:
#         raise HTTPException(status_code=404, detail=("Item not found for "+ email))
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
#     "medical_aid": item[10],
#     "medical_aid_main_member": item[11],
#     "medical_aid_code": item[12],}


# # Get List of all patients
# @router.get("/patients/user/{email}", tags="patients")
# async def read_all_patientsByUser(email: str, session: SessionContainer = Depends(verify_session())):
#     db = database.dbConnection.dbConnect()
#     cursor = db.cursor()
#     #query = "SELECT * FROM patients"
#     query = "Select * from patients " 
#     query += "inner join users " 
#     query += "on doc_office_id = docOffice_id "
#     query += "where lower(users.email)= %s"
#     cursor.execute(query, (email.lower(),))
#     items = [
#         {
#             "idpatients": item[0],
#             "id_no": item[1],
#             "first_name": item[2],
#             "last_name": item[3],
#             "email": item[4],
#             "cell_no": item[5],
#             "medical_aid": item[11],
#             "medical_aid_name": item[6],
#             "medical_aid_no": item[7],
#             "medical_aid_main_member": item[12],
#             "medical_aid_code": item[13],  
#             "medical_aid_scheme": item[8],
#             "address": item[9],
#             "doc_office_id": item[10]
#         }
#         for item in cursor.fetchall()
#     ]
#     cursor.close()
#     db.close()
#     return items

# # Get List of all patients
# @router.get("/patients/", tags="patients")
# async def read_all_patients(session: SessionContainer = Depends(verify_session())):
#     db = database.dbConnection.dbConnect()
#     cursor = db.cursor()
#     query = "SELECT * FROM patients"
#     cursor.execute(query)
#     items = [
#         {
#             "idpatients": item[0],
#             "id_no": item[1],
#             "first_name": item[2],
#             "last_name": item[3],
#             "email": item[4],
#             "cell_no": item[5],
#             "medical_aid_name": item[6],
#             "medical_aid_no": item[7],
#             "medical_aid_scheme": item[8],
#             "address": item[9],
#             "doc_office_id": item[10]
#         }
#         for item in cursor.fetchall()
#     ]
#     cursor.close()
#     db.close()
#     return items

# # Get List of all patients by Doctors Office
# @router.get("/patients/docOffice/{docoff_id}", tags="patients")
# async def read_all_patientsby(docoff_id: str, session: SessionContainer = Depends(verify_session())):
#     db = database.dbConnection.dbConnect()
#     cursor = db.cursor()
#     query = "SELECT * FROM patients where doc_office_id=%s"
#     cursor.execute(query, (docoff_id,))
#     items = [
#         {
#             "idpatients": item[0],
#             "id_no": item[1],
#             "first_name": item[2],
#             "last_name": item[3],
#             "email": item[4],
#             "cell_no": item[5],
#             "medical_aid_name": item[6],
#             "medical_aid_no": item[7],
#             "medical_aid_scheme": item[8],
#             "address": item[9],
#             "doc_office_id": item[10]
#         }
#         for item in cursor.fetchall()
#     ]
#     cursor.close()
#     db.close()
#     return items

# Insert Patient into table
@router.post("/patients/insert/", tags=["Patients"], status_code=201)
async def insert_Patient(itemRequest : patientInsertRequest, session: SessionContainer = Depends(verify_session())):
    db = database.dbConnection.dbConnect()
    cursor = db.cursor()
    query = "insert into patients "
    query += "(id_no, first_name, last_name, email, cell_no, medical_aid, "
    query += "medical_aid_main_member, medical_aid_no, medical_aid_code, medical_aid_name, "
    query += "medical_aid_scheme, address, app_id) "
    query += "values (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
    patientData = (itemRequest.id_no, 
                   itemRequest.first_name,
                   itemRequest.last_name,
                   itemRequest.email,
                   itemRequest.cell_no,
                   itemRequest.medical_aid,
                   itemRequest.medical_aid_main_member,
                   itemRequest.medical_aid_no,
                   itemRequest.medical_aid_code,
                   itemRequest.medical_aid_name,
                   itemRequest.medical_aid_scheme,
                   itemRequest.address,
                   itemRequest.app_id)
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
@router.put("/patients/update/", tags=["Patients"])
async def Update_Patient(itemRequest : patientUpdateRequest, session: SessionContainer = Depends(verify_session())):
    db = database.dbConnection.dbConnect()
    cursor = db.cursor()
    query = "update patients "
    query += "set id_no=%s, first_name=%s, last_name=%s, email=%s, cell_no=%s, medical_aid=%s, "
    query += "medical_aid_main_member=%s, medical_aid_no=%s, medical_aid_code=%s, medical_aid_name=%s, "
    query += "medical_aid_scheme=%s, address=%s, app_id=%s "
    query += "where app_id=%s"
    patientData = (itemRequest.id_no, 
                   itemRequest.first_name,
                   itemRequest.last_name,
                   itemRequest.email,
                   itemRequest.cell_no,
                   itemRequest.medical_aid,
                   itemRequest.medical_aid_main_member,
                   itemRequest.medical_aid_no,
                   itemRequest.medical_aid_code,
                   itemRequest.medical_aid_name,
                   itemRequest.medical_aid_scheme,
                   itemRequest.address,
                   itemRequest.app_id,
                   itemRequest.app_id,)
    try:
       cursor.execute(query, patientData) 
    except Exception as error:
        raise HTTPException(status_code=404, detail="Failed to Update Record")
        #return {"query": query, "message": error}
    db.commit()
    cursor.close()
    db.close()
    return {"message": "Successfully Updated Record"}

# delete Patient on table
@router.delete("/patients/delete/", tags=["Patients"])
async def Delete_Patient(itemRequest : patientDeleteRequest, session: SessionContainer = Depends(verify_session())):
    db = database.dbConnection.dbConnect()
    cursor = db.cursor()
    query = "delete from patients "
    query += "where app_id=%s"
    patientData = (itemRequest.app_id,
                   )
    try:
       cursor.execute(query, patientData) 
    except Exception as error:
        raise HTTPException(status_code=404, detail="Failed to delete Record")
        #return {"query": query, "message": error}
    db.commit()
    cursor.close()
    db.close()
    return {"message": "Successfully delete Record"}