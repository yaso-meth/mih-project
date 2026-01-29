from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
import os
import xlrd
#SuperToken Auth from front end
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.session import SessionContainer
from fastapi import Depends

router = APIRouter()

#get all medicines
@router.get("/users/medicine/all", tags=["Medicine"])
async def read_all_medicine(session: SessionContainer = Depends(verify_session())):
    return getMedicineData("")

#get all medicines by search
@router.get("/users/medicine/{medSearch}", tags=["Medicine"])
async def read_medicineby_search(medSearch: str, session: SessionContainer = Depends(verify_session())):
    return getMedicineData(medSearch)

def getMedicineData(medsearch: str):
    path = os.getcwd()
    #print(path)
    #parentDir = os.path.abspath(os.path.join(path, os.pardir))
    filePath = os.path.join(path, "medicines", "Database-Of-Medicine-Prices-9-July-2024.xls")
    book = xlrd.open_workbook_xls(filePath)
    sh = book.sheet_by_index(0)
    medlist = []
    for rx in range(1,sh.nrows):
        if(str(sh.cell_value(rx, 6)).strip() != "" and 
           medsearch.lower() in str(sh.cell_value(rx, 6)).strip().lower()):
            medlist.append({
                "name": str(sh.cell_value(rx, 6)).strip(),
                "unit": str(sh.cell_value(rx, 9)).strip(),
                "dosage form": str(sh.cell_value(rx, 10)).strip(),
            })
    seen = set()
    medlist_noDuplicates = []
    for d in medlist:
        t = tuple(d.items())
        #print(t[0][1])
        if t not in seen:
            seen.add(t)
            medlist_noDuplicates.append(d)
    return sorted(medlist_noDuplicates, key=lambda d: d['name']) #qsort(medlist)
            