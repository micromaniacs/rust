# rust

Docker image for building Rust applications in Forgejo/Gitea Actions CI.

Bundled tools:

- rust (stable, pinned, with rustfmt and clippy)
- cargo
- protobuf-compiler (protoc)
- node (npm, npx included)
- prettier
- git

## Image

Published to GHCR as `ghcr.io/alexeyco/rust`:

- Tags: `latest`, major (e.g. `1`), major.minor (e.g. `1.98`) and the full
  version (e.g. `1.98.1`)
- Multi-arch: `linux/amd64` and `linux/arm64`
- Debian trixie slim based; rust is installed via rustup with the exact
  version pinned in `ARG RUST_VERSION` in the `Dockerfile` (bump it there),
  everything else tracks the latest available versions
- Rebuilt daily at 03:00 UTC via CI (also manually triggerable)

## License

[MIT](LICENSE)
