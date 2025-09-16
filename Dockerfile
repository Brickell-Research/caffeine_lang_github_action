FROM alpine:3.18

LABEL "com.github.actions.name"="caffeine_lang"
LABEL "com.github.actions.description"="Run caffeine_lang in your GitHub Actions workflows"
LABEL "com.github.actions.icon"="coffee"
LABEL "com.github.actions.color"="blue"

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
