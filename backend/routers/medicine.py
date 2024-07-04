from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
import os
import xlrd


router = APIRouter()

class medicine(BaseModel):
    name: str
    unit: str

#get user by email & doc Office ID
@router.get("/users/medicine/all", tags="medicine")
async def read_all_medicine():
    
    return getMedicineData()

def getMedicineData():
    path = os.getcwd()
    parentDir = os.path.abspath(os.path.join(path, os.pardir))
    filePath = os.path.join(path, "backend/medicines", "Database-Of-Medicine-Prices-31-May-2024.xls")
    book = xlrd.open_workbook_xls(filePath)
    sh = book.sheet_by_index(0)
    medlist = []
    for rx in range(1,sh.nrows):
        if(str(sh.cell_value(rx, 6)).strip() != ""):
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
            