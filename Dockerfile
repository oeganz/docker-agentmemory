FROM node:22-alpine

RUN apk add --no-cache curl ca-certificates

# Install agentmemory npm package
RUN npm install -g @agentmemory/agentmemory

# Install iii-engine (required by agentmemory)
RUN mkdir -p /root/.agentmemory/bin && \
    curl -fsSL "https://github.com/iii-hq/iii/releases/download/iii/v0.11.2/iii-x86_64-unknown-linux-gnu.tar.gz" | \
    tar -xz -C /root/.agentmemory/bin && \
    chmod +x /root/.agentmemory/bin/iii

ENV PATH="/root/.agentmemory/bin:${PATH}"

WORKDIR /app
COPY config.yaml .

EXPOSE 3111 3112 3113

ENTRYPOINT ["agentmemory", "--config", "config.yaml"]
