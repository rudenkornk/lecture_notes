# `lecture-notes`

Lecture notes and homework for multiple courses, written in [Typst](https://typst.app) or LaTeX.

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
    hw1.tex
    hw2.tex
    hometask.sty
    figures/
```

- `src/<course>/main.typ` or `main.tex` compiles to `result/<course>.pdf`.
- Each top-level `.typ` or `.tex` file in `src/<course>-hw/` compiles to `result/<course>-hw/<name>.pdf`.
- Use only one entry point per output PDF.
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
typst watch --root src src/linear-algebra/main.typ notes.pdf # Example live preview (in dev shell).
```

Use `--root src` when compiling or watching individual documents so shared imports resolve.

### LaTeX

LaTeX documents use project-local `.sty` files.
The build runs `pdflatex` twice from each entry point's directory, preserving relative style and figure paths.
Additional bibliography and index processing is not configured.
Required TeX packages are listed in `texWithPackages` in `flake.nix`.

For the example layout above, enter the development shell and compile a homework locally with:

```bash
cd src/linear-algebra-hw
export TEXMFVAR=$(mktemp -d)
pdflatex -interaction=nonstopmode -halt-on-error -file-line-error hw1.tex
pdflatex -interaction=nonstopmode -halt-on-error -file-line-error hw1.tex
```

The writable `TEXMFVAR` directory allows Cyrillic font metrics to be generated even in an environment without `HOME`.

`nix run .#format` formats `.tex` and `.sty` files with `latexindent`.
`nix run .#lint` checks their formatting and runs `chktex`, including style files and document preambles.
Intentional constructs can use targeted `% chktex <number>` or `% chktex-file <number>` suppressions.

The `format` and `lint` apps bundle typstyle, latexindent, chktex, shfmt, ShellCheck, mdformat,
typos, yamllint, nixfmt, statix, prettier,
markdownlint-cli2 and gitleaks;
their commands live in `scripts/format.sh` and `scripts/lint.sh`, with dependencies defined in `flake.nix`.
The document build phase lives in `scripts/build.sh`.
Use the Nix commands above to run these scripts in their configured environments.
All tools are also available individually inside the dev shell.

Shell formatting and lint cover `scripts/*.sh` and `.envrc`, with Bash syntax and two-space indentation.
Markdown formatting uses `mdformat` with `mdformat-beautysh` and `mdformat-gfm`, alongside `markdownlint-cli2`.
Both Markdown tools check tracked and non-ignored untracked files, excluding generated directories such as `.direnv/`.

CI runs `nix run .#lint` plus `nix build`; see `.github/workflows/workflow.yml`.
