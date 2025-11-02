# https://gleam.run/deployment/linux-server/#create-a-dockerfile
ARG ERLANG_VERSION=28.0.2.0
ARG GLEAM_VERSION=v1.13.0

# Gleam stage
FROM ghcr.io/gleam-lang/gleam:${GLEAM_VERSION}-scratch AS gleam

# Build stage
FROM erlang:${ERLANG_VERSION}-alpine AS build
COPY --from=gleam /bin/gleam /bin/gleam
COPY . /app/
RUN cd /app && gleam export erlang-shipment;

FROM erlang:${ERLANG_VERSION}-alpine AS dev
COPY --from=gleam /bin/gleam /bin/gleam
WORKDIR /app
# To cache the dependencies
COPY gleam.toml .
RUN mkdir src;
RUN gleam build;

COPY . .
ENTRYPOINT ["gleam"]
CMD ["run"]

# Final stage
FROM erlang:${ERLANG_VERSION}-alpine AS prod
ARG GIT_SHA
ARG BUILD_TIME
ENV GIT_SHA=${GIT_SHA}
ENV BUILD_TIME=${BUILD_TIME}
COPY healthcheck.sh /app/healthcheck.sh
RUN \
  chmod +x /app/healthcheck.sh \
  addgroup --system webapp && \
  adduser --system webapp -g webapp
COPY --from=build /app/build/erlang-shipment /app
WORKDIR /app
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["run"]
