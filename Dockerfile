FROM alpine:3.18

# Install dependencies
RUN apk add --no-cache \
    curl \
    tar \
    gzip \
    bash \
    libstdc++

# Copy scripts
COPY entrypoint.sh /entrypoint.sh

# Make script executable
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
