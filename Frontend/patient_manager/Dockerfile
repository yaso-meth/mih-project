# Install Operating system and dependencies
#FROM ubuntu:22.04
FROM debian:latest AS build-env

#ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update --fix-missing

RUN apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback
RUN apt-get install python3 -y
# RUN apt-get update --fix-missing
# RUN apt-get install python3-Jinja2
# download Flutter SDK from Flutter Github repo
RUN git clone -b master https://github.com/flutter/flutter.git /usr/local/flutter
#RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Set flutter environment path
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"
#ENV PATH "$PATH:/home/developer/flutter/bin"

RUN flutter doctor -v

# Enable flutter web
RUN flutter channel master
RUN flutter upgrade
#RUN flutter pub add web:^0.5.0
RUN flutter config --enable-web

# Copy files to container and build
RUN mkdir /app/
COPY . /app/
# COPY ./server/MIH_web_server.py /app/build/web/
# VOLUME ["/app"]


WORKDIR /app
RUN flutter upgrade
RUN flutter build web --release --web-renderer canvaskit -t ./lib/main_prod.dart


# RUN cd ..

# WORKDIR /app/build/web/

EXPOSE 83

RUN ["chmod", "+x", "/app/server/server.sh"]

ENTRYPOINT [ "/app/server/server.sh"]

# RUN ["python3", "-u", "/app/server/MIH_web_server.py"]