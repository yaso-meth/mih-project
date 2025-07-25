from fastapi import APIRouter, HTTPException, status
from sqlalchemy import desc 
from sqlalchemy.orm import Session
from pydantic import BaseModel
from datetime import datetime
import mih_database.mihDbConnections
from mih_database.mihDbObjects import User, Business, BusinessRating
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
    dbEngine = mih_database.mihDbConnections.dbAllConnect() 
    dbSession = Session(dbEngine)
    try:
        queryResults = dbSession.query(BusinessRating, User).\
            join(User, BusinessRating.app_id == User.app_id).\
            filter(
                BusinessRating.business_id == business_id,
                BusinessRating.app_id == app_id
            ).first()
        if queryResults:
            rating_obj, user_obj = queryResults
            # Return a single dictionary
            return {
                "idbusiness_ratings": rating_obj.idbusiness_ratings,
                "app_id": rating_obj.app_id,
                "business_id": rating_obj.business_id,
                "rating_title": rating_obj.rating_title,
                "rating_description": rating_obj.rating_description,
                "rating_score": rating_obj.rating_score,
                "date_time": rating_obj.date_time,
                "reviewer": user_obj.username,
            }
        else:
            # Return an empty response or a specific message
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Business rating not found for the given app_id and business_id."
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
    
@router.get("/mzansi-directory/business-ratings/all/{business_id}", tags=["Mzansi Directory"])
async def read_all_ratings_by_business_id(business_id: str, session: SessionContainer = Depends(verify_session())): # , session: SessionContainer = Depends(verify_session())
    dbEngine = mih_database.mihDbConnections.dbAllConnect()
    dbSession = Session(dbEngine)
    try:
        queryResults = dbSession.query(BusinessRating, User).\
            join(User, BusinessRating.app_id == User.app_id).\
            filter(
                BusinessRating.business_id == business_id,
            ).order_by(
                desc(BusinessRating.date_time)
            ).all()
        response_data = []
        for rating_obj, user_obj in queryResults:
           response_data.append({
                "idbusiness_ratings": rating_obj.idbusiness_ratings,
                "app_id": rating_obj.app_id,
                "business_id": rating_obj.business_id,
                "rating_title": rating_obj.rating_title,
                "rating_description": rating_obj.rating_description,
                "rating_score": rating_obj.rating_score,
                "date_time": rating_obj.date_time,
                "reviewer": user_obj.username,
            })
        if len(response_data) > 0:
            return response_data
        else:
            # Return an empty response or a specific message
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Business rating not found for the given business_id."
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

@router.post("/mzansi-directory/business-rating/insert/", tags=["Mzansi Directory"], status_code=201)
async def insert_loyalty_card(itemRequest : BusinessRatingInsertRequest): #, session: SessionContainer = Depends(verify_session())
    dbEngine = mih_database.mihDbConnections.dbAllConnect()
    nowDateTime = datetime.now()
    formatedDateTime = nowDateTime.strftime("%Y-%m-%d %H:%M:%S")
    dbSession = Session(dbEngine)
    try:
        # Get No Of reviews for business
        businessReviewCountQueryResults = dbSession.query(BusinessRating).\
            filter(
                BusinessRating.business_id == itemRequest.business_id,
            ).all()
        businessReviewCount = len(businessReviewCountQueryResults)
        print(f"Number of rows in business_ratings: {businessReviewCount}")
        dbSession.flush()  # Ensure the session is flushed before adding new records
        # add business rating
        new_rating = BusinessRating(
            app_id=itemRequest.app_id,
            business_id=itemRequest.business_id,
            rating_title=itemRequest.rating_title,
            rating_description=itemRequest.rating_description,
            rating_score=itemRequest.rating_score,
            date_time=formatedDateTime
        )
        dbSession.add(new_rating)
        dbSession.flush()  # Ensure the new rating is added to the session
        # Calc New Rating and update business rating 
        newRating = ((float(itemRequest.current_rating) * businessReviewCount) + float(itemRequest.rating_score)) / (businessReviewCount + 1)
        businessToUpdate = dbSession.query(Business).filter(Business.business_id == itemRequest.business_id).first()
        if businessToUpdate:
            businessToUpdate.rating = str(newRating)
            dbSession.commit()
        else:
            # Return an empty response or a specific message
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
                detail="Failed to insert records due to an internal server error."
            )
    finally:
        dbSession.close()
        return {"message": "Successfully Created Record"}

