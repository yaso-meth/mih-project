from fastapi import FastAPI, Depends, HTTPException
from pydantic import BaseModel
# from .routers import docOffices, patients, patients_files, patients_notes, users, fileStorage, medicine
import routers.docOffices as docOffices
import routers.appointments as appointments
import routers.patients as patients
import routers.patients_files as patients_files
import routers.patients_notes as patients_notes
import routers.patients_queue as patients_queue
import routers.claim_statement_files as claim_statement_files
import routers.users as users
import routers.notifications as notifications
import routers.fileStorage as fileStorage
import routers.medicine as medicine
import routers.business_user as business_user
import routers.business as business
import routers.access_request as access_request
import routers.patient_access as patient_access
import routers.mzansi_wallet as mzansi_wallet
import routers.mzansi_directory as mzansi_directory
import routers.user_consent as user_consent
import routers.icd10_codes as icd10_codes
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware import Middleware
from supertokens_python import get_all_cors_headers
from supertokens_python.framework.fastapi import get_middleware

from supertokens_python import init, InputAppInfo, SupertokensConfig
from supertokens_python.recipe import emailpassword, session, dashboard, emailverification


from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.emailverification import EmailVerificationClaim
from supertokens_python.recipe.session import SessionContainer

origins = [
    "http://localhost",
    "http://localhost:80",
    "http://localhost:8080",
    "http://MIH-API-Hub:80",
    "http://MIH-API-Hub",
    "http://api.mzansi-innovation-hub.co.za",
    "*",
]

init(
    app_info=InputAppInfo(
        app_name="Mzansi Innovation Hub",
        api_domain="http://localhost:8080/",
        website_domain="http://app.mzansi-innovation-hub.co.za",
        api_base_path="/auth",
        website_base_path="/auth"
    ),
    supertokens_config=SupertokensConfig(
        # https://try.supertokens.com is for demo purposes. Replace this with the address of your core instance (sign up on supertokens.com), or self host a core.
        connection_uri="http://MIH-SuperTokens:3567/",
        api_key="leatucczyixqwkqqdrhayiwzeofkltds"
    ),
    framework='fastapi',
    recipe_list=[
        # SuperTokens.init(),
        session.init(), # initializes session features
        emailpassword.init(),
        # emailverification.init(mode='REQUIRED'),
        dashboard.init(admins=[
            "yasienmeth@gmail.com",
          ],
        )
    ],
    mode='wsgi' # use wsgi instead of asgi if you are running using gunicorn
)

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
app.include_router(patients_queue.router)
app.include_router(access_request.router)
app.include_router(patient_access.router)
app.include_router(users.router)
app.include_router(fileStorage.router)
app.include_router(claim_statement_files.router)
app.include_router(medicine.router)
app.include_router(business_user.router)
app.include_router(business.router)
app.include_router(notifications.router)
app.include_router(mzansi_wallet.router)
app.include_router(mzansi_directory.router)
app.include_router(user_consent.router)
app.include_router(icd10_codes.router)
app.include_router(appointments.router)

# Check if server is up
@app.get("/", tags=["Server Check"])
def check_server():
    return serverRunning()

# # Check if server is up
# @app.get("/session")
# def read_root():
#     async def like_comment(session: SessionContainer = Depends(verify_session())):
#         user_id = session.get_user_id()

#         return {"Session id": user_id}

# @app.post('/get_user_info_api') 
# async def get_user_info_api(session: SessionContainer = Depends(verify_session())):
#     user_id = session.get_user_id()

#     thirdparty_user = await get_user_by_id_thirdparty(user_id)
#     if thirdparty_user is None:
#         passwordless_user = await get_user_by_id_passwordless(user_id)
#         if passwordless_user is not None:
#             print(passwordless_user)
#     else:
#         print(thirdparty_user)

def serverRunning():
    return {"Status": "Server is Up and Running. whats good in the hood"}


