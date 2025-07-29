FROM node:20-alpine AS builder

WORKDIR /app

RUN npm install -g n8n && \
    npm uninstall puppeteer && \
    npm cache clean --force

FROM node:20-alpine

WORKDIR /app
COPY --from=builder /usr/local /usr/local

EXPOSE 5678
CMD ["n8n"]
