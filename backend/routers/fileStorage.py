from fastapi import APIRouter, HTTPException, File, UploadFile, Form
import requests
from pydantic import BaseModel
from minio import Minio
import Minio_Storage
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import A4
from reportlab.lib.utils import ImageReader
import io
from datetime import datetime
#SuperToken Auth from front end
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.session import SessionContainer
from fastapi import Depends

import Minio_Storage.minioConnection


router = APIRouter()

class minioDeleteRequest(BaseModel):
    file_path: str

class medCertUploud(BaseModel):
    app_id: str
    fullName: str 
    docfname: str 
    startDate: str 
    endDate: str 
    returnDate: str 

@router.post("/minio/upload/file/", tags=["Minio"])
async def upload_File_to_user(file: UploadFile = File(...), app_id: str= Form(...)):
    extension = file.filename.split(".")
    content = file.file 
    try:
        uploudFile(app_id, file.filename, extension[1], content)
    except Exception as error:
        raise HTTPException(status_code=404, detail="Failed to Uploud Record")
    return {"message": "Successfully Delete File"}
    
    # return {
    #     "app_id": app_id,
    #     "file name": file.filename,
    #     "extension": extension[0],
    #     "file contents": file.file.read(),
    # }

@router.delete("/minio/delete/file/", tags=["Minio"])
async def delete_File_of_user(requestItem: minioDeleteRequest, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    path = requestItem.file_path
    try:
        # uploudFile(app_id, file.filename, extension[1], content)
        client = Minio_Storage.minioConnection.minioConnect()
    
        minioError = client.remove_object("mih", path)
    except Exception as error:
        raise HTTPException(status_code=404, detail=minioError)
        # return {"message": error}
    return {"message": "Successfully deleted File"}
    # return {
    #     "app_id": app_id,
    #     "file name": file.filename,
    #     "extension": extension[0],
    #     "file contents": file.file.read(),
    # }



# Get List of all files by patient
@router.post("/minio/generate/med-cert/", tags=["Minio"])
async def upload_File_to_user(requestItem: medCertUploud, session: SessionContainer = Depends(verify_session())):
    uploudMedCert(requestItem.app_id,
                requestItem.fullName, 
               requestItem.docfname,
               requestItem.startDate,
               requestItem.endDate,
               requestItem.returnDate)
    return {"message": "Successfully Generated File"}
    
def uploudFile(app_id, fileName, extension, content):
    client = Minio_Storage.minioConnection.minioConnect()
    found = client.bucket_exists("mih")
    if not found:
        client.make_bucket("mih")
    else:
        print("Bucket already exists")
    fname = app_id + "/" + fileName
    client.put_object("mih", 
                    fname, 
                    content, 
                    length=-1,
                    part_size=10*1024*1024,
                    content_type=f"application/{extension}")
        


#"minio""localhost:9000"
def uploudMedCert(app_id, fullName, docfname, startDate, endDate, returnDate):
    client = Minio_Storage.minioConnection.minioConnect()
    generateMedCertPDF(fullName, docfname, startDate, endDate, returnDate)
    found = client.bucket_exists("mih")
    if not found:
        client.make_bucket("mih")
    else:
        print("Bucket already exists")
    fileName = f"{app_id}/Med-Cert-{fullName}-{startDate}.pdf"
    client.fput_object("mih", fileName, "temp.pdf")

def generateMedCertPDF(fullName, docfname, startDate, endDate, returnDate):
    w,h = A4
    today = datetime.today().strftime('%d-%m-%Y')
    myCanvas = canvas.Canvas("temp.pdf", pagesize=A4)
    myCanvas.setFont('Helvetica', 12)
    myCanvas.drawString(w - 100,h - 50,today)

    myCanvas.setFont('Helvetica-Bold', 20)
    myCanvas.drawString(w-375, h - 100, "Medical Certificate")

    myCanvas.setFont('Helvetica', 12)
    line1 = "This is to certify that " + fullName.upper() + " was seen by " + docfname.upper() + " on " + startDate + "."
    line2 = "He/She is unfit to attend work/school from " + startDate + " up to and including " + endDate + "."
    line3 = "He/She will return on " + returnDate + "."
    myCanvas.drawString(50, h-150,line1)
    myCanvas.drawString(50, h-180,line2)
    myCanvas.drawString(50, h-210,line3)

    myCanvas.line(50,h-430,200,h-430)
    myCanvas.drawString(50, h-450, docfname.upper())

    qrText = fullName.upper() + " booked off from " + startDate + " to " + endDate + " by " + docfname.upper() + ".\nPowered by Mzansi Innovation Hub."
    qrText = qrText.replace(" ","+")
    
    url = f"https://api.qrserver.com/v1/create-qr-code/?data={qrText}&size=100x100"
    response = requests.get(url)
    image = ImageReader(io.BytesIO(response.content))
    myCanvas.drawImage(image,50, h-700,100,100)

    myCanvas.setFont('Helvetica-Bold', 15)
    myCanvas.drawString(50,h-720,"Scan to verify")

    myCanvas.save()
    
#Def get
#uploudFile("Yasien Meth","Dr D Oct","18-06-2024","20-06-2024","21-06-2024")

def byteToMb(size):
    sizekb = size /1000
    sizemb = sizekb / 1000
    return sizemb

# print(byteToMb(229574))