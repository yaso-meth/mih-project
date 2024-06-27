# Install Operating system and dependencies
#FROM ubuntu:22.04
FROM debian:latest AS build-env

#ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
#RUN apt-get upgrade -y
#RUN apt-get --fix-missing update
RUN apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback python3
#RUN apt-get install -y curl git unzip
#RUN apt-get install -y curl git unzip xz-utils zip libglu1-mesa
#RUN apt-get install -y curl git unzip wget python3 fonts-droid-fallback
#RUN apt-get clean

#ENV DEBIAN_FRONTEND=dialog
#ENV PUB_HOSTED_URL=https://pub.flutter-io.cn
#ENV FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

# download Flutter SDK from Flutter Github repo
RUN git clone -b master https://github.com/flutter/flutter.git /usr/local/flutter
#RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Set flutter environment path
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"
#ENV PATH "$PATH:/home/developer/flutter/bin"

# Run flutter doctor
#RUN flutter pub get
#RUN rmdir /usr/local/flutter/bin/cache
#RUN flutter pub cache repair
#RUN dart pub add args:^2.4.2
#RUN flutter dart pub add args:^2.4.2
RUN flutter doctor -v

# Enable flutter web
RUN flutter channel master
RUN flutter upgrade
#RUN flutter pub add web:^0.5.0
RUN flutter config --enable-web

# Copy files to container and build
RUN mkdir /app/
COPY . /app/
WORKDIR /app/
# RUN flutter pub add web:^0.5.0
# RUN flutter pub run pdfx:install_web
RUN flutter upgrade
RUN flutter build web

# Record the exposed port
EXPOSE 8080

# make server startup script executable and start the web server
RUN ["chmod", "+x", "/app/server/server.sh"]

ENTRYPOINT [ "/app/server/server.sh"]
