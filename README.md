# rust

Docker image for building Rust applications in Forgejo/Gitea Actions CI.

Bundled tools:

- rust (pinned via `ARG` in the `Dockerfile`, with rustfmt and clippy)
- rustup (pinned via `ARG` in the `Dockerfile`)
- protoc (pinned via `ARG` in the `Dockerfile`; installed from the upstream
  `protocolbuffers/protobuf` release rather than Debian's
  `protobuf-compiler`, with `include/google/protobuf` well-known types)
- cargo
- pkg-config + libssl-dev (OpenSSL headers for building crates like
  `openssl`)
- make
- node (pinned via `ARG` in the `Dockerfile`; npm, npx included)
- prettier (pinned via `ARG` in the `Dockerfile`)
- git

## Image

Published to GHCR as `ghcr.io/micromaniacs/rust`:

- Tags: `latest`, major (e.g. `1`), major.minor (e.g. `1.99`) and the full
  version (e.g. `1.99.0`); all track the newest build. Every build is also
  published under a unique tag combining the exact tool versions (e.g.
  `1.99.0-rustup1.29.1-node26.11.1-prettier3.9.10-protoc36.2`), which is
  never re-pointed and keeps older builds available
- Multi-arch: `linux/amd64` and `linux/arm64`
- Debian trixie slim based; CI always builds with the newest stable Rust,
  rustup, Node.js, Prettier and protoc releases; the `ARG` defaults in the
  `Dockerfile` only apply to local builds
- A daily CI build at 03:00 UTC (also manually triggerable) discovers the
  newest stable Rust, rustup, Node.js, Prettier and protoc releases and
  publishes a new image whenever that exact combination has not been
  published yet. Untagged leftover image versions are deleted
  automatically by the workflow
- The `debian:trixie-slim` base image and the apt-installed packages
  (gcc, libc6-dev, libssl-dev, make, pkg-config, git, curl, unzip,
  ca-certificates) still track Debian trixie at build time and are not
  part of the combo tag

## License

[MIT](LICENSE)
