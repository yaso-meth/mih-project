from fastapi import APIRouter, HTTPException
import requests
from pydantic import BaseModel
from minio import Minio
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import A4
from reportlab.lib.utils import ImageReader
import io
from datetime import datetime
#from minioConnect import minioConnection


router = APIRouter()

class fileUploud(BaseModel):
    fullName: str 
    docfname: str 
    startDate: str 
    endDate: str 
    returnDate: str 

# Get List of all files by patient
@router.post("/files/generate/", tags="patients_files")
async def read_all_files_by_patient(requestItem: fileUploud):
    uploudFile(requestItem.fullName, 
               requestItem.docfname,
               requestItem.startDate,
               requestItem.endDate,
               requestItem.returnDate)
    return {"message": "Successfully Generated File"}

w,h = A4
#"minio""localhost:9000"
def uploudFile(fullName, docfname, startDate, endDate, returnDate):
    client = Minio("minio:9000",   
    access_key="user1",
    secret_key="C@rtoon1995",
    secure=False
    )
    generateMedCertPDF(fullName, docfname, startDate, endDate, returnDate)
    found = client.bucket_exists("mih")
    if not found:
       client.make_bucket("mih")
    else:
       print("Bucket already exists")
    fileName = f"Med-Cert-{fullName}-{startDate}.pdf"
    client.fput_object("mih", fileName, "temp.pdf")

def generateMedCertPDF(fullName, docfname, startDate, endDate, returnDate):
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