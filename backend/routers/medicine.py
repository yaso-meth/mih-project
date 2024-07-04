from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
import os
import xlrd
#from pathlib import Path


router = APIRouter()

class medicine(BaseModel):
    name: str
    unit: str

#get user by email & doc Office ID
@router.get("/users/medicine/all", tags="medicine")
async def read_all_medicine():
    
    return getMedicineData()

def getMedicineData():
    # location = Path(__file__).parent()
    # medFile = (location / 'medicines/Database-Of-Medicine-Prices-31-May-2024.xls').resolve()
    path = os.getcwd()
    parentDir = os.path.abspath(os.path.join(path, os.pardir))
    filePath = os.path.join(path, "backend/medicines", "Database-Of-Medicine-Prices-31-May-2024.xls")
    # print(f"C Path : %s", path)
    # print(f"P Path : %s", parentDir)
    # print(f"F Path : %s", filePath)
    book = xlrd.open_workbook_xls(filePath)
    sh = book.sheet_by_index(0)
    #print("{0} {1} {2}".format(sh.name, sh.nrows, sh.ncols))
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

    #medlist_noDuplicates[:] = [d for d in thelist if d.get('id') != 2]
    

    return sorted(medlist_noDuplicates, key=lambda d: d['name']) #qsort(medlist)
            

def qsort(inlist): 
    if inlist == []:  
        return [] 
    else: 
        pivot = inlist[0] 
        lesser = qsort([x for x in inlist[1:] if x < pivot]) 
        greater = qsort([x for x in inlist[1:] if x >= pivot]) 
        return lesser + [pivot] + greater 