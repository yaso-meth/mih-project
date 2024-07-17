# Install Operating system and dependencies
#FROM ubuntu:22.04
FROM debian:latest AS build-env

#ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback python3

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

# VOLUME ["/app"]

WORKDIR /app
RUN flutter upgrade
RUN flutter build web -t ./lib/main_prod.dart

# RUN cd ..

EXPOSE 83
# COPY /app/build/web 

# # Use Nginx to serve the app
# FROM nginx:alpine

# #install requirements for certbot
# RUN apk add python3 py3-pip

# # RUN apk add --no-cache py3-certbot-nginx
# RUN apk add certbot-nginx
# RUN mkdir /etc/letsencrypt

# # Copy the build artifacts from the build stage, and the Nginx configuration
# COPY --from=build-env /app/build/web /usr/share/nginx/html
# COPY nginx.conf /etc/nginx/nginx.conf
# # COPY /certbot/conf /etc/letsencrypt
# # ./Frontend/patient_manager/certbot/conf:/etc/letsencrypt
# #     - ./Frontend/patient_manager/certbot/www:/var/www/certbot

# #RUN certbot --nginx -d mzansi-innovation-hub.co.za

# EXPOSE 80 443


# CMD ["nginx", "-g", "daemon off;"]


# RUN certbot --nginx -d mzansi-innovation-hub.co.za -d www.mzansi-innovation-hub.co.za

# # Record the exposed port
# EXPOSE 8080

# # make server startup script executable and start the web server
RUN ["chmod", "+x", "/app/server/server.sh"]

ENTRYPOINT [ "/app/server/server.sh"]
