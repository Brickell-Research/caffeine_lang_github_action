FROM alpine:3.18

# Install minimal dependencies
RUN apk add --no-cache \
    curl \
    bash \
    jq \
    && rm -rf /var/cache/apk/*

# Download and install Caffeine binary from latest release
RUN RELEASE_INFO=$(curl -s https://api.github.com/repos/Brickell-Research/caffeine_lang/releases/latest) \
    && VERSION=$(echo "$RELEASE_INFO" | jq -r '.tag_name' | sed 's/^v//') \
    && DOWNLOAD_URL=$(echo "$RELEASE_INFO" | jq -r '.assets[] | select(.name | contains("linux-x64")) | .browser_download_url') \
    && echo "Downloading Caffeine v${VERSION} from ${DOWNLOAD_URL}" \
    && curl -Lo caffeine.tar.gz "$DOWNLOAD_URL" \
    && tar -xzf caffeine.tar.gz \
    && mv caffeine /usr/local/bin/ \
    && chmod +x /usr/local/bin/caffeine \
    && rm caffeine.tar.gz \
    && caffeine --help

# Create workspace
WORKDIR /app

# Copy scripts
COPY entrypoint.sh /entrypoint.sh

# Make script executable
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
