from textwrap import wrap
import io
from datetime import datetime, date
from typing import List
import requests

from fastapi import APIRouter, HTTPException, File, UploadFile, Form
from fastapi.responses import FileResponse, JSONResponse

from pydantic import BaseModel

from minio import Minio
import Minio_Storage

from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import A4
from reportlab.lib.utils import ImageReader
from reportlab.platypus import SimpleDocTemplate

from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.session import SessionContainer
from fastapi import Depends

import Minio_Storage.minioConnection


router = APIRouter()

class minioPullRequest(BaseModel):
    file_path: str

class minioDeleteRequest(BaseModel):
    file_path: str
    env: str

class medCertUploud(BaseModel):
    app_id: str
    env: str
    patient_full_name: str
    fileName: str 
    id_no: str 
    docfname: str 
    busName: str 
    busAddr: str 
    busNo: str 
    busEmail: str 
    startDate: str 
    endDate: str 
    returnDate: str 
    logo_path: str
    sig_path: str

class perscription(BaseModel):
    name: str
    unit: str
    form: str
    fullForm: str
    quantity: str
    dosage: str
    times: str
    days: str
    repeats: str

class perscriptionList(BaseModel):
    app_id: str
    env: str
    patient_full_name: str
    fileName: str 
    id_no: str 
    docfname: str 
    busName: str 
    busAddr: str 
    busNo: str 
    busEmail: str  
    logo_path: str
    sig_path: str
    data: List[perscription]

class claimStatementUploud(BaseModel):
    document_type: str 
    patient_app_id: str
    env: str
    patient_full_name: str
    fileName: str 
    patient_id_no: str 
    has_med_aid: str 
    med_aid_no: str 
    med_aid_code: str 
    med_aid_name: str 
    med_aid_scheme: str 
    busName: str 
    busAddr: str 
    busNo: str 
    busEmail: str
    provider_name: str 
    practice_no: str 
    vat_no: str 
    service_date: str 
    service_desc: str 
    service_desc_option: str
    procedure_name: str
    # procedure_date: str
    procedure_additional_info: str
    icd10_code: str
    amount: str
    pre_auth_no: str
    logo_path: str
    sig_path: str

@router.get("/minio/pull/file/{env}/{app_id}/{folder}/{file_name}", tags=["Minio"])
async def pull_File_from_user(app_id: str, folder: str, file_name: str, env: str): #, session: SessionContainer = Depends(verify_session())
    path = app_id + "/" + folder + "/" + file_name
    try:
        # print(f"env: {env}")
        # uploudFile(app_id, file.filename, extension[1], content)
        
        client = Minio_Storage.minioConnection.minioConnect(env)
        buckets = client.list_buckets()
        print("Connected to MinIO successfully!")
        print("Available buckets:", [bucket.name for bucket in buckets]) 
        miniourl = client.presigned_get_object("mih", path)
        print("Generated presigned URL:", miniourl)
        # if(env == "Dev"):
        #     miniourl.replace("minio", "localhost")
        # temp = minioResponse.data#.encode('utf-8').strip()
        # print(temp)
        # print("=======================================================================")
        # temp = temp.decode('utf-8')
        #print(miniourl)
    except Exception as error:
        raise HTTPException(status_code=404, detail=f"MinIO connection failed: {str(error)}")
        # return {"message": error}
    if(env == "Dev"):
        return {
            # 10.0.2.2
            "minioURL": f"http://10.0.2.2:9000/mih/{app_id}/{folder}/{file_name}",#"http://localhost:9000/mih/{app_id}/{folder}/{file_name}",
        }
    else:
        return {
            "minioURL": miniourl,
        }

@router.post("/minio/upload/file/", tags=["Minio"])
async def upload_File_to_user(file: UploadFile = File(...), app_id: str= Form(...), env: str= Form(...), folder: str= Form(...), session: SessionContainer = Depends(verify_session())):
    extension = file.filename.split(".")
    content = file.file 
    try:
        uploudFile(app_id, env, folder, file.filename.replace(" ", "-"), extension[1], content)
    except Exception as error:
        raise HTTPException(status_code=404, detail="Failed to Uploud Record")
    return {"message": f"Successfully Uploaded {file.filename}"}
    
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
        client = Minio_Storage.minioConnection.minioConnect(requestItem.env)
    
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
async def upload_med_cert_to_user(requestItem: medCertUploud, session: SessionContainer = Depends(verify_session())):
    uploudMedCert(requestItem)
    return {"message": "Successfully Generated File"}

