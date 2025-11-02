FROM node:20-alpine
WORKDIR /app
VOLUME /app
EXPOSE 5173
ENV VITE_HOST=0.0.0.0

ENTRYPOINT ["npm"]
CMD ["run", "dev"]
