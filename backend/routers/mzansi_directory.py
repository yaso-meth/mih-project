from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from datetime import datetime
import database
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.session import SessionContainer
from fastapi import Depends

router = APIRouter()

# class BusinessRatingUserGet(BaseModel):
#     app_id: str
#     business_id: str

class BusinessRatingInsertRequest(BaseModel):
    app_id: str
    business_id: str
    rating_title: str
    rating_description: str
    rating_score: int

class BusinessRatingDeleteRequest(BaseModel):
    idbusiness_ratings: int

class BusinessRatingUpdateRequest(BaseModel):
    idbusiness_ratings: int
    rating_title: str
    rating_description: str
    rating_score: str

@router.get("/mzasni-directory/business-ratings/user/{app_id}/{business_id}", tags=["Mzansi Directory"])
async def read_all_ratings_by_business_id(app_id: str,business_id: str, session: SessionContainer = Depends(verify_session())): # , session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbAllConnect()
    cursor = db.cursor()
    query = ""
    query += "SELECT business_ratings.idbusiness_ratings, business_ratings.app_id, business_ratings.business_id, "
    query += "business_ratings.rating_title, business_ratings.rating_description, business_ratings.rating_score, "
    query += "business_ratings.date_time, users.username as 'reviewer' "
    query += "FROM mzansi_directory.business_ratings "
    query += "inner join app_data.users "
    query += "on business_ratings.app_id = users.app_id "
    query += "where business_ratings.business_id = %s and business_ratings.app_id = %s;"
    cursor.execute(query, (business_id,
                           app_id,))
    item = cursor.fetchone() # Get only one row
    cursor.close()
    db.close()
    
    if item:
        # Return a single dictionary
        return {
            "idbusiness_ratings": item[0],
            "app_id": item[1],
            "business_id": item[2],
            "rating_title": item[3],
            "rating_description": item[4],
            "rating_score": item[5],
            "date_time": item[6],
            "reviewer": item[7],
        }
    else:
        # Return an empty response or a specific message
        return None
    # items = [
    #     {
    #         "idbusiness_ratings": item[0],
    #         "app_id": item[1],
    #         "business_id": item[2],
    #         "rating_title": item[3],
    #         "rating_description": item[4],
    #         "rating_score": item[5],
    #         "date_time": item[6],
    #         "reviewer": item[7],
    #     }
    #     for item in cursor.fetchall()
    # ]
    # cursor.close()
    # db.close()
    # return items[0]

@router.get("/mzasni-directory/business-ratings/all/{business_id}", tags=["Mzansi Directory"])
async def read_all_ratings_by_business_id(business_id: str, session: SessionContainer = Depends(verify_session())): # , session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbAllConnect()
    cursor = db.cursor()
    query = ""
    query += "SELECT business_ratings.idbusiness_ratings, business_ratings.app_id, business_ratings.business_id, "
    query += "business_ratings.rating_title, business_ratings.rating_description, business_ratings.rating_score, "
    query += "business_ratings.date_time, users.username as 'reviewer' "
    query += "FROM mzansi_directory.business_ratings "
    query += "inner join app_data.users "
    query += "on business_ratings.app_id = users.app_id "
    query += "where business_ratings.business_id = %s "
    query += "order by business_ratings.date_time desc;"
    cursor.execute(query, (business_id,))
    items = [
        {
            "idbusiness_ratings": item[0],
            "app_id": item[1],
            "business_id": item[2],
            "rating_title": item[3],
            "rating_description": item[4],
            "rating_score": item[5],
            "date_time": item[6],
            "reviewer": item[7],
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items

@router.post("/mzasni-directory/business-rating/insert/", tags=["Mzansi Directory"], status_code=201)
async def insert_loyalty_card(itemRequest : BusinessRatingInsertRequest): #, session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbMzansiDirectoryConnect()
    nowDateTime = datetime.now()
    formatedDateTime = nowDateTime.strftime("%Y-%m-%d %H:%M:%S")
    cursor = db.cursor()
    query = "insert into business_ratings "
    query += "(app_id, business_id, rating_title, rating_description, rating_score, date_time) "
    query += "values (%s, %s, %s, %s, %s, %s)"
    notetData = (itemRequest.app_id, 
                   itemRequest.business_id,
                   itemRequest.rating_title,
                     itemRequest.rating_description,
                     itemRequest.rating_score,
                     formatedDateTime,
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
    return {"message": "Successfully Created Record"}

@router.delete("/mzasni-directory/business-ratng/delete/", tags=["Mzansi Directory"])
async def Delete_loyalty_card(itemRequest : BusinessRatingDeleteRequest, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbMzansiDirectoryConnect()
    cursor = db.cursor()
    query = "delete from business_ratings "
    query += "where idbusiness_ratings=%s"
    try:
       cursor.execute(query, (str(itemRequest.idbusiness_ratings),)) 
    except Exception as error:
        print(error)
        raise HTTPException(status_code=404, detail="Failed to Delete Record")
    db.commit()
    cursor.close()
    db.close()
    return {"message": "Successfully deleted Record"}

@router.put("/mzasni-directory/business-rating/update/", tags=["Mzansi Directory"])
async def UpdatePatient(itemRequest : BusinessRatingUpdateRequest, session: SessionContainer = Depends(verify_session())):
    db = database.dbConnection.dbMzansiDirectoryConnect()
    cursor = db.cursor()
    nowDateTime = datetime.now()
    formatedDateTime = nowDateTime.strftime("%Y-%m-%d %H:%M:%S")
    query = "update business_ratings "
    query += "set rating_title=%s, rating_description=%s, rating_score=%s, date_time=%s "
    query += "where idbusiness_ratings=%s"
    notetData = (itemRequest.rating_title, 
                    itemRequest.rating_description,
                    itemRequest.rating_score,
                    formatedDateTime,
                    itemRequest.idbusiness_ratings,
                )
    try:
       cursor.execute(query, notetData) 
    except Exception as error:
        raise HTTPException(status_code=404, detail="Failed to Update Record")
    db.commit()
    cursor.close()
    db.close()
    return {"message": "Successfully Updated Record"}