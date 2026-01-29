from fastapi import APIRouter, HTTPException, status
from pydantic import BaseModel
#from ..mih_database import dbConnection
import mih_database
import mih_database.mihDbConnections
from mih_database.mihDbObjects import UserConsent
from sqlalchemy import desc, or_
from sqlalchemy.orm import Session
from sqlalchemy.sql import func
from sqlalchemy.exc import IntegrityError, SQLAlchemyError
#SuperToken Auth from front end
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.session import SessionContainer
from fastapi import Depends
from datetime import datetime
import uuid

router = APIRouter()

class userConsentInsertRequest(BaseModel):
    app_id: str
    privacy_policy_accepted: datetime
    terms_of_services_accepted: datetime

class userConsentUpdateRequest(BaseModel):
    app_id: str
    privacy_policy_accepted: datetime
    terms_of_services_accepted: datetime

@router.get("/user-consent/user/{app_id}", tags=["User Consent"])
async def get_user_consent(app_id: str, session: SessionContainer = Depends(verify_session())):
    dbEngine = mih_database.mihDbConnections.dbAllConnect()
    dbSession = Session(dbEngine)
    try:
        queryResults = dbSession.query(UserConsent).\
        filter(UserConsent.app_id == app_id).\
        first()
        if queryResults:
            return {
                "idUserConsent": queryResults.iduser_consent,
                "app_id": queryResults.app_id,
                "privacy_policy_accepted": queryResults.privacy_policy_accepted,
                "terms_of_services_accepted": queryResults.terms_of_services_accepted
            }
        else:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User Consent not found")
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

@router.post("/user-consent/insert/",
             tags=["User Consent"],
             status_code=status.HTTP_201_CREATED)
async def insert_user_consent(itemRequest: userConsentInsertRequest,
                              session: SessionContainer = Depends(verify_session())):
    dbEngine = mih_database.mihDbConnections.dbAllConnect()
    dbSession = Session(dbEngine)
    try:
        newUserConsent = UserConsent(
            app_id = itemRequest.app_id,
            privacy_policy_accepted = itemRequest.privacy_policy_accepted,
            terms_of_services_accepted = itemRequest.terms_of_services_accepted,
        )
        dbSession.add(newUserConsent)
        dbSession.commit()
        dbSession.refresh(newUserConsent)
        return {"message": "Successfully Created file Record"}
    except IntegrityError as e:
        dbSession.rollback()
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT, # 409 Conflict is often suitable for constraint errors
            detail=f"Data integrity error: The provided data violates a database constraint. Details: {e.orig}"
        ) from e
    except SQLAlchemyError as e:
        dbSession.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"A database error occurred during insertion. Details: {e.orig}"
        ) from e
    except Exception as e:
        dbSession.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"An unexpected error occurred: {e}"
        ) from e
    finally:
        dbSession.close()

@router.put("/user-consent/update/", tags=["User Consent"])
async def update_user_consent(itemRequest: userConsentUpdateRequest,
                                session: SessionContainer = Depends(verify_session())):
        dbEngine = mih_database.mihDbConnections.dbAllConnect()
        dbSession = Session(dbEngine)
        # pp_accepted_dt = datetime.strptime(itemRequest.privacy_policy_accepted, "%Y-%m-%d %H:%M:%S")
        # tos_accepted_dt = datetime.strptime(itemRequest.terms_of_services_accepted, "%Y-%m-%d %H:%M:%S")
        try:
            existing_consent = dbSession.query(UserConsent).filter(UserConsent.app_id == itemRequest.app_id).first()
            if not existing_consent:
                raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User Consent not found")
            
            existing_consent.privacy_policy_accepted = itemRequest.privacy_policy_accepted
            existing_consent.terms_of_services_accepted = itemRequest.terms_of_services_accepted
            
            dbSession.commit()
            return {"message": "Successfully Updated User Consent Record"}
        except HTTPException as http_exc:
            # Re-raise HTTPException directly if it was raised within the try block
            raise http_exc
        except IntegrityError as e:
            dbSession.rollback()
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail=f"Data integrity error: The provided data violates a database constraint. Details: {e.orig}"
            ) from e
        except SQLAlchemyError as e:
            dbSession.rollback()
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"A database error occurred during update. Details: {e.orig}"
            ) from e
        except Exception as e:
            dbSession.rollback()
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"An unexpected error occurred: {e}"
            ) from e
        finally:
            dbSession.close()