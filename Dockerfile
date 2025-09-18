FROM alpine:3.18

# Install minimal dependencies
RUN apk add --no-cache \
    curl \
    bash \
    erlang \
    erlang-dev \
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

# Create Gleam project and set up custom main
WORKDIR /caffeine
RUN gleam new . \
    && gleam add argv \
    && gleam add caffeine_lang \
    && gleam deps download

# Copy custom main.gleam
COPY main.gleam src/caffeine.gleam

# Show caffeine_lang package version
RUN echo "Caffeine Lang package version:" && gleam deps list | grep caffeine_lang || echo "caffeine_lang package not found"

# Build the project
RUN gleam build

# Create workspace
WORKDIR /app

# Copy scripts
COPY entrypoint.sh /entrypoint.sh

# Make script executable
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
