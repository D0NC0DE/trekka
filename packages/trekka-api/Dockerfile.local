FROM node:20-alpine

WORKDIR /app

RUN apk add --no-cache bash postgresql-client

COPY package*.json ./
RUN npm install

COPY . .

RUN chmod +x docker-entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["./docker-entrypoint.sh"]
