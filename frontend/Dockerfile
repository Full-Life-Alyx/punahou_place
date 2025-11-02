FROM node:20 AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable && corepack prepare pnpm@9.11.0 --activate
ENV CI=true
COPY . /app
WORKDIR /app

FROM base AS prod-deps
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --prod --frozen-lockfile

FROM base AS build
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile
RUN pnpm run build

EXPOSE 8080
FROM base AS development
# Re-install all dependencies to ensure dev tools are available
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile
# The --host 0.0.0.0 is for docker
CMD [ "pnpm", "run", "dev", "--", "--host", "0.0.0.0", "--port", "8080"]


FROM base AS production
COPY --from=prod-deps /app/node_modules /app/node_modules
COPY --from=build /app/dist /app/dist
CMD [ "pnpm", "start" ]

# FROM nginx:stable-alpine AS final
# # Copy built files from `build` step to `final` step's Nginx's distribution directory
# COPY --from=build /app/dist /usr/share/nginx/html
#
# EXPOSE 80
# CMD ["nginx", "-g", "daemon off;"]
#
