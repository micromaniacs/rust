ARG RUST_VERSION=1.98.1
ARG NODE_IMAGE=docker.io/library/node:trixie-slim

FROM ${NODE_IMAGE} AS node

FROM docker.io/library/debian:trixie-slim

ARG RUST_VERSION

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      gcc \
      git \
      libc6-dev \
      protobuf-compiler \
 && rm -rf /var/lib/apt/lists/* \
 && curl -fsSL --retry 3 -o /tmp/rustup-init.sh https://sh.rust-lang.org/rustup-init.sh \
 && sh /tmp/rustup-init.sh -y --no-modify-path --profile minimal --default-toolchain "${RUST_VERSION}" --component rustfmt --component clippy \
 && rm -f /tmp/rustup-init.sh

COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules

RUN ln -sf ../lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
 && ln -sf ../lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx \
 && npm install -g prettier \
 && rm -rf /root/.npm

LABEL org.opencontainers.image.title="rust" \
      org.opencontainers.image.source="https://github.com/alexeyco/rust" \
      org.opencontainers.image.description="Docker image for building Rust applications in Forgejo/Gitea Actions with rustfmt, clippy, protoc, Node.js and Prettier" \
      org.opencontainers.image.licenses="MIT"

WORKDIR /tmp
