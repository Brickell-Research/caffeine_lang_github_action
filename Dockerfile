FROM debian:bookworm-slim

# Install minimal dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    bash \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Download and install Caffeine binary from latest release
# Use sed to extract tag_name to avoid jq parsing issues with control chars in release notes
RUN TAG=$(curl -s https://api.github.com/repos/Brickell-Research/caffeine_lang/releases/latest | sed -n 's/.*"tag_name":\s*"\([^"]*\)".*/\1/p' | head -1) \
    && VERSION=$(echo "$TAG" | sed 's/^v//') \
    && DOWNLOAD_URL="https://github.com/Brickell-Research/caffeine_lang/releases/download/${TAG}/caffeine-${VERSION}-linux-x64.tar.gz" \
    && echo "Downloading Caffeine v${VERSION} from ${DOWNLOAD_URL}" \
    && curl -Lo caffeine.tar.gz "$DOWNLOAD_URL" \
    && tar -xzf caffeine.tar.gz \
    && mv caffeine-*-linux-x64 /usr/local/bin/caffeine \
    && chmod +x /usr/local/bin/caffeine \
    && rm caffeine.tar.gz

# Create workspace
WORKDIR /app

# Copy scripts
COPY entrypoint.sh /entrypoint.sh

# Make script executable
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
