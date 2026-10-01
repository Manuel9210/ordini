FROM node:24-bookworm-slim AS builder
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends bash ca-certificates coreutils curl && rm -rf /var/lib/apt/lists/*
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:24-bookworm-slim AS runtime
WORKDIR /app
ENV NODE_ENV=production PORT=8787 DATA_DIR=/data
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/aruba ./aruba
VOLUME ["/data"]
EXPOSE 8787
CMD ["node", "aruba/server.mjs"]
