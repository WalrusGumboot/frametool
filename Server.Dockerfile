FROM node:current-alpine AS builder
RUN mkdir -p /app
WORKDIR /app
COPY package*.json /app
COPY . .
COPY .env .env
RUN npm install prisma -D && npx prisma generate && npm run build

FROM node:current-alpine
WORKDIR /app
COPY --from=builder /app/build build/
COPY --from=builder /app/node_modules node_modules/
# COPY --from=builder /app/src/lib/prisma-client src/lib/prisma-client
COPY --from=builder /app/src/lib/prisma-client/libquery_engine-linux-musl-openssl-3.0.x.so.node build/server/chunks
COPY package.json .
COPY .env .env
EXPOSE 32943
ENV NODE_ENV=production
CMD [ "node", "--env-file=.env", "build" ]