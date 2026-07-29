# --- STAGE 1: The Builder ---
FROM debian:latest AS build-env

# Install necessary dependencies for Flutter 
RUN apt-get update && apt-get install -y \
	curl git wget unzip libglu1-mesa fonts-droid-fallback python3 \
	&& rm -rf /var/lib/apt/lists/*

# Clone Flutter SDK 
RUN git clone -b stable --depth 1 https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Build the Flutter web app 
RUN flutter config --enable-web && flutter precache --web
WORKDIR /app
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get
COPY . .
RUN flutter build web --wasm --release -t ./lib/main_prod.dart -v

# --- STAGE 2: The Final Production Image ---
FROM nginx:alpine

# Copy built files from the first stage 
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Create the Nginx config inside the Dockerfile to handle SPA routing 
RUN echo 'server { \
	listen 83; \
	location / { \
	root /usr/share/nginx/html; \
	index index.html; \
	try_files $uri $uri/ /index.html; \
	} \
	}' > /etc/nginx/conf.d/default.conf

EXPOSE 83
CMD ["nginx", "-g", "daemon off;"]
