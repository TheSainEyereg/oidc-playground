FROM node:14-alpine as builder

WORKDIR /app
RUN npm install --global npm@^7.5.6

COPY package.json package-lock.json ./
RUN npm install

COPY . .
RUN npm run build

FROM node:alpine as runner

WORKDIR /app

COPY --from=builder /app .

RUN sed -i 's/ng serve/ng serve --host 0.0.0.0/' package.json
ENV NODE_OPTIONS="--openssl-legacy-provider"

EXPOSE 4200

CMD ["npm", "start"]