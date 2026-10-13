ARG RUST_VERSION=1.99.0
ARG RUSTUP_VERSION=1.29.1
ARG NODE_VERSION=26.11.1
ARG PRETTIER_VERSION=3.9.10
ARG PROTOC_VERSION=36.2

FROM docker.io/library/node:${NODE_VERSION}-trixie-slim AS node

FROM docker.io/library/debian:trixie-slim

ARG TARGETARCH
ARG RUST_VERSION
ARG RUSTUP_VERSION
ARG NODE_VERSION
ARG PRETTIER_VERSION
ARG PROTOC_VERSION

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
      libssl-dev \
      make \
      pkg-config \
      unzip \
 && rm -rf /var/lib/apt/lists/*

RUN arch="${TARGETARCH:-$(dpkg --print-architecture)}" \
 && case "${arch}" in \
        amd64) rustup_target=x86_64-unknown-linux-gnu; protoc_arch=x86_64 ;; \
        arm64) rustup_target=aarch64-unknown-linux-gnu; protoc_arch=aarch_64 ;; \
        *) echo "unsupported architecture: ${arch}" >&2; exit 1 ;; \
      esac \
   && curl -fsSL --retry 3 -o /tmp/rustup-init "https://static.rust-lang.org/rustup/archive/${RUSTUP_VERSION}/${rustup_target}/rustup-init" \
   && curl -fsSL --retry 3 -o /tmp/rustup-init.sha256 "https://static.rust-lang.org/rustup/archive/${RUSTUP_VERSION}/${rustup_target}/rustup-init.sha256" \
   && echo "$(cut -d' ' -f1 /tmp/rustup-init.sha256)  /tmp/rustup-init" | sha256sum --check --status - \
   && chmod +x /tmp/rustup-init \
   && /tmp/rustup-init -y --no-modify-path --profile minimal --default-toolchain "${RUST_VERSION}" --component rustfmt --component clippy \
   && rm -f /tmp/rustup-init /tmp/rustup-init.sha256 \
   && curl -fsSL --retry 3 -o /tmp/protoc.zip "https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-${protoc_arch}.zip" \
   && unzip -q /tmp/protoc.zip 'bin/*' 'include/*' -d /usr/local \
   && chmod 0755 /usr/local/bin/protoc \
   && rm -f /tmp/protoc.zip

COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules

RUN ln -sf ../lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
 && ln -sf ../lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx \
 && npm install -g prettier@${PRETTIER_VERSION} \
 && rm -rf /root/.npm

LABEL org.opencontainers.image.title="rust" \
      org.opencontainers.image.source="https://github.com/micromaniacs/rust" \
      org.opencontainers.image.description="Docker image for building Rust applications in Forgejo/Gitea Actions with rustfmt, clippy, protoc, Node.js and Prettier" \
      org.opencontainers.image.licenses="MIT" \
      io.micromaniacs.rust="${RUST_VERSION}" \
      io.micromaniacs.rustup="${RUSTUP_VERSION}" \
      io.micromaniacs.node="${NODE_VERSION}" \
      io.micromaniacs.prettier="${PRETTIER_VERSION}" \
      io.micromaniacs.protoc="${PROTOC_VERSION}"

WORKDIR /tmp
