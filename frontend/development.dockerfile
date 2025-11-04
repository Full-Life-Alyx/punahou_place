FROM node:20-alpine
WORKDIR /app
VOLUME /app
EXPOSE 5173

ENV CI=true \
    # make chokidar see host-mounted file changes
    CHOKIDAR_USEPOLLING=true \
    # optional: speed up on network filesystems
    CHOKIDAR_INTERVAL=100

# Install deps first (better layer caching)
COPY package.json package-lock.json* pnpm-lock.yaml* yarn.lock* ./

RUN corepack enable && pnpm i --frozen-lockfile; 

# Copy the rest (sources will still be bind-mounted in compose; this is for first run)
COPY . .

EXPOSE 5173
CMD [ "npm", "run", "dev" ]