@router.post("/minio/generate/perscription/", tags=["Minio"])
async def upload_perscription_to_user(requestItem: perscriptionList, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    uploudPerscription(requestItem)
    return {"message": "Successfully Generated File"}

@router.post("/minio/generate/claim-statement/", tags=["Minio"])
async def upload_perscription_to_user(requestItem: claimStatementUploud, session: SessionContainer = Depends(verify_session())): #, session: SessionContainer = Depends(verify_session())
    uploudClaimStatement(requestItem)
    return {"message": "Successfully Generated File"}

def uploudFile(app_id, env, folder, fileName, extension, content):
    client = Minio_Storage.minioConnection.minioConnect(env)
    found = client.bucket_exists("mih")
    if not found:
        client.make_bucket("mih")
    else:
        print("Bucket already exists")
    fname = app_id + "/" + folder + "/" + fileName
    client.put_object("mih", 
                    fname, 
                    content, 
                    length=-1,
                    part_size=10*1024*1024,
                    content_type=f"application/{extension}")
        
def uploudMedCert(requestItem: medCertUploud):
    client = Minio_Storage.minioConnection.minioConnect(requestItem.env)
    generateMedCertPDF(requestItem)
    today = datetime.today().strftime('%Y-%m-%d')
    found = client.bucket_exists("mih")
    if not found:
        client.make_bucket("mih")
    else:
        print("Bucket already exists")
    fileName = f"{requestItem.app_id}/patient_files/{requestItem.fileName}"
    client.fput_object("mih", fileName, "temp-med-cert.pdf")

def generateMedCertPDF(requestItem: medCertUploud):
    client = Minio_Storage.minioConnection.minioConnect(requestItem.env)
    new_logo_path = requestItem.logo_path.replace(" ","-")
    new_sig_path = requestItem.sig_path.replace(" ","-")
    minioLogo = client.get_object("mih", new_logo_path).read()
    imageLogo = ImageReader(io.BytesIO(minioLogo))
    minioSig = client.get_object("mih", new_sig_path).read()
    imageSig = ImageReader(io.BytesIO(minioSig))
    w,h = A4
    today = datetime.today().strftime('%d-%m-%Y')
    myCanvas = canvas.Canvas("temp-med-cert.pdf", pagesize=A4)

    #Business Logo
    myCanvas.drawImage(imageLogo, 50, h - 125,100,100, mask='auto')

    #Business Details
    myCanvas.setFont('Helvetica-Bold', 10)
    myCanvas.drawRightString(w - 50,h - 40, f"Name: {requestItem.busName}")
    myCanvas.drawRightString(w - 50,h - 55, f"Address: {requestItem.busAddr}")
    myCanvas.drawRightString(w - 50,h - 70, f"Contact No.: {requestItem.busNo}")
    myCanvas.drawRightString(w - 50,h - 85, f"Email: {requestItem.busEmail}")
    myCanvas.line(50,h-150,w-50,h-150)
    #Todays Date
    myCanvas.setFont('Helvetica', 12)
    issueDate =  str(today)
    myCanvas.drawRightString(w - 50,h - 180,issueDate)

    #Title
    myCanvas.setFont('Helvetica-Bold', 20)
    myCanvas.drawString(w-375, h - 200, "Medical Certificate")

    #Body
    myCanvas.setFont('Helvetica', 12)
    body = ""
    body += "This is to certify that " + requestItem.patient_full_name.upper() + " (" + requestItem.id_no+ ") was seen by " + requestItem.docfname.upper() + " on " + requestItem.startDate + "."
    body += "\nHe/She is unfit to attend work/school from " + requestItem.startDate + " up to and including " + requestItem.endDate + "."
    body += "\nHe/She will return on " + requestItem.returnDate + "."
    
    y = 250
    for line in wrap(body, 90):
        myCanvas.drawString(50, h-y, line)
        y += 30
    # myCanvas.drawString(50, h-250,line1)
    # myCanvas.drawString(50, h-280,line2)
    # myCanvas.drawString(50, h-310,line3)

    #Signature
    myCanvas.drawImage(imageSig, 50, h - 690,100,100)
    myCanvas.line(50,h-700,200,h-700)
    myCanvas.drawString(50, h-720, requestItem.docfname.upper())

    #QR Verification
    qrText = requestItem.patient_full_name.upper() + " booked off from " + requestItem.startDate + " to " + requestItem.endDate + " by " + requestItem.docfname.upper() + ".\nPowered by Mzansi Innovation Hub."
    qrText = qrText.replace(" ","+")
    
    url = f"https://api.qrserver.com/v1/create-qr-code/?data={qrText}&size=100x100"
    response = requests.get(url)
    image = ImageReader(io.BytesIO(response.content))
    myCanvas.drawImage(image,w-150, h-700,100,100)

    myCanvas.setFont('Helvetica-Bold', 15)
    myCanvas.drawString(w-150,h-720,"Scan to verify")

    myCanvas.save()

def uploudPerscription(requestItem: perscriptionList):
    client = Minio_Storage.minioConnection.minioConnect(requestItem.env)
    generatePerscriptionPDF(requestItem)
    today = datetime.today().strftime('%Y-%m-%d')
    found = client.bucket_exists("mih")
    if not found:
        client.make_bucket("mih")
    else:
        print("Bucket already exists")
    fileName = f"{requestItem.app_id}/patient_files/{requestItem.fileName}"
    client.fput_object("mih", fileName, "temp-perscription.pdf")    

def generatePerscriptionPDF(requestItem: perscriptionList):
    client = Minio_Storage.minioConnection.minioConnect(requestItem.env)
    new_logo_path = requestItem.logo_path.replace(" ","-")
    new_sig_path = requestItem.sig_path.replace(" ","-")
    minioLogo = client.get_object("mih", new_logo_path).read()
    imageLogo = ImageReader(io.BytesIO(minioLogo))
    minioSig = client.get_object("mih", new_sig_path).read()
    imageSig = ImageReader(io.BytesIO(minioSig))
    w,h = A4
    
    
    myCanvas = canvas.Canvas("temp-perscription.pdf", pagesize=A4)

    #Business Logo
    myCanvas.drawImage(imageLogo, 50, h - 125,100,100, mask='auto')

    #Business Details
    myCanvas.setFont('Helvetica-Bold', 10)
    myCanvas.drawRightString(w - 50,h - 40, f"Name: {requestItem.busName}")
    myCanvas.drawRightString(w - 50,h - 55, f"Address: {requestItem.busAddr}")
    myCanvas.drawRightString(w - 50,h - 70, f"Contact No.: {requestItem.busNo}")
    myCanvas.drawRightString(w - 50,h - 85, f"Email: {requestItem.busEmail}")
    myCanvas.line(50,h-150,w-50,h-150)
    #Todays Date
    myCanvas.setFont('Helvetica', 12)
    today = datetime.today()
    issueDate =  today.strftime('%d-%m-%Y')
    myCanvas.drawRightString(w - 50,h - 180,issueDate)

    #Title
    myCanvas.setFont('Helvetica-Bold', 20)
    myCanvas.drawString(w-375, h - 200, "Perscription")

    #Body
    myCanvas.setFont('Helvetica-Bold', 12)
    myCanvas.drawString(50, h-250, f"Patient: {requestItem.patient_full_name}")
    myCanvas.drawString(50, h-270, f"Patient ID: {requestItem.id_no}")
    
    #boday headings 
    myCanvas.drawString(50, h-300, "Description")
    myCanvas.drawRightString(w - 50, h-300, "Repeat(s)")
    myCanvas.drawRightString(w - 150, h-300, "Quantity")
    myCanvas.line(50,h-310,w-50,h-310)

    myCanvas.setStrokeColorRGB(0.749, 0.749, 0.749)
    myCanvas.setFont('Helvetica', 12)
    y = 330
    i = 0
    for persc in requestItem.data:
        description1 = f"{persc.name} - {persc.form}"
        description2 = f"{persc.dosage} {persc.fullForm}, {persc.times} time(s) daily, for {persc.days} day(s)"
        quant = f"{persc.quantity}"
        reps = f"{persc.repeats}"

        myCanvas.drawString(50, h-y, f"{i+1}.")
        myCanvas.drawString(60, h-y, description1)
        myCanvas.drawRightString(w-75, h-y, reps)
        myCanvas.drawRightString(w-175, h-y, quant)
        y+=15
        myCanvas.drawString(60, h-y, description2)
        if(i<len(requestItem.data)-1):
            y+=10
            myCanvas.line(50,h-y,w-50,h-y)
        y += 20
        i+=1
    myCanvas.setStrokeColorRGB(0,0,0)
    myCanvas.line(50,h-y-10,w-50,h-y-10)


    #Signature
    y=750
    myCanvas.drawImage(imageSig, 50, h-y,100,100)
    myCanvas.line(50,h-y-10,200,h-y-10)
    myCanvas.drawString(50, h-y-30, requestItem.docfname.upper())

    #QR Verification
    qrText = f"Perscription generated on {issueDate} by {requestItem.docfname} for {requestItem.patient_full_name}.\nPowered by Mzansi Innovation Hub."
    qrText = qrText.replace(" ","+")
    
    url = f"https://api.qrserver.com/v1/create-qr-code/?data={qrText}&size=100x100"
    response = requests.get(url)
    image = ImageReader(io.BytesIO(response.content))
    myCanvas.drawImage(image,w-150, h-y-10,100,100)

    myCanvas.setFont('Helvetica-Bold', 15)
    myCanvas.drawString(w-150,h-y-30,"Scan to verify")

    myCanvas.save()

def uploudClaimStatement(requestItem: claimStatementUploud):
    try:
        client = Minio_Storage.minioConnection.minioConnect(requestItem.env)
        print("connected")
    except Exception:
        print("error")
    
    generateClaimStatementPDF(requestItem)
    today = datetime.today().strftime('%Y-%m-%d')
    found = client.bucket_exists("mih")
    if not found:
        client.make_bucket("mih")
    else:
        print("Bucket already exists")
    fileName = f"{requestItem.patient_app_id}/claims-statements/{requestItem.fileName}"
    client.fput_object("mih", fileName, "temp-claim-statement.pdf")    

def generateClaimStatementPDF(requestItem: claimStatementUploud):
    client = Minio_Storage.minioConnection.minioConnect(requestItem.env)
    # print("buckets: " + client.list_buckets)
    new_logo_path = requestItem.logo_path.replace(" ","-")
    new_sig_path = requestItem.sig_path.replace(" ","-")
    print("Path Logo: " + new_logo_path)
    minioLogo = client.get_object("mih", new_logo_path).read()
    imageLogo = ImageReader(io.BytesIO(minioLogo))
    minioSig = client.get_object("mih", new_sig_path).read()
    imageSig = ImageReader(io.BytesIO(minioSig))
    w,h = A4
    
    
    myCanvas = canvas.Canvas("temp-claim-statement.pdf", pagesize=A4)

    #Business Logo
    myCanvas.drawImage(imageLogo, 50, h - 125,100,100, mask='auto')

    #Business Details
    myCanvas.setFont('Helvetica-Bold', 10)
    myCanvas.drawRightString(w - 50,h - 40, f"Name: {requestItem.busName}")
    myCanvas.drawRightString(w - 50,h - 55, f"Address: {requestItem.busAddr}")
    myCanvas.drawRightString(w - 50,h - 70, f"Practice No.: {requestItem.practice_no}")
    myCanvas.drawRightString(w - 50,h - 85, f"Contact No.: {requestItem.busNo}")
    myCanvas.drawRightString(w - 50,h - 100, f"Email: {requestItem.busEmail}")
    myCanvas.line(50,h-150,w-50,h-150)
    #Todays Date
    myCanvas.setFont('Helvetica-Bold', 12)
    today = datetime.today()
    issueDate =  today.strftime('%d-%m-%Y')
    myCanvas.drawRightString(w - 50,h - 180,f"{issueDate}")

    #Title
    myCanvas.setFont('Helvetica-Bold', 20)
    myCanvas.drawString(w-340, h - 200, requestItem.document_type)

    #Body
    # Patient Details
    myCanvas.setFont('Helvetica-Bold', 14)
    myCanvas.drawString(50, h-230, "Patient Details")
    myCanvas.line(50,h-235,w-50,h-235)

    medAidNo = ""
    medAidCode = ""
    medAidNameAndScheme = ""
    if(requestItem.has_med_aid == "Yes"):
        medAidNo = requestItem.med_aid_no
        medAidCode = requestItem.med_aid_code
        medAidNameAndScheme = f"{requestItem.med_aid_name} - {requestItem.med_aid_scheme}"
    else:
        medAidNo = "n/a"
        medAidCode = "n/a"
        medAidNameAndScheme = "n/a"
    preAuthNo = requestItem.pre_auth_no
    if(preAuthNo == ""):
        preAuthNo = "n/a"
    # category
    myCanvas.setFont('Helvetica-Bold', 12)
    myCanvas.drawString(50, h-250, f"Patient Name:")
    myCanvas.drawString(50, h-265, f"Patient ID:")
    myCanvas.drawString(50, h-280, f"Medical Aid No.:")
    myCanvas.drawString(50, h-295, f"Medical Aid Code:")
    myCanvas.drawString(50, h-310, f"Medical Aid Scheme:")
    myCanvas.drawString(50, h-325, f"Pre-Authorisation No:")
    # content
    myCanvas.setFont('Helvetica', 12)
    myCanvas.drawString(225, h-250, f"{requestItem.patient_full_name}")
    myCanvas.drawString(225, h-265, f"{requestItem.patient_id_no}")
    myCanvas.drawString(225, h-280, f"{medAidNo}")
    myCanvas.drawString(225, h-295, f"{medAidCode}")
    myCanvas.drawString(225, h-310, f"{medAidNameAndScheme}")
    myCanvas.drawString(225, h-325, f"{preAuthNo}")
    #===============================================================================
    # Provide Details
    myCanvas.setFont('Helvetica-Bold', 14)
    myCanvas.drawString(50, h-355, "Provider Details")
    myCanvas.line(50,h-360,w-50,h-360)
    
    myCanvas.setFont('Helvetica-Bold', 12)
    myCanvas.drawString(50, h-375, f"Practice Name:")
    myCanvas.drawString(50, h-390, f"Practice No.:")
    myCanvas.drawString(50, h-405, f"Vat No.:")
    myCanvas.drawString(50, h-420, f"Provider Name:")

    myCanvas.setFont('Helvetica', 12)
    myCanvas.drawString(225, h-375, f"{requestItem.busName}")
    myCanvas.drawString(225, h-390, f"{requestItem.practice_no}")
    myCanvas.drawString(225, h-405, f"{requestItem.vat_no}")
    myCanvas.drawString(225, h-420, f"{requestItem.provider_name}")

    #===============================================================================
    # Service Details
    myCanvas.setFont('Helvetica-Bold', 14)
    myCanvas.drawString(50, h-450, "Service Details")
    # myCanvas.drawRightString(w - 50, h-300, "Repeat(s)")
    myCanvas.drawRightString(w - 70, h-450, "Amount")
    myCanvas.line(50,h-455,w-50,h-455)

    myCanvas.setFont('Helvetica-Bold', 12)
    myCanvas.drawString(50, h-470, f"Service Type:")
    myCanvas.drawString(50, h-485, f"Service Date:")

    myCanvas.setFont('Helvetica', 12)
    myCanvas.drawString(225, h-470, f"{requestItem.service_desc}")
    displayAmount = ""
    if("." in requestItem.amount or "," in requestItem.amount):
        displayAmount = requestItem.amount.replace(",",".")
    else:
        displayAmount = requestItem.amount + ".00"
    myCanvas.drawRightString(w - 80, h-470, displayAmount)
    myCanvas.drawString(225, h-485, f"{requestItem.service_date}")
    y = 0
    if(requestItem.service_desc == "Precedure"):
        myCanvas.setFont('Helvetica-Bold', 12)
        myCanvas.drawString(50, h-500, f"Procedure Name:")
        myCanvas.drawString(50, h-515, f"Additional Info:")
        myCanvas.drawString(50, h-530, f"ICD-10 Code & Description:")

        myCanvas.setFont('Helvetica', 12)
        myCanvas.drawString(225, h-500, f"{requestItem.procedure_name}")
        myCanvas.drawString(225, h-515, f"{requestItem.procedure_additional_info}")
        y = 530
        for line in wrap(requestItem.icd10_code, 45):
            myCanvas.drawString(225, h-y, f"{line}")
            y+=15
        myCanvas.line(50,h-y,w-50,h-y)
    else:
        myCanvas.setFont('Helvetica-Bold', 12)
        myCanvas.drawString(50, h-500, f"Service Description:")
        myCanvas.drawString(50, h-515, f"ICD-10 Code & Description:")

        myCanvas.setFont('Helvetica', 12)
        myCanvas.drawString(225, h-500, f"{requestItem.service_desc_option}")
        y = 515
        for line in wrap(requestItem.icd10_code, 45):
            myCanvas.drawString(225, h-y, f"{line}")
            y+=15
        # myCanvas.drawString(225, h-515, f"{requestItem.icd10_code}")
        myCanvas.line(50,h-y,w-50,h-y)
    #===============================================================================

    #Signature
    y=750
    myCanvas.drawImage(imageSig, 50, h-y,100,100)
    myCanvas.line(50,h-y-10,200,h-y-10)
    myCanvas.drawString(50, h-y-30, requestItem.provider_name.upper())

    #QR Verification
    qrText = f"{requestItem.document_type} generated on {issueDate} by {requestItem.busName} for {requestItem.patient_full_name}.\nPowered by Mzansi Innovation Hub."
    qrText = qrText.replace(" ","+")
    
    url = f"https://api.qrserver.com/v1/create-qr-code/?data={qrText}&size=100x100"
    response = requests.get(url)
    image = ImageReader(io.BytesIO(response.content))
    myCanvas.drawImage(image,w-150, h-y-10,100,100)

    myCanvas.setFont('Helvetica-Bold', 15)
    myCanvas.drawString(w-150,h-y-30,"Scan to verify")

    myCanvas.save()
