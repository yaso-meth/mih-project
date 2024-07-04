from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from .routers import docOffices, patients, patients_files, patients_notes, users, fileStorage, medicine
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()
app.include_router(docOffices.router)
app.include_router(patients.router)
app.include_router(patients_files.router)
app.include_router(patients_notes.router)
app.include_router(users.router)
app.include_router(fileStorage.router)
app.include_router(medicine.router)

origins = [
    "http://localhost",
    "http://localhost:80",
    "api",
    "*"
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Check if server is up
@app.get("/")
def read_root():
    return serverRunning()


def serverRunning():
    return {"Status": "Server is Up and Running"}


