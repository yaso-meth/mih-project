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
    rating_score: str
    current_rating: str

class BusinessRatingDeleteRequest(BaseModel):
    idbusiness_ratings: int
    business_id: str
    rating_score: str
    current_rating: str

class BusinessRatingUpdateRequest(BaseModel):
    idbusiness_ratings: int
    business_id: str
    rating_title: str
    rating_description: str
    rating_new_score: str
    rating_old_score: str
    current_rating: str

@router.get("/mzansi-directory/business-ratings/user/{app_id}/{business_id}", tags=["Mzansi Directory"])
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

@router.get("/mzansi-directory/business-ratings/all/{business_id}", tags=["Mzansi Directory"])
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

@router.post("/mzansi-directory/business-rating/insert/", tags=["Mzansi Directory"], status_code=201)
async def insert_loyalty_card(itemRequest : BusinessRatingInsertRequest): #, session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbAllConnect()
    nowDateTime = datetime.now()
    formatedDateTime = nowDateTime.strftime("%Y-%m-%d %H:%M:%S")
    cursor = db.cursor()
    try:
        # Get No Of reviews for business
        businessReviewCountQuery = "select count(*) from mzansi_directory.business_ratings where business_ratings.business_id = %s"
        countData = (itemRequest.business_id,)
        cursor.execute(businessReviewCountQuery, countData) 
        countResult = cursor.fetchone()
        row_count = countResult[0] if countResult else 0
        print(f"Number of rows in business_ratings: {row_count}")
        # add business rating
        addQuery = "insert into mzansi_directory.business_ratings "
        addQuery += "(business_ratings.app_id, business_ratings.business_id, business_ratings.rating_title, business_ratings.rating_description, business_ratings.rating_score, business_ratings.date_time) "
        addQuery += "values (%s, %s, %s, %s, %s, %s)"
        addQueryData = (itemRequest.app_id, 
                        itemRequest.business_id,
                        itemRequest.rating_title,
                        itemRequest.rating_description,
                        itemRequest.rating_score,
                        formatedDateTime,
                        )
        cursor.execute(addQuery, addQueryData) 
        # Calc New Rating and update business rating 
        newRating = ((float(itemRequest.current_rating) * row_count) + float(itemRequest.rating_score)) / (row_count + 1)
        print(f"New Rating: {newRating}")
        updateBusinessQuery = "update app_data.business "
        updateBusinessQuery += "set rating = %s "
        updateBusinessQuery += "where business_id = %s"
        updateBusinessData = (newRating, itemRequest.business_id)
        cursor.execute(updateBusinessQuery, updateBusinessData)
        db.commit()
    except Exception as error:
        print(error)
        raise HTTPException(status_code=404, detail="Failed to Create Record")
        # return {"message": error}
    cursor.close()
    db.close()
    return {"message": "Successfully Created Record"}

@router.delete("/mzansi-directory/business-rating/delete/", tags=["Mzansi Directory"])
async def Delete_loyalty_card(itemRequest : BusinessRatingDeleteRequest, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbAllConnect()
    cursor = db.cursor()
    try:
        # Get No Of reviews for business
        businessReviewCountQuery = "select count(*) from mzansi_directory.business_ratings where business_ratings.business_id = %s"
        countData = (itemRequest.business_id,)
        cursor.execute(businessReviewCountQuery, countData) 
        countResult = cursor.fetchone()
        row_count = countResult[0] if countResult else 0
        print(f"Number of rows in business_ratings: {row_count}")
        # Delete business rating
        query = "delete from mzansi_directory.business_ratings "
        query += "where business_ratings.idbusiness_ratings=%s"
        cursor.execute(query, (str(itemRequest.idbusiness_ratings),)) 
        # Calc New Rating and update business rating 
        if(row_count <= 1):
            newRating = 0.0
        else:
            newRating = ((float(itemRequest.current_rating) * row_count) - float(itemRequest.rating_score)) / (row_count - 1)
        print(f"New Rating: {newRating}")
        updateBusinessQuery = "update app_data.business "
        updateBusinessQuery += "set rating = %s "
        updateBusinessQuery += "where business_id = %s"
        updateBusinessData = (newRating, itemRequest.business_id)
        cursor.execute(updateBusinessQuery, updateBusinessData)
        db.commit()
    except Exception as error:
        print(error)
        raise HTTPException(status_code=404, detail="Failed to Delete Record")
    cursor.close()
    db.close()
    return {"message": "Successfully deleted Record"}

@router.put("/mzansi-directory/business-rating/update/", tags=["Mzansi Directory"])
async def UpdatePatient(itemRequest : BusinessRatingUpdateRequest, session: SessionContainer = Depends(verify_session())):
    db = database.dbConnection.dbMzansiDirectoryConnect()
    cursor = db.cursor()
    nowDateTime = datetime.now()
    formatedDateTime = nowDateTime.strftime("%Y-%m-%d %H:%M:%S")
    try:
        # Get No Of reviews for business
        businessReviewCountQuery = "select count(*) from mzansi_directory.business_ratings where business_ratings.business_id = %s"
        countData = (itemRequest.business_id,)
        cursor.execute(businessReviewCountQuery, countData) 
        countResult = cursor.fetchone()
        row_count = countResult[0] if countResult else 0
        print(f"Number of rows in business_ratings: {row_count}")
        # Update business rating
        query = "update business_ratings "
        query += "set rating_title=%s, rating_description=%s, rating_score=%s, date_time=%s "
        query += "where idbusiness_ratings=%s"
        notetData = (itemRequest.rating_title, 
                    itemRequest.rating_description,
                    itemRequest.rating_new_score,
                    formatedDateTime,
                    itemRequest.idbusiness_ratings,
                    )
        cursor.execute(query, notetData) 
        # Calc New Rating and update business rating
        # add new rating and old rating params
        newRating = ((float(itemRequest.current_rating) * row_count) - float(itemRequest.rating_old_score) + float(itemRequest.rating_new_score)) / (row_count)
        print(f"New Rating: {newRating}")
        updateBusinessQuery = "update app_data.business "
        updateBusinessQuery += "set rating = %s "
        updateBusinessQuery += "where business_id = %s"
        updateBusinessData = (newRating, itemRequest.business_id)
        cursor.execute(updateBusinessQuery, updateBusinessData)
        db.commit()
    except Exception as error:
        raise HTTPException(status_code=404, detail="Failed to Update Record")
    cursor.close()
    db.close()
    return {"message": "Successfully Updated Record"}