FROM node:17-alpine AS base
RUN apk add --update dumb-init
USER node
WORKDIR /app
COPY --chown=node:node package.json package.json
COPY --chown=node:node package-lock.json package-lock.json

RUN npm install

# Install production dependencies only
#FROM node:17-alpine AS deps
#USER node
#WORKDIR /app
#COPY --chown=node:node package.json package.json
#COPY --chown=node:node yarn.lock yarn.lock
#RUN yarn install --production --frozen-lockfile

# Compile typescript sources
FROM base AS build
USER node
WORKDIR /app
COPY --chown=node:node tsconfig.json tsconfig.json
COPY --chown=node:node src/ src/
#COPY --chown=node:node test/ test/
RUN npm run build

# Combine production only node_modules with compiled javascript files.
FROM node:17-alpine AS final
RUN apk add --update dumb-init
USER node
WORKDIR /app
COPY --chown=node:node --from=build /app/node_modules ./app/node_modules
COPY --chown=node:node --from=build /app/dist/src ./dist/
COPY --chown=node:node --from=build /app/package.json ./
CMD [ "dumb-init", "node", "/app/dist/index.js" ]

FROM build as test
USER node
WORKDIR /app

EXPOSE 3001

CMD ["node", "/app/dist/index.js", "--", "--port", "3001"]