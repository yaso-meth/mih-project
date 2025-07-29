FROM tiangolo/uvicorn-gunicorn-fastapi:latest AS builder
# FROM tiangolo/uvicorn-gunicorn-fastapi:python3.11-slim AS builder

WORKDIR /app

COPY requirements.txt ./
RUN --mount=type=cache,target=/root/.cache/pip \
    pip --default-timeout=120 install -r requirements.txt

# COPY . ./app

# FROM builder as dev-envs

# RUN <<EOF
# apt-get update
# apt-get install -y --no-install-recommends git
# EOF

# RUN <<EOF
# useradd -s /bin/bash -m vscode
# groupadd docker
# usermod -aG docker vscode
# EOF
# # install Docker tools (cli, buildx, compose)
# COPY --from=gloursdocker/docker / /

# FROM python:3.12-slim

# WORKDIR /app

# COPY ./requirements.txt ./

# RUN pip3 install --no-cache-dir -r requirements.txt