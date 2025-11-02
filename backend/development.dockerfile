ARG ERLANG_VERSION=28.0.2.0
ARG GLEAM_VERSION=v1.13.0

# The purpose of this container is to supply the `gleam` binary
FROM ghcr.io/gleam-lang/gleam:${GLEAM_VERSION}-scratch AS gleam
FROM erlang:${ERLANG_VERSION}-alpine AS build
RUN apk add inotify-tools watchexec
# Grab /bin/gleam from the gleam container
COPY --from=gleam /bin/gleam /bin/gleam
VOLUME /app
WORKDIR /app
ENTRYPOINT ["watchexec"]
CMD ["--restart", "--verbose", "--wrap-process=session", "--stop-signal", "SIGTERM", "--exts", "gleam", "--debounce", "500ms", "--watch", "src/", "--", "gleam run"]
