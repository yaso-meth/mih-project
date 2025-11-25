from minio import Minio
import os
from dotenv import load_dotenv

load_dotenv()
minioAccess = os.getenv("MINIO_ACCESS_KEY")
minioSecret = os.getenv("MINIO_SECRET_KEY")

def minioConnect(env):
    if(env == "Dev"):
        return Minio(
        endpoint="minio:9000",
        # "minio.mzansi-innovation-hub.co.za",
        access_key=minioAccess,
        secret_key=minioSecret,
        secure=False
        )
    else:
        return Minio(
        #"minio:9000",
        endpoint="minio.mzansi-innovation-hub.co.za:9000",
        access_key=minioAccess,
        secret_key=minioSecret,
        secure=True
        )