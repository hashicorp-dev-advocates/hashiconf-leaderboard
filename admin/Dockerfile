FROM node:20-alpine AS build

WORKDIR /app

COPY package.json /app/package.json
COPY public/ /app/public
COPY src/ /app/src

ENV REACT_APP_LEADERBOARD_API http://api:9090

RUN ["npm", "install"]
RUN ["npm", "run", "build"]

FROM nginx:1.27
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build /usr/share/nginx/html