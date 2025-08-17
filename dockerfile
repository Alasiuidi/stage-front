# ---------- Build stage ----------
FROM node:20-alpine AS builder
WORKDIR /app

# Install deps first (better caching)
COPY package*.json ./
RUN npm ci

# Build the app
COPY . .
# NOTE: Angular CLI builds to dist/<APP_NAME>
RUN npm run build -- --configuration production

# ---------- Runtime stage ----------
FROM nginx:1.25-alpine

# Nginx for SPA: serve index.html on deep links
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy compiled app. Pass your Angular app name at build time:
#   --build-arg APP_NAME=<your-angular-project-name>
ARG APP_NAME
COPY --from=builder /app/dist/${APP_NAME} /usr/share/nginx/html

EXPOSE 80

# Simple healthcheck
HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD wget -qO- http://localhost/ >/dev/null 2>&1 || exit 1