@router.delete("/mzansi-directory/business-rating/delete/", tags=["Mzansi Directory"])
async def Delete_loyalty_card(itemRequest : BusinessRatingDeleteRequest, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    dbEngine = mih_database.mihDbConnections.dbAllConnect()
    dbSession = Session(dbEngine)
    try:
        # Get No Of reviews for business
        businessReviewCountQueryResults = dbSession.query(BusinessRating).\
            filter(
                BusinessRating.business_id == itemRequest.business_id,
            ).all()
        businessReviewCount = len(businessReviewCountQueryResults)
        print(f"Number of rows in business_ratings: {businessReviewCount}")
        dbSession.flush()  # Ensure the session is flushed before adding new records
        # delete business rating
        rating_to_delete = dbSession.query(BusinessRating).\
            get(
                itemRequest.idbusiness_ratings
            )
        if not rating_to_delete:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Business rating with ID {itemRequest.idbusiness_ratings} not found."
            )
        dbSession.delete(rating_to_delete)
        dbSession.flush()  # Ensure the new rating is added to the session
        # Calc New Rating and update business rating 
        if(businessReviewCount <= 1):
            newRating = "0.0"
        else:
            newRating = ((float(itemRequest.current_rating) * businessReviewCount) - float(itemRequest.rating_score)) / (businessReviewCount - 1)
        businessToUpdate = dbSession.query(Business).filter(Business.business_id == itemRequest.business_id).first()
        if businessToUpdate:
            businessToUpdate.rating = str(newRating)
            dbSession.commit()
        else:
            # Return an empty response or a specific message
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
                detail="Failed to insert records due to an internal server error."
            )
    finally:
        dbSession.close()
        return {"message": "Successfully Deleted Record"}

@router.put("/mzansi-directory/business-rating/update/", tags=["Mzansi Directory"])
async def UpdatePatient(itemRequest : BusinessRatingUpdateRequest, session: SessionContainer = Depends(verify_session())):
    dbEngine = mih_database.mihDbConnections.dbAllConnect()
    nowDateTime = datetime.now()
    formatedDateTime = nowDateTime.strftime("%Y-%m-%d %H:%M:%S")
    dbSession = Session(dbEngine)
    try:
        # Get No Of reviews for business
        businessReviewCountQueryResults = dbSession.query(BusinessRating).\
            filter(
                BusinessRating.business_id == itemRequest.business_id,
            ).all()
        businessReviewCount = len(businessReviewCountQueryResults)
        print(f"Number of rows in business_ratings: {businessReviewCount}")
        dbSession.flush()  # Ensure the session is flushed before adding new records
        # Update business rating
        rating_to_update = dbSession.query(BusinessRating).\
            get(
                itemRequest.idbusiness_ratings
            )
        if rating_to_update:
            rating_to_update.rating_title = itemRequest.rating_title
            rating_to_update.rating_description = itemRequest.rating_description
            rating_to_update.rating_score = itemRequest.rating_new_score
            rating_to_update.date_time = formatedDateTime
            dbSession.flush()  # Ensure the new rating is added to the session
        else:
            # Return an empty response or a specific message
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Business not found for the given business_id."
            )
        # Calc New Rating and update business rating 
        newRating = ((float(itemRequest.current_rating) * businessReviewCount) - float(itemRequest.rating_old_score) + float(itemRequest.rating_new_score)) / (businessReviewCount)
        businessToUpdate = dbSession.query(Business).filter(Business.business_id == itemRequest.business_id).first()
        if businessToUpdate:
            businessToUpdate.rating = str(newRating)
            dbSession.commit()
        else:
            # Return an empty response or a specific message
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
                detail="Failed to insert records due to an internal server error."
            )
    finally:
        dbSession.close()
        return {"message": "Successfully wUpdated Record"}