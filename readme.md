# `lecture-notes`

Lecture notes and homework for multiple courses, written in [Typst](https://typst.app).

## Organization

Each course has a directory directly under `src/`; its homework uses a separate directory with a `-hw` suffix.
For example:

```text
src/
  _shared/
    style.typ
  linear-algebra/
    main.typ
    lecture-01.typ
    lecture-02.typ
  linear-algebra-hw/
    hw1.typ
    hw2.typ
```

- `src/<course>/main.typ` compiles to `result/<course>.pdf`.
- Each top-level `.typ` file in `src/<course>-hw/` compiles to `result/<course>-hw/<name>.pdf`.
- Other files are not compiled independently; put homework fragments in subdirectories.
- `src/_shared/` holds shared styling and is excluded from document discovery.

## Development

[Nix](https://nixos.org/) is the only prerequisite.

### Common commands

```bash
nix develop --ignore-env             # Enter development shell.
nix build                            # Compile all documents into ./result/.
nix flake check                      # Same as `nix build`, via flake checks.
nix run .#format                     # Format the codebase (fix mode).
nix run .#lint                       # Lint the codebase (check mode, same as CI).
typst watch --root src src/data-science-math-hw/hw2.typ hw2.pdf # Live preview (in dev shell).
```

Use `--root src` when compiling or watching individual documents so shared imports resolve.

The `format` and `lint` apps bundle typstyle, typos, yamllint, nixfmt, statix, prettier, markdownlint-cli2 and gitleaks;
see their definitions in `flake.nix`. All tools are also available individually inside the dev shell.

CI runs `nix run .#lint` plus `nix build`; see `.github/workflows/workflow.yml`.
