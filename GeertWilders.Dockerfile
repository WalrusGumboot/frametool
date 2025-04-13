FROM node:current-alpine
RUN mkdir -p /app
WORKDIR /app
COPY . .
CMD [ "npx", "prisma", "migrate", "deploy" ]