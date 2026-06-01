# Stage 1: Build
FROM node:22-alpine AS builder
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY Cakefile .
COPY src/ src/
COPY lib/ lib/
RUN ./node_modules/.bin/cake build

# Stage 2: Serve
FROM nginx:alpine
RUN apk upgrade --no-cache
COPY --from=builder /app/lib /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
