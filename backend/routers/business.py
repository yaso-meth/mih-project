from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
#from ..database import dbConnection
import database
#SuperToken Auth from front end
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.session import SessionContainer
from fastapi import Depends
import uuid

import database.dbConnection

router = APIRouter()

# class userRequest(BaseModel):
#     email: str
#     DocOfficeID: int

class businessInsertRequest(BaseModel):
    Name: str
    type: str
    registration_no: str
    logo_name: str
    logo_path: str
    contact_no: str
    bus_email: str
    gps_location: str
    practice_no: str
    vat_no: str
    website: str
    rating: str
    mission_vision: str

class businessUpdateRequest(BaseModel):
    business_id: str
    Name: str
    type: str
    registration_no: str
    logo_name: str
    logo_path: str
    contact_no: str
    bus_email: str
    gps_location: str
    practice_no: str
    vat_no: str
    
class businessUpdateRequestV2(BaseModel):
    business_id: str
    Name: str
    type: str
    registration_no: str
    logo_name: str
    logo_path: str
    contact_no: str
    bus_email: str
    gps_location: str
    practice_no: str
    vat_no: str
    website: str
    rating: str
    mission_vision: str
    

# Get List of all files
@router.get("/businesses/search/{search}", tags=["MIH Business"])
async def read_all_businesses(search: str, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbAppDataConnect()
    cursor = db.cursor()
    query = "SELECT business.business_id, business.Name, business.type, business.registration_no, "
    query += "business.logo_name, business.logo_path, business.contact_no, business.bus_email, "
    query += "business.gps_location, "
    query += "practice_no, vat_no, "
    query += "website, rating, mission_vision "    
    query += "FROM business "
    query += "WHERE LOWER(business.Name) LIKE %s OR LOWER(business.type) LIKE %s"
    search_term = f"%{search.lower()}%"  # Add wildcards and lowercase
    cursor.execute(query, (search_term, search_term))
    items = [
        {
            "business_id": item[0],
            "Name": item[1],
            "type": item[2],
            "registration_no": item[3],
            "logo_name": item[4],
            "logo_path": item[5],
            "contact_no": item[6],
            "bus_email": item[7],
            "app_id": "",
            "gps_location": item[8],
            "practice_no": item[9],
            "vat_no": item[10],
            "website": item[11],
            "rating": item[12],
            "mission_vision": item[13],
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items

# Get List of all files
@router.get("/business/business_id/{business_id}", tags=["MIH Business"])
async def read_business_by_business_id(business_id: str, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbAppDataConnect()
    cursor = db.cursor()
    query = "SELECT business.business_id, business.Name, business.type, business.registration_no, "
    query += "business.logo_name, business.logo_path, business.contact_no, business.bus_email, "
    query += "business_users.app_id, business.gps_location, "
    query += "practice_no, vat_no, "
    query += "website, rating, mission_vision "    
    query += "FROM business "
    query += "inner join business_users "
    query += "on business.business_id=business_users.business_id "
    query += "where business.business_id = %s"
    try:
        cursor.execute(query, (business_id,))
    except Exception as error:
        raise HTTPException(status_code=404, detail="Failed to pull records")
    items = [
        {
            "business_id": item[0],
            "Name": item[1],
            "type": item[2],
            "registration_no": item[3],
            "logo_name": item[4],
            "logo_path": item[5],
            "contact_no": item[6],
            "bus_email": item[7],
            "app_id": item[8],
            "gps_location": item[9],
            "practice_no": item[10],
            "vat_no": item[11],
            "website": item[12],
            "rating": item[13],
            "mission_vision": item[14],
        }
        for item in cursor.fetchall()
    ]
    #
    cursor.close()
    db.close()
    if(len(items)!= 0):
        return items[0]
    else:
        raise HTTPException(status_code=404, detail="No record found")


# Get List of all files
@router.get("/business/app_id/{app_id}", tags=["MIH Business"])
async def read_business_by_app_id(app_id: str, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbAppDataConnect()
    cursor = db.cursor()
    query = "SELECT business.business_id, business.Name, business.type, business.registration_no, "
    query += "business.logo_name, business.logo_path, business.contact_no, business.bus_email, "
    query += "business_users.app_id, business.gps_location, "
    query += "practice_no, vat_no, "    
    query += "website, rating, mission_vision "    
    query += "FROM business "
    query += "inner join business_users "
    query += "on business.business_id=business_users.business_id "
    query += "where business_users.app_id = %s"
    try:
        cursor.execute(query, (app_id,))
    except Exception as error:
        raise HTTPException(status_code=404, detail="Failed to pull records")
    items = [
        {
            "business_id": item[0],
            "Name": item[1],
            "type": item[2],
            "registration_no": item[3],
            "logo_name": item[4],
            "logo_path": item[5],
            "contact_no": item[6],
            "bus_email": item[7],
            "app_id": item[8],
            "gps_location": item[9],
            "practice_no": item[10],
            "vat_no": item[11],
            "website": item[12],
            "rating": item[13],
            "mission_vision": item[14],
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    if(len(items)!= 0):
        return items[0]
    else:
        raise HTTPException(status_code=404, detail="No record found")

# Insert Patient into table
@router.post("/business/insert/", tags=["MIH Business"], status_code=201)
async def insert_business_details(itemRequest : businessInsertRequest, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbAppDataConnect()
    cursor = db.cursor()
    query = "insert into business "
    query += "(business_id, Name, type, registration_no, logo_name, logo_path, contact_no, bus_email, gps_location, practice_no, vat_no, website, rating, mission_vision) "
    query += "values (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
    uuidString = str(uuid.uuid1())
    userData = (uuidString,
                itemRequest.Name,
                itemRequest.type,
                itemRequest.registration_no,
                itemRequest.logo_name,
                itemRequest.logo_path,
                itemRequest.contact_no,
                itemRequest.bus_email,
                itemRequest.gps_location,
                itemRequest.practice_no,
                itemRequest.vat_no,
                itemRequest.website,
                itemRequest.rating,
                itemRequest.mission_vision,
                )
    try:
        print(query)
        print(userData)
        cursor.execute(query, userData) 
    except Exception as error:
         raise HTTPException(status_code=404, detail=error)
        # return {"message": error}
    db.commit()
    cursor.close()
    db.close()
    return {"business_id": uuidString}

@router.put("/business/update/", tags=["MIH Business"])
async def Update_Business_details(itemRequest : businessUpdateRequest, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbAppDataConnect()
    # print(itemRequest.gps_location)
    cursor = db.cursor()
    query = "update business "
    query += "set Name=%s, type=%s, registration_no=%s, logo_name=%s, logo_path=%s, contact_no=%s, bus_email=%s, gps_location=%s, practice_no=%s, vat_no=%s "
    query += "where business_id=%s"
    userData = (itemRequest.Name, 
                itemRequest.type,
                itemRequest.registration_no,
                itemRequest.logo_name.replace(" ", "-"),
                itemRequest.logo_path.replace(" ", "-"),
                itemRequest.contact_no,
                itemRequest.bus_email,
                itemRequest.gps_location,
                itemRequest.practice_no,
                itemRequest.vat_no,
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

@router.put("/business/update/v2/", tags=["MIH Business"])
async def Update_Business_details(itemRequest : businessUpdateRequestV2, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbAppDataConnect()
    # print(itemRequest.gps_location)
    cursor = db.cursor()
    query = "update business "
    query += "set Name=%s, type=%s, registration_no=%s, logo_name=%s, logo_path=%s, contact_no=%s, bus_email=%s, gps_location=%s, practice_no=%s, vat_no=%s, website=%s, rating=%s, mission_vision=%s "
    query += "where business_id=%s"
    userData = (itemRequest.Name, 
                itemRequest.type,
                itemRequest.registration_no,
                itemRequest.logo_name.replace(" ", "-"),
                itemRequest.logo_path.replace(" ", "-"),
                itemRequest.contact_no,
                itemRequest.bus_email,
                itemRequest.gps_location,
                itemRequest.practice_no,
                itemRequest.vat_no,
                itemRequest.website,
                itemRequest.rating,
                itemRequest.mission_vision,
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