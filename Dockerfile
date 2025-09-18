FROM alpine:3.18

# Install build dependencies
RUN apk add --no-cache \
    curl \
    tar \
    gzip \
    bash \
    libstdc++ \
    build-base \
    git \
    erlang \
    erlang-dev \
    rust \
    cargo \
    && rm -rf /var/cache/apk/*

# Install rebar3 manually
RUN curl -Lo rebar3 https://github.com/erlang/rebar3/releases/download/3.22.1/rebar3 \
    && chmod +x rebar3 \
    && mv rebar3 /usr/local/bin/

# Install Gleam
RUN GLEAM_VERSION="v1.11.0" \
    && curl -Lo gleam.tar.gz "https://github.com/gleam-lang/gleam/releases/download/${GLEAM_VERSION}/gleam-${GLEAM_VERSION}-x86_64-unknown-linux-musl.tar.gz" \
    && tar -xzf gleam.tar.gz \
    && mv gleam /usr/local/bin/ \
    && rm gleam.tar.gz \
    && gleam --version

# Create Gleam project and install Caffeine language from Hex
WORKDIR /caffeine
RUN gleam new . \
    && gleam add caffeine_lang \
    && gleam deps download \
    && gleam build

# Create workspace
WORKDIR /app

# Copy scripts
COPY entrypoint.sh /entrypoint.sh

# Make script executable
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
