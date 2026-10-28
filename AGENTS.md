# AGENTS.md

This file provides guidance to coding agents (Claude Code and others) when working with code in this repository.

## What this is

Typst lecture notes and homework for multiple courses.
Each course lives directly under `src/`; homework uses a separate `<course>-hw/` directory.
`nix build` compiles course `main.typ` entry points to `result/<course>.pdf` and
top-level homework `.typ` files to `result/<course>-hw/<name>.pdf`.
Lecture chapters, nested homework fragments, and `src/_shared/` are not compiled independently.

Nix is the only prerequisite. All tools (typst, formatters, linters) come from the flake devshell — do not rely on ambient system tools; versions may differ.

## Commands

```bash
nix build                              # Compile all documents into ./result/.
nix flake check                        # Same as `nix build`, via flake checks.
nix run .#format                       # Format everything (fix mode).
nix run .#lint                         # Lint everything (check mode, same as CI).
nix develop --ignore-env               # Enter the devshell (individual tools + typst).
typst compile --root src src/data-science-math-hw/hw2.typ # Compile one document (in devshell).
typst watch --root src src/data-science-math-hw/hw2.typ hw2.pdf # Live preview (in devshell).
```

The `format`/`lint` apps are defined in `flake.nix` (`writeShellApplication`) and bundle:
typstyle, typos, yamllint, nixfmt, statix, prettier, markdownlint-cli2, gitleaks.
To add or adjust a tool, edit the app scripts and `lintDependencies` there.

CI (`.github/workflows/workflow.yml`) runs `nix run .#lint` plus `nix build` on push/PR to `main`.
Actions are SHA-pinned; dependabot updates them and `flake.lock` weekly.

## Gotchas

- **Nix flakes only see git-tracked files.** `git add` new files before `nix build`, or the build fails with "not tracked by Git".
- **Typst `@preview` packages resolve offline** via `typst.withPackages` in `flake.nix`.
  If a document imports a new package or version (e.g. `@preview/cetz:0.5.2`), add the matching nixpkgs attribute
  (`p.cetz_0_5_2` — underscores, from `typstPackages`) to the `typstWithPackages` list,
  or the sandboxed build fails with "failed to download package".
- **Entry points**: only `src/<course>/main.typ` and top-level `src/<course>-hw/*.typ` are compiled.
  Include lecture chapters explicitly from `main.typ` in the desired order.
  Keep homework fragments in subdirectories and shared helpers in `src/_shared/`.
- **Shared style**: entry points import `"/_shared/style.typ": style` and apply `#show: style`.
  Use local set/show rules after that rule for overrides; keep document metadata in the entry point.
  Pass `--root src` to local Typst commands so shared imports resolve, matching the build's source root.
- **Fonts**: only Typst's embedded defaults are available (the build passes `--ignore-system-fonts`).
  A `#set text(font: ...)` with any other font requires adding the font package and `TYPST_FONT_PATHS` to the derivation.

## Conventions

- Commit style: Conventional Commits (`feat:`, `fix:`, ...).
- PDFs are build outputs and gitignored — never commit them.
