FROM node:22-slim

RUN apt-get update && apt-get install -y curl ca-certificates socat && rm -rf /var/lib/apt/lists/*

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

# socat forwards 0.0.0.0:3111 → 127.0.0.1:3111 (agentmemory ignores host config, binds localhost only)
CMD socat TCP-LISTEN:3111,reuseaddr,fork TCP:127.0.0.1:3111 & \
    socat TCP-LISTEN:3112,reuseaddr,fork TCP:127.0.0.1:3112 & \
    socat TCP-LISTEN:3113,reuseaddr,fork TCP:127.0.0.1:3113 & \
    agentmemory --config config.yaml
