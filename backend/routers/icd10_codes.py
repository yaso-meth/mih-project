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
@router.get("/icd10-codes/all", tags=["ICD10 Code"])
async def read_all_icd10_codes(session: SessionContainer = Depends(verify_session())):
    return getICD10CodesData("")

#get all medicines by search
@router.get("/icd10-codes/{search}", tags=["ICD10 Code"])
async def read_icd10_codes_search(search: str, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    return getICD10CodesData(search)

def getICD10CodesData(search: str):
    path = os.getcwd()
    #print(path)
    #parentDir = os.path.abspath(os.path.join(path, os.pardir))
    filePath = os.path.join(path, "ICD10_Codes", "ICD-10_MIT_2021_Excel_16-March_2021.xls")
    print(f'========================= %s ===============================',filePath)
    book = xlrd.open_workbook_xls(filePath)
    sh = book.sheet_by_index(0)
    codeList = []
    for rx in range(1,sh.nrows):
        if(str(sh.cell_value(rx, 7)).strip() != "" 
           and search.lower() in str(sh.cell_value(rx, 7)).strip().lower() 
           or search.lower() in str(sh.cell_value(rx, 8)).strip().lower()):
            codeList.append({
                "icd10": str(sh.cell_value(rx, 7)).strip(),
                "description": str(sh.cell_value(rx, 8)).strip(),
            })
    seen = set()
    codeList_noDuplicates = []
    for d in codeList:
        t = tuple(d.items())
        #print(t[0][1])
        if t not in seen:
            seen.add(t)
            codeList_noDuplicates.append(d)
    return sorted(codeList_noDuplicates, key=lambda d: d['icd10']) #qsort(medlist)
            