# vega-cache-example

A minimal example of publishing reproducible Nix builds to the
[Vega](https://vega-cache.dev) binary cache.

On every push, GitHub Actions builds the flake's outputs and attests each one to
Vega over OIDC, with no stored secret. Reproducible outputs that distinct owners
independently agree on are promoted to Vega's globally trusted shared tier and
recorded in its public, append-only transparency log.

This repository targets the Vega staging control plane and also serves as a
reproduction fixture for Vega's reproduction worker.

## Outputs

- `figlet`, `hello`: packages re-exported from a pinned nixpkgs.
- `probe`: a small, deterministic output.
- `flaky`: intentionally non-reproducible (its bytes change on every build),
  used to exercise divergence detection.

## Using Vega in your own repository

Add the action to a workflow that requests an OIDC token:

```yaml
permissions:
  id-token: write
  contents: read

jobs:
  attest:
    runs-on: ubuntu-latest
    steps:
      - uses: Ad-Astra-Computing/vega-agent/agent@v0.4.3
        with:
          installable: "github:<owner>/<repo>#<attr>"
          control-plane: https://vega-cache.dev
```

See the [Vega documentation](https://docs.vega-cache.dev) for consuming the cache
and verifying builds.
