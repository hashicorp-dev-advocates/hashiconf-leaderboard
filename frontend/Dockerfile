FROM danlynn/ember-cli:5.9.0 AS build

ENV INSTALL_PATH /app
RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY package.json .
COPY yarn.lock .

RUN yarn

# Copy all our app's directories
COPY . .

ARG LEADERBOARD_API=http://localhost:9090
ENV REACT_APP_LEADERBOARD_API=$LEADERBOARD_API

RUN ember build --environment=production

FROM nginx:1.27
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html