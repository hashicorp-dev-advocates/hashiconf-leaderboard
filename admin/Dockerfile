FROM node:22-alpine AS build

ARG LEADERBOARD_API=http://localhost:9090
ENV REACT_APP_LEADERBOARD_API=$LEADERBOARD_API

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY public/ /app/public
COPY src/ /app/src

RUN npm run build

FROM nginx:1.27
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build /usr/share/nginx/html