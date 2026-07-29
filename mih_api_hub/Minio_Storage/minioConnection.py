from minio import Minio
import os
from dotenv import load_dotenv

load_dotenv()
minioAccess = os.getenv("MINIO_ACCESS_KEY")
minioSecret = os.getenv("MINIO_SECRET_KEY")
minioEndpoint = os.getenv("MINIO_ENDPOINT", "mih-minio:9000")
minioSecure = os.getenv("MINIO_SECURE", "False") in ("True")

def minioConnect():
        return Minio(
        endpoint=minioEndpoint,
        access_key=minioAccess,
        secret_key=minioSecret,
        secure=minioSecure,
        )
