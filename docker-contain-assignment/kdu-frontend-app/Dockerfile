# ---------- Stage 1: Build React ----------
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build


# ---------- Stage 2: Nginx ----------
FROM nginx:stable-alpine

COPY --from=builder /app/build /usr/share/nginx/html

# Replace default config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]