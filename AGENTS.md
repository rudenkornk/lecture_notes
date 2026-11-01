# AGENTS.md

This file provides guidance to coding agents (Claude Code and others) when working with code in this repository.

## What this is

Typst and LaTeX lecture notes and homework for multiple courses.
Each course lives directly under `src/`; homework uses a separate `<course>-hw/` directory.
`nix build` compiles course `main.typ` or `main.tex` entry points to `result/<course>.pdf` and
top-level homework `.typ` or `.tex` files to `result/<course>-hw/<name>.pdf`.
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
Ruff, ty, typstyle, latexindent, chktex, shfmt, ShellCheck, mdformat, typos, yamllint, nixfmt, statix, prettier,
markdownlint-cli2, gitleaks.
To add or adjust a tool, edit `scripts/format.sh` or `scripts/lint.sh` and `lintDependencies` in `flake.nix`.
The document build phase is in `scripts/build.sh`; Nix loads all three scripts with `builtins.readFile`.
`texWithPackages` contains compiler/document packages; `lintDependencies` includes a separate minimal TeX tools environment.
The devshell includes `texWithPackages` explicitly alongside `lintDependencies`.
The media devshell extends the default devshell with `mediaDependencies` for audio and image processing.
Python tools use project-wide settings in `pyproject.toml`.
Shell checks cover `scripts/*.sh` and `.envrc`, using Bash syntax and two-space indentation.
Markdown tools use Git's tracked and non-ignored untracked files, excluding generated directories such as `.direnv/`.

CI (`.github/workflows/workflow.yml`) runs `nix run .#lint` plus `nix build` on push/PR to `main`.
Actions are SHA-pinned; dependabot updates them and `flake.lock` weekly.

## Gotchas

- **Nix flakes only see git-tracked files.** `git add` new files before `nix build`, or the build fails with "not tracked by Git".
- **Typst `@preview` packages resolve offline** via `typst.withPackages` in `flake.nix`.
  If a document imports a new package or version (e.g. `@preview/cetz:0.5.2`), add the matching nixpkgs attribute
  (`p.cetz_0_5_2` — underscores, from `typstPackages`) to the `typstWithPackages` list,
  or the sandboxed build fails with "failed to download package".
- **Entry points**: only course `main.typ`/`main.tex` and top-level homework `.typ`/`.tex` files are compiled.
  Use only one entry point per output PDF; include lecture chapters explicitly in the desired order.
  Keep homework fragments in subdirectories and shared helpers in `src/_shared/`.
- **Typst shared style**: entry points import `"../_shared/style.typ": style` and apply `#show: style`.
  Use relative imports so editor tooling resolves shared files.
  Use local set/show rules after that rule for overrides; keep document metadata in the entry point.
  Pass `--root src` to local Typst commands so shared imports resolve, matching the build's source root.
- **Fonts**: the build passes `--ignore-system-fonts` and supplies PT Serif, PT Sans, STIX Two Math,
  and DejaVu fonts through `TYPST_FONT_PATHS`, alongside Typst's embedded defaults.
  Additional fonts require adding their packages to `typstFontPaths` in `flake.nix`.
- **LaTeX**: compile directly with two `pdflatex` passes from the entry point's directory.
  Additional bibliography and index processing is not configured.
  Keep `.sty` files local to the project and add required TeX packages to `texWithPackages` in `flake.nix`.
  For local compilation without `HOME`, set `TEXMFVAR` to a writable temporary directory for Cyrillic font metrics.
  The build does this automatically and keeps auxiliary outputs in temporary directories.
- **LaTeX checks**: format and lint both `.tex` and `.sty`, including preambles.
  Use targeted ChkTeX suppressions for intentional constructs when preserving an imported document's appearance.

## Lecture recordings

Use the media devshell for audio extraction, transcription, and image processing.
`scripts/transcribe.py` uses only Python's standard library.

```bash
nix develop .#media
mkdir -p ~/Downloads/ml/processed
bash scripts/extract-audio.sh ~/Downloads/ml/lecture.mp4 ~/Downloads/ml/processed/lecture.wav
python scripts/transcribe.py ~/Downloads/ml/processed/lecture.wav \
    ~/Downloads/ml/processed/transcription --key-file /path/to/yakey --folder-id YOUR_FOLDER_ID
```

- Extraction preserves video timestamps and produces mono, 16 kHz, 16-bit PCM WAV without overwriting existing files.
- SpeechKit uses Russian recognition with normalization disabled, 900-second chunks, 10-second overlaps,
  and up to four concurrent workers.
  The encoded request budget is 55 MB, below the 60 MB direct-upload limit.
- The output directory stores the audio/settings manifest, per-chunk operation IDs, raw JSONL results,
  `words.json`, and a timestamped `transcript.txt`.
  Rerun the same command to resume; changed audio or settings require a new output directory.
  Use only one transcription process per output directory.
- Remote recognition results expire after three days; downloaded results remain reusable.
  Failed overlap matching requires inspecting saved results.
  API errors do not trigger automatic resubmission.
  If a submission succeeded but its operation ID was not saved, inspect the cloud operation before rerunning.
- Notes are compact reminders of an attended lecture, preferably at most three pages in the course's existing style.
  Let the recording determine coverage and use slides and notebooks to verify details.
  Crop illustrations from supplied materials, retain source references, and inspect compression at printed size.
  Keep credentials, recordings, and intermediate files outside Git.

## Conventions

- Commit style: Conventional Commits (`feat:`, `fix:`, ...).
- PDFs are build outputs and gitignored — never commit them.
