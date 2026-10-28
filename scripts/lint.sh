#!/usr/bin/env bash
set -euo pipefail

cd "$(git rev-parse --show-toplevel)" || exit
typstyle --check src
shfmt -ln bash -i 2 -d scripts/*.sh .envrc
shellcheck -s bash scripts/*.sh .envrc
tex_tmp=$(mktemp -d)
trap 'rm -rf "$tex_tmp"' EXIT
while IFS= read -r -d "" file; do
  latexindent -d -s -k -c "$tex_tmp" "$file"
  chktex -q -I0 -H1 "$file"
done < <(find src -type f \( -name "*.tex" -o -name "*.sty" \) -print0)
typos
yamllint --strict .
nixfmt --check --verify --strict flake.nix
statix check .
prettier --check .
mapfile -d "" -t markdown_files < <(git ls-files -z --cached --others --exclude-standard -- '*.md')
mdformat --check "${markdown_files[@]}"
markdownlint-cli2 "${markdown_files[@]}"
gitleaks git
