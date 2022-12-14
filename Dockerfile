# Build stage
FROM node:18 AS builder

WORKDIR /usr/src/app

COPY app/package*.json ./
COPY app/tsconfig*.json ./
COPY app/src ./src
RUN npm ci --quiet && npm run build


# Production stage
FROM node:16-alpine

WORKDIR /app

ARG RELEASE
ENV SENTRY_RELEASE=${RELEASE:-dev}
ENV NODE_ENV=production
ENV DEBUG=false

COPY app/package*.json ./
RUN npm ci --quiet --only=production

COPY --from=builder /usr/src/app/dist ./dist

CMD [ "node", "dist/index.js" ]
