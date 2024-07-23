from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from .routers import docOffices, patients, patients_files, patients_notes, users, fileStorage, medicine
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware import Middleware
from supertokens_python import get_all_cors_headers
from supertokens_python.framework.fastapi import get_middleware
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.session import SessionContainer
from fastapi import Depends

from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.thirdparty.asyncio import (
    get_user_by_id as get_user_by_id_thirdparty,
)
from supertokens_python.recipe.passwordless.asyncio import (
    get_user_by_id as get_user_by_id_passwordless,
)

origins = [
    "http://localhost",
    "http://localhost:80",
    "http://localhost:8080",
    "http://MIH-API-Hub:80",
    "http://MIH-API-Hub",
    "http://mzansi-innovation-hub.co.za",
    "*",
]

# middleware = [
#     Middleware(
#     CORSMiddleware,
#     allow_origins=origins,
#     allow_credentials=True,
#     allow_methods=["GET", "PUT", "POST", "DELETE", "OPTIONS", "PATCH"],
#     allow_headers=["Content-Type"] + get_all_cors_headers(),
#     )
# ]

app = FastAPI()#middleware=middleware)
app.add_middleware(get_middleware())
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["GET", "PUT", "POST", "DELETE", "OPTIONS", "PATCH"],
    allow_headers=["Content-Type"] + get_all_cors_headers()
)
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

# Check if server is up
@app.get("/session")
def read_root():
    async def like_comment(session: SessionContainer = Depends(verify_session())):
        user_id = session.get_user_id()

        return {"Session id": user_id}

@app.post('/get_user_info_api') 
async def get_user_info_api(session: SessionContainer = Depends(verify_session())):
    user_id = session.get_user_id()

    thirdparty_user = await get_user_by_id_thirdparty(user_id)
    if thirdparty_user is None:
        passwordless_user = await get_user_by_id_passwordless(user_id)
        if passwordless_user is not None:
            print(passwordless_user)
    else:
        print(thirdparty_user)

def serverRunning():
    return {"Status": "Server is Up and Running"}


