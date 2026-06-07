FROM node:22-alpine

RUN npm install -g @agentmemory/agentmemory

WORKDIR /app
COPY config.yaml .

EXPOSE 3111 3112 3113

ENTRYPOINT ["agentmemory", "--config", "config.yaml"]
