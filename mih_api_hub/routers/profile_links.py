from fastapi import APIRouter, HTTPException, status
from pydantic import BaseModel
from typing import List
#from ..mih_database import dbConnection
import mih_database
import mih_database.mihDbConnections
from mih_database.mihDbObjects import ProfileLink
from sqlalchemy import select, insert, delete, CursorResult
from sqlalchemy.orm import Session
#SuperToken Auth from front end
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.session import SessionContainer

from fastapi import Depends

router = APIRouter()

class ProfileLinkResponse(BaseModel):
    idprofile_links: int
    app_id: str
    business_id: str
    site_name: str
    custom_name: str
    destination: str
    order: int

    class Config:
        from_attributes = True

class profileLinkInsertRequest(BaseModel):
    app_id: str
    business_id: str
    site_name: str
    custom_name: str
    destination: str
    order:int

class profileLinkDeletRequest(BaseModel):
    idprofile_links: int

class profileLinkUpdateRequest(BaseModel):
    idprofile_links: int
    site_name: str
    custom_name: str
    destination: str
    order:int

def get_db():
    dbEngine = mih_database.mihDbConnections.dbAllConnect()
    with Session(dbEngine) as session:
        yield session

@router.get("/profile-links/user/{app_id}", response_model=List[ProfileLinkResponse], tags=["Profile Links"])
async def getUserProfileLinks(
        app_id: str, 
        dbSession: Session = Depends(get_db),
        # session: SessionContainer = Depends(verify_session())
    ):
        
    queryStatement = select(ProfileLink).where(ProfileLink.app_id == app_id).order_by(ProfileLink.order)
    queryResults = dbSession.execute(queryStatement).scalars().all()
    return queryResults

@router.get("/profile-links/business/{business_id}", response_model=List[ProfileLinkResponse], tags=["Profile Links"])
async def getBusinessProfileLinks(
        business_id: str,
        dbSession: Session = Depends(get_db),
        # session: SessionContainer = Depends(verify_session())
    ):
    queryStatement = select(ProfileLink).where(ProfileLink.business_id == business_id).order_by(ProfileLink.order)
    queryResults = dbSession.execute(queryStatement).scalars().all()
    return queryResults

@router.post("/profile-links/insert/", status_code=201, tags = ["Profile Links"])
async def addNewProfileLink(
        insertItem: profileLinkInsertRequest,
        dbSession: Session = Depends(get_db),
        session: SessionContainer = Depends(verify_session())
    ):
    queryStatement = insert(ProfileLink).values(
            app_id = insertItem.app_id,
            business_id = insertItem.business_id,
            site_name = insertItem.site_name,
            custom_name = insertItem.custom_name,
            destination = insertItem.destination,
            order = insertItem.order
            )
    dbSession.execute(queryStatement)
    dbSession.commit()
    return {"message": "Successfully Created Record"}

@router.delete("/profile-links/delete/", tags=["Profile Links"])
async def deleteProfileLink(
        deleteItem: profileLinkDeletRequest, 
        dbSession: Session = Depends(get_db),
        session: SessionContainer = Depends(verify_session())
    ):
    queryStatement = select(ProfileLink).where(ProfileLink.idprofile_links == deleteItem.idprofile_links)
    profileLink = dbSession.execute(queryStatement).scalar_one_or_none()

    if not profileLink:
        raise HTTPException(status_code=404, detail="Record not found")

    dbSession.delete(profileLink)
    dbSession.execute(queryStatement)
    dbSession.commit()
    return {"message": "Successfully Deleted Record"}
    
@router.put("/profile-links/update/", tags=["Profile Links"])
async def updateProfileLink(
        updateItem: profileLinkUpdateRequest, 
        dbSession: Session = Depends(get_db),
        session: SessionContainer = Depends(verify_session())
    ):
    queryStatement = select(ProfileLink).where(ProfileLink.idprofile_links == updateItem.idprofile_links)
    profileLink = dbSession.execute(queryStatement).scalar_one_or_none()
        
    if not profileLink:
        raise HTTPException(status_code=404, detail="Link not found")

    profileLink.site_name = updateItem.site_name
    profileLink.custom_name = updateItem.custom_name
    profileLink.destination = updateItem.destination
    profileLink.order = updateItem.order

    dbSession.commit()
    return {"message": "Successfully Updated Record"}

