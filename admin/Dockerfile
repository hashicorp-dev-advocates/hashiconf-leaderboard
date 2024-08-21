FROM node:22-alpine AS build

ENV REACT_APP_LEADERBOARD_API http://localhost:9090

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY public/ /app/public
COPY src/ /app/src

RUN npm run build

FROM nginx:1.27
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build /usr/share/nginx/html