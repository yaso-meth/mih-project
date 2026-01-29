from fastapi import APIRouter, HTTPException, status
from pydantic import BaseModel
#from ..mih_database import dbConnection
import mih_database
import mih_database.mihDbConnections
from mih_database.mihDbObjects import User, Business, BusinessRating, BookmarkedBusiness
from sqlalchemy import desc, or_
from sqlalchemy.orm import Session
from sqlalchemy.sql import func
#SuperToken Auth from front end
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.session import SessionContainer
from fastapi import Depends
import uuid

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
    
@router.get("/business/count/", tags=["MIH Business"])
async def read_business_by_business_id(): #, session: SessionContainer = Depends(verify_session())
    dbEngine = mih_database.mihDbConnections.dbAllConnect()
    dbSession = Session(dbEngine)
    try:
        queryResults = dbSession.query(func.count(Business.business_id)).scalar()
        response_data = {"count": queryResults}
        return response_data 
    except Exception as e:
        print(f"An error occurred during the ORM query: {e}")
        if dbSession.is_active:
            dbSession.rollback()
        raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Failed to retrieve records due to an internal server error."
            )
    finally:
        dbSession.close()

# Get List of all files
@router.get("/business/types/", tags=["MIH Business"])
async def read_business_by_business_id(session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    dbEngine = mih_database.mihDbConnections.dbAllConnect()
    dbSession = Session(dbEngine)
    try:
        queryResults = dbSession.query(Business.type).distinct().order_by(Business.type).all()
        response_data = [{"type": t[0]} for t in queryResults]
        return response_data 
    except Exception as e:
        print(f"An error occurred during the ORM query: {e}")
        if dbSession.is_active:
            dbSession.rollback()
        raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Failed to retrieve records due to an internal server error."
            )
    finally:
        dbSession.close()

# Get List of all files
@router.get("/business/search/{type}/{search}", tags=["MIH Business"])
async def read_all_businesses(search: str, type: str, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    dbEngine = mih_database.mihDbConnections.dbAllConnect()
    dbSession = Session(dbEngine)
    try:
        queryResults = dbSession.query(Business)
        type_term_with_wildcards = ""
        if type != "All":
            type_term_with_wildcards = f"%{type.lower()}%"
            queryResults = queryResults.filter(
                Business.type.ilike(type_term_with_wildcards)
            )
        search_term_with_wildcards = ""
        if search != "All":
            search_term_with_wildcards = f"%{search.lower()}%"
            queryResults = queryResults.filter(
                or_(
                    Business.Name.ilike(search_term_with_wildcards),
                    Business.bus_email.ilike(search_term_with_wildcards),
                    Business.mission_vision.ilike(search_term_with_wildcards),
                )
            )
        queryResults = queryResults.all()
        response_data = []
        for business in queryResults:
            response_data.append({
                "business_id": business.business_id,
                "Name": business.Name,
                "type": business.type,
                "registration_no": business.registration_no,
                "logo_name": business.logo_name,
                "logo_path": business.logo_path,
                "contact_no": business.contact_no,
                "bus_email": business.bus_email,
                "app_id": "",
                "gps_location": business.gps_location,
                "practice_no": business.practice_no,
                "vat_no": business.vat_no,
                "website": business.website,
                "rating": business.rating,
                "mission_vision": business.mission_vision,
            })

        return response_data
    except Exception as e:
        print(f"An error occurred during the ORM query: {e}")
        if dbSession.is_active:
            dbSession.rollback()
        raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Failed to retrieve records due to an internal server error."
            )
    finally:
        dbSession.close()
    # db = mih_database.dbConnection.dbAppDataConnect()
    # cursor = db.cursor()
    # query = "SELECT business.business_id, business.Name, business.type, business.registration_no, "
    # query += "business.logo_name, business.logo_path, business.contact_no, business.bus_email, "
    # query += "business.gps_location, "
    # query += "practice_no, vat_no, "
    # query += "website, rating, mission_vision "    
    # query += "FROM business "
    # query += "WHERE LOWER(business.Name) LIKE %s OR LOWER(business.type) LIKE %s "
    # query += "OR LOWER(business.bus_email) LIKE %s OR LOWER(business.mission_vision) LIKE %s"
    # search_term = f"%{search.lower()}%"  # Add wildcards and lowercase
    # cursor.execute(query, (search_term, search_term, search_term, search_term))
    # items = [
    #     {
    #         "business_id": item[0],
    #         "Name": item[1],
    #         "type": item[2],
    #         "registration_no": item[3],
    #         "logo_name": item[4],
    #         "logo_path": item[5],
    #         "contact_no": item[6],
    #         "bus_email": item[7],
    #         "app_id": "",
    #         "gps_location": item[8],
    #         "practice_no": item[9],
    #         "vat_no": item[10],
    #         "website": item[11],
    #         "rating": item[12],
    #         "mission_vision": item[13],
    #     }
    #     for item in cursor.fetchall()
    # ]
    # cursor.close()
    # db.close()
    # return items

# Get List of all files
@router.get("/business/business_id/{business_id}", tags=["MIH Business"])
async def read_business_by_business_id(business_id: str): #, session: SessionContainer = Depends(verify_session())
    dbEngine = mih_database.mihDbConnections.dbAllConnect()
    dbSession = Session(dbEngine)
    try:
        queryResults = dbSession.query(Business).\
        filter(
            Business.business_id == business_id,
        ).first()
        if queryResults:
            return {
                "business_id": queryResults.business_id,
                "Name": queryResults.Name,
                "type": queryResults.type,
                "registration_no": queryResults.registration_no,
                "logo_name": queryResults.logo_name,
                "logo_path": queryResults.logo_path,
                "contact_no": queryResults.contact_no,
                "bus_email": queryResults.bus_email,
                "app_id": "",
                "gps_location": queryResults.gps_location,
                "practice_no": queryResults.practice_no,
                "vat_no": queryResults.vat_no,
                "website": queryResults.website,
                "rating": queryResults.rating,
                "mission_vision": queryResults.mission_vision,
            }
        else:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Business not found for the given business_id."
            )
    except HTTPException as http_exc:
        # Re-raise HTTPException directly if it was raised within the try block
        raise http_exc
    except Exception as e:
        print(f"An error occurred during the ORM query: {e}")
        if dbSession.is_active:
            dbSession.rollback()
        raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Failed to retrieve records due to an internal server error."
            )
    finally:
        dbSession.close()

# Get List of all files
@router.get("/business/app_id/{app_id}", tags=["MIH Business"])
async def read_business_by_app_id(app_id: str, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = mih_database.dbConnection.dbAppDataConnect()
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
    db = mih_database.dbConnection.dbAppDataConnect()
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
    db = mih_database.dbConnection.dbAppDataConnect()
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
    db = mih_database.dbConnection.dbAppDataConnect()
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