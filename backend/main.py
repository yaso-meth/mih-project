from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from .routers import docOffices, patients, patients_files, patients_notes, users, fileStorage, medicine
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware import Middleware

origins = [
    "http://localhost",
    "http://localhost:80",
    "http://localhost:8080",
    "http://MIH-API-Hub:80",
    "http://MIH-API-Hub",
    "http://mzansi-innovation-hub.co.za",
    "*",
]

middleware = [
    Middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
    )
]

app = FastAPI(middleware=middleware)
app.include_router(docOffices.router)
app.include_router(patients.router)
app.include_router(patients_files.router)
app.include_router(patients_notes.router)
app.include_router(users.router)
app.include_router(fileStorage.router)
app.include_router(medicine.router)


# Check if server is up
@app.get("/")
def read_root():
    return serverRunning()


def serverRunning():
    return {"Status": "Server is Up and Running"}


