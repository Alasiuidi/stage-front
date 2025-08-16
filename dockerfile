# ---------- Build stage ----------
FROM node:20-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build -- --configuration production

# ---------- Runtime stage ----------
FROM nginx:1.25-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf

# ⬇️ FIXED: copy Angular output (Angular 16/17+ default path)
COPY --from=builder /app/dist/fronttest/browser/ /usr/share/nginx/html/
EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD wget -qO- http://localhost/ >/dev/null 2>&1 || exit 1
