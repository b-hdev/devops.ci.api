FROM node:23.9 AS build

WORKDIR /usr/src/App

COPY package*.json package-lock.json ./
COPY . .

RUN npm install
RUN npm run build
RUN npm prune --production

FROM node:23.9-alpine3.21

WORKDIR /usr/src/App

# RUN npm cache clean --force

COPY --from=build /usr/src/App/package.json ./package.json
COPY --from=build /usr/src/App/dist ./dist
COPY --from=build /usr/src/App/node_modules ./node_modules

EXPOSE 3000

CMD [ "npm", "run", "start:prod" ]