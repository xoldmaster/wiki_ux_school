FROM node:22-slim AS builder
WORKDIR /usr/src/app

COPY package.json ./
COPY package-lock.json* ./
RUN npm ci

COPY . .
RUN npx quartz build

FROM nginx:alpine
COPY --from=builder /usr/src/app/public /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]