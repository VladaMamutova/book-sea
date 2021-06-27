FROM node:14.5-alpine

ENV APP_PATH=/usr/src
WORKDIR $APP_PATH

COPY package*.json $APP_PATH/
RUN yarn install

EXPOSE 8980

COPY . .

CMD ["yarn", "serve", "--port", "8980"]
