# ---------- Build stage ----------
FROM node:20-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
# Angular CLI builds to dist/<project-name>
RUN npm run build -- --configuration production

# ---------- Runtime stage ----------
FROM nginx:1.25-alpine

# Nginx for SPA
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy contents of ALL dist subfolders (handles unknown project name)
# The trailing "*/" is important: it copies the CONTENTS of each dist subfolder.
COPY --from=builder /app/dist/*/ /usr/share/nginx/html/

EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD wget -qO- http://localhost/ >/dev/null 2>&1 || exit 1
