from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from .routers import docOffices, patients, patients_files, patients_notes, users

app = FastAPI()
app.include_router(docOffices.router)
app.include_router(patients.router)
app.include_router(patients_files.router)
app.include_router(patients_notes.router)
app.include_router(users.router)

# Check if server is up
@app.get("/")
def read_root():
    return serverRunning()


def serverRunning():
    return {"Status": "Server is Up and Running"}


