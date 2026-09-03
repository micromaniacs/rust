# Contributing

## Branching

- Never push to `master`.
- Branch from `master`: `git checkout -b feat/<topic>`.
- Commit messages: no conventional prefixes (`feat:`, `fix:`, …), past tense —
  e.g. `Added rustfmt to the image`, `Fixed the smoke test`.

## Development

- Tool versions: rust is pinned via `ARG RUST_VERSION` in the `Dockerfile` —
  bump it there (this also moves the version tags); everything else
  (Debian, node, prettier) tracks the latest available versions.
- Format changed Markdown and YAML files with Prettier:

  ```sh
  npx prettier --write README.md CONTRIBUTING.md .github/
  ```

- Build and test locally before pushing:

  ```sh
  docker build -t ghcr.io/alexeyco/rust:local .
  docker run --rm ghcr.io/alexeyco/rust:local sh -c 'rustc --version && cargo --version && rustfmt --version && cargo clippy --version && protoc --version && node --version && npm --version && npx --version && prettier --version && git --version'
  ```

- CI rebuilds and pushes the image to GHCR daily at 03:00 UTC (also manually
  triggerable); no releases, tags follow the pinned rust version:
  `latest`, `1`, `1.98`, `1.98.1`.
