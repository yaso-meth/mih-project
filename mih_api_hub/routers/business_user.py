from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
#from ..mih_database import dbConnection
import mih_database
#SuperToken Auth from front end
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.session import SessionContainer
from fastapi import Depends

router = APIRouter()

# class userRequest(BaseModel):
#     email: str
#     DocOfficeID: int

class businessUserInsertRequest(BaseModel):
    business_id: str
    app_id: str
    signature: str
    sig_path: str
    title: str
    access: str

class BusinessUserUpdateRequest(BaseModel):
    business_id: str
    app_id: str
    signature: str
    sig_path: str
    title: str
    access: str

class EmployeeUpdateRequest(BaseModel):
    business_id: str
    app_id: str
    title: str
    access: str

class employeeDeleteRequest(BaseModel):
    business_id: str
    app_id: str

# Get List of all files
@router.get("/business-user/{app_id}", tags=["MIH Business_User"])
async def read_business_users_by_app_id(app_id: str, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = mih_database.dbConnection.dbAppDataConnect()
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
            "sig_path": item[4],
            "title": item[5],
            "access": item[6],
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    if(len(items)!= 0):
        return items[0]
    else:
        raise HTTPException(status_code=404, detail="No record found")

# Get List of all files
@router.get("/business-user/employees/{business_id}", tags=["MIH Business_User"])
async def read_business_users_by_business_id(business_id: str, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = mih_database.dbConnection.dbAppDataConnect()
    cursor = db.cursor()
    query = ""
    query += "SELECT business_users.business_id, business_users.app_id, business_users.title, business_users.access, "
    query += "users.fname, users.lname, users.email, users.username "
    query += "FROM business_users "
    query += "inner join users on business_users.app_id = users.app_id "
    query += "where business_id = %s "
    try:
        cursor.execute(query, (business_id,))
    except Exception as error:
        raise HTTPException(status_code=404, detail="Failed - " + error)
    items = [
        {
            "business_id": item[0],
            "app_id": item[1],
            "title": item[2],
            "access": item[3],
            "fname": item[4],
            "lname": item[5],
            "email": item[6],
            "username": item[7],
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    if(len(items)!= 0):
        return items
    else:
        raise HTTPException(status_code=404, detail="No record found")

# Insert Patient into table
@router.post("/business-user/insert/", tags=["MIH Business_User"], status_code=201)
async def insert_User_details(itemRequest : businessUserInsertRequest, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = mih_database.dbConnection.dbAppDataConnect()
    cursor = db.cursor()
    checkQuery = "SELECT * FROM business_users where app_id = %s"
    try:
        cursor.execute(checkQuery, (itemRequest.app_id,))
    except Exception as error:
        raise HTTPException(status_code=404, detail="Failed - " + error)
    items = [
        {
            "idbusiness_users": item[0],
            "business_id": item[1],
            "app_id": item[2],
            "signature": item[3],
            "sig_path": item[4],
            "title": item[5],
            "access": item[6],
        }
        for item in cursor.fetchall()
    ]
    #print(f"checkQuery: {len(items)}")
    if(len(items) <1):
        createQuery = "insert into business_users "
        createQuery += "(business_id, app_id, signature, sig_path, title, access) "
        createQuery += "values (%s, %s, %s, %s, %s, %s)"
        userData1 = (itemRequest.business_id,
                itemRequest.app_id,
                itemRequest.signature,
                itemRequest.sig_path,
                itemRequest.title,
                itemRequest.access)
        try:
            cursor.execute(createQuery, userData1) 
        except Exception as error:
            raise HTTPException(status_code=404, detail="Failed to Create Record")
            #return {"message": "Failed to Create Record"}
    else:
        updateQuery = "update business_users "
        updateQuery += "set business_id=%s, title=%s, access=%s "
        updateQuery += "where app_id=%s"
        userData2 = (itemRequest.business_id,
                    itemRequest.title,
                    itemRequest.access,
                    itemRequest.app_id,
                    )
        try:
            cursor.execute(updateQuery, userData2) 
        except Exception as error:
            raise HTTPException(status_code=404, detail=error)
    
    updateTypeQuery = "update users "
    updateTypeQuery += "set type='business' "
    updateTypeQuery += "where app_id=%s"
    userData2 = (
                itemRequest.app_id,
                )
    try:
        cursor.execute(updateTypeQuery, userData2) 
    except Exception as error:
        raise HTTPException(status_code=404, detail=error)
    db.commit()
    cursor.close()
    db.close()
    return {"message": "Successfully Created Record"}

# Update User on table
@router.put("/business-user/update/", tags=["MIH Business_User"])
async def Update_User_details(itemRequest : BusinessUserUpdateRequest, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = mih_database.dbConnection.dbAppDataConnect()
    cursor = db.cursor()
    query = "update business_users "
    query += "set signature=%s,sig_path=%s, title=%s, access=%s"
    query += "where app_id=%s and business_id=%s"
    userData = (itemRequest.signature, 
                itemRequest.sig_path,
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

# Update User on table
@router.put("/business-user/employees/update/", tags=["MIH Business_User"])
async def Update_User_details(itemRequest : EmployeeUpdateRequest, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = mih_database.dbConnection.dbAppDataConnect()
    cursor = db.cursor()
    query = "update business_users "
    query += "set title=%s, access=%s"
    query += "where app_id=%s and business_id=%s"
    userData = (
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

# Delete Patient note on table
@router.delete("/business-user/employees/delete/", tags=["MIH Business_User"])
async def Delete_Patient_note(itemRequest : employeeDeleteRequest, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    # today = date.today()
    db = mih_database.dbConnection.dbAppDataConnect()
    cursor = db.cursor()
    query = "delete from business_users "
    query += "where business_id=%s "
    query += "and app_id=%s"
    # notetData = (itemRequest.idpatient_notes)
    try:
       cursor.execute(query, (itemRequest.business_id,
                              itemRequest.app_id,)) 
    except Exception as error:
        #raise HTTPException(status_code=404, detail="Failed to Delete Record")
        return {"query": query, "message": error}
    
    updateTypeQuery = "update users "
    updateTypeQuery += "set type='personal' "
    updateTypeQuery += "where app_id=%s"
    userData2 = (
                itemRequest.app_id,
                )
    try:
        cursor.execute(updateTypeQuery, userData2) 
    except Exception as error:
        raise HTTPException(status_code=404, detail=error)
    db.commit()
    cursor.close()
    db.close()
    return {"message": "Successfully deleted Record"}