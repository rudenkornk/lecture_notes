#!/usr/bin/env bash
set -euo pipefail

cd "$(git rev-parse --show-toplevel)" || exit
typstyle -i src
shfmt -ln bash -i 2 -w scripts/*.sh .envrc
tex_tmp=$(mktemp -d)
trap 'rm -rf "$tex_tmp"' EXIT
while IFS= read -r -d "" file; do
  latexindent -d -s -wd -c "$tex_tmp" "$file"
done < <(find src -type f \( -name "*.tex" -o -name "*.sty" \) -print0)
typos -w
nixfmt --verify --strict flake.nix
statix fix .
prettier --write .
mapfile -d "" -t markdown_files < <(git ls-files -z --cached --others --exclude-standard -- '*.md')
markdownlint-cli2 --fix "${markdown_files[@]}"
mdformat "${markdown_files[@]}"
