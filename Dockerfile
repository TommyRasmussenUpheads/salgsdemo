FROM node:24-alpine
ARG APP_VERSION=dev
ARG BUILD_DATE=
ARG GIT_COMMIT=
WORKDIR /app
ENV NODE_ENV=production PORT=3000 NODE_NO_WARNINGS=1 \
    APP_VERSION=$APP_VERSION BUILD_DATE=$BUILD_DATE GIT_COMMIT=$GIT_COMMIT
COPY server.js ./
COPY public ./public
USER node
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://127.0.0.1:3000/healthz || exit 1
CMD ["node", "server.js"]
