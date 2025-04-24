from minio import Minio

def minioConnect(env):
    # if(env == "Dev"):
        return Minio(
        "minio:9000",
        # "minio.mzansi-innovation-hub.co.za",
        access_key="0RcgutfvcDq28lz7",
        secret_key="nEED72ZlKYgDqH9Iy46fVGGT9TfabGWO",
        secure=False
        )
    # else:
    #     return Minio(
    #     #"minio:9000",
    #     "minio.mzansi-innovation-hub.co.za",
    #     access_key="0RcgutfvcDq28lz7",
    #     secret_key="nEED72ZlKYgDqH9Iy46fVGGT9TfabGWO",
    #     secure=True
    #     )