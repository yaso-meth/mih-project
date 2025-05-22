from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from datetime import date
#from ..database import dbConnection
import database
#SuperToken Auth from front end
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.session import SessionContainer
from fastapi import Depends

router = APIRouter()

class LoyaltyCardDeleteRequest(BaseModel):
    idloyalty_cards: int

class MzansiWalletInsertRequest(BaseModel):
    app_id: str
    shop_name: str
    card_number: str
    favourite: str
    priority_index: int
    nickname: str

class MzansiWalletUpdateRequest(BaseModel):
    idloyalty_cards: int
    favourite: str
    priority_index: int
# class patientNoteUpdateRequest(BaseModel):
#     idpatient_notes: int
#     note_name: str
#     note_text: str
#     doc_office: str
#     doctor: str
#     patient_id: int

# Get List of all loyalty cards by user
@router.get("/mzasni-wallet/loyalty-cards/{app_id}", tags=["Mzansi Wallet"])
async def read_all_loyalty_cards_by_app_id(app_id: str, session: SessionContainer = Depends(verify_session())): # , session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbMzansiWalletConnect()
    cursor = db.cursor()
    query = "SELECT * FROM loyalty_cards where app_id = %s ORDER BY shop_name Asc"
    cursor.execute(query, (app_id,))
    items = [
        {
            "idloyalty_cards": item[0],
            "app_id": item[1],
            "shop_name": item[2],
            "card_number": item[3],
            "favourite": item[4],
            "priority_index": item[5],
            "nickname": item[6],
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items

# Get List of favourite loyalty cards by user
@router.get("/mzasni-wallet/loyalty-cards/favourites/{app_id}", tags=["Mzansi Wallet"])
async def read_favourite_loyalty_cards_by_app_id(app_id: str, session: SessionContainer = Depends(verify_session())): # , session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbMzansiWalletConnect()
    cursor = db.cursor()
    query = "SELECT * FROM loyalty_cards where app_id = %s and favourite != '' ORDER BY priority_index Asc"
    cursor.execute(query, (app_id,))
    items = [
        {
            "idloyalty_cards": item[0],
            "app_id": item[1],
            "shop_name": item[2],
            "card_number": item[3],
            "favourite": item[4],
            "priority_index": item[5],
            "nickname": item[6],
        }
        for item in cursor.fetchall()
    ]
    cursor.close()
    db.close()
    return items

# Get List of all notes by patient
# @router.get("/notes/patients-docOffice/", tags="patients_notes")
# async def read_all_patientsby(itemRequest: noteRequest, session: SessionContainer = Depends(verify_session())):
#     db = database.dbConnection.dbPatientManagerConnect()
#     cursor = db.cursor()
#     query = "select patient_notes.idpatient_notes, patient_notes.note_name, patient_notes.note_text, patient_notes.patient_id, patient_notes.insert_date, patients.doc_office_id "
#     query += "from patient_manager.patient_notes "
#     query += "inner join patient_manager.patients "
#     query += "on patient_notes.patient_id = patients.idpatients "
#     query += "where patient_notes.patient_id = %s and patients.doc_office_id = %s"
#     cursor.execute(query, (itemRequest.patientID, itemRequest.DocOfficeID,))
#     items = [
#         {
#             "idpatient_notes": item[0],
#             "note_name": item[1],
#             "note_text": item[2],
#             "insert_date": item[3],
#         }
#         for item in cursor.fetchall()
#     ]
#     cursor.close()
#     db.close()
#     return items

# Insert loyalty cards into table
@router.post("/mzasni-wallet/loyalty-cards/insert/", tags=["Mzansi Wallet"], status_code=201)
async def insert_loyalty_card(itemRequest : MzansiWalletInsertRequest): #, session: SessionContainer = Depends(verify_session())
    db = database.dbConnection.dbMzansiWalletConnect()
    cursor = db.cursor()
    query = "insert into loyalty_cards "
    query += "(app_id, shop_name, card_number, favourite, priority_index, nickname) "
    query += "values (%s, %s, %s, %s, %s, %s)"
    notetData = (itemRequest.app_id, 
                   itemRequest.shop_name,
                   itemRequest.card_number,
                     itemRequest.favourite,
                     itemRequest.priority_index,
                     itemRequest.nickname,
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

# Delete loyalty cards on table
@router.delete("/mzasni-wallet/loyalty-cards/delete/", tags=["Mzansi Wallet"])
async def Delete_loyalty_card(itemRequest : LoyaltyCardDeleteRequest, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    # today = date.today()
    db = database.dbConnection.dbMzansiWalletConnect()
    cursor = db.cursor()
    query = "delete from loyalty_cards "
    query += "where idloyalty_cards=%s"
    # notetData = (itemRequest.idpatient_notes)
    try:
       cursor.execute(query, (str(itemRequest.idloyalty_cards),)) 
    except Exception as error:
        print(error)
        raise HTTPException(status_code=404, detail="Failed to Delete Record")
        #return {"query": query, "message": error}
    db.commit()
    cursor.close()
    db.close()
    return {"message": "Successfully deleted Record"}

# Update on table
@router.put("/mzasni-wallet/loyalty-cards/update/", tags=["Mzansi Wallet"])
async def UpdatePatient(itemRequest : MzansiWalletUpdateRequest, session: SessionContainer = Depends(verify_session())):
    today = date.today()
    db = database.dbConnection.dbMzansiWalletConnect()
    cursor = db.cursor()
    query = "update loyalty_cards "
    query += "set favourite=%s, priority_index=%s "
    query += "where idloyalty_cards=%s"
    notetData = (itemRequest.favourite, 
                    itemRequest.priority_index,
                    itemRequest.idloyalty_cards,
                )
    try:
       cursor.execute(query, notetData) 
    except Exception as error:
        raise HTTPException(status_code=404, detail="Failed to Update Record")
        #return {"query": query, "message": error}
    db.commit()
    cursor.close()
    db.close()
    return {"message": "Successfully Updated Record"}