#!/usr/bin/env bash
set -euo pipefail

case "$#:${1-}" in
0:) check=false ;;
1:--check) check=true ;;
*)
  echo "Usage: format [--check]" >&2
  exit 2
  ;;
esac

cd "$(git rev-parse --show-toplevel)" || exit
if "$check"; then
  ruff_args=()
  ruff_format_args=(--check)
  typstyle_args=(--check)
  shfmt_args=(-d)
  latexindent_args=(-k)
  typos_args=()
  nixfmt_args=(--check)
  statix_args=(check)
  prettier_args=(--check)
  markdownlint_args=()
  mdformat_args=(--check)
else
  ruff_args=(--fix)
  ruff_format_args=()
  typstyle_args=(-i)
  shfmt_args=(-w)
  latexindent_args=(-wd)
  typos_args=(-w)
  nixfmt_args=()
  statix_args=(fix)
  prettier_args=(--write)
  markdownlint_args=(--fix)
  mdformat_args=()
fi
ruff check "${ruff_args[@]}" .
ruff format "${ruff_format_args[@]}" .
typstyle "${typstyle_args[@]}" src
shfmt -ln bash -i 2 "${shfmt_args[@]}" scripts/*.sh .envrc
tex_tmp=$(mktemp -d)
trap 'rm -rf "$tex_tmp"' EXIT
while IFS= read -r -d "" file; do
  latexindent -d -s "${latexindent_args[@]}" -c "$tex_tmp" "$file"
done < <(find src -type f \( -name "*.tex" -o -name "*.sty" \) -print0)
mapfile -d "" -t markdown_files < <(git ls-files -z --cached --others --exclude-standard -- '*.md')
typos "${typos_args[@]}"
nixfmt "${nixfmt_args[@]}" --verify --strict flake.nix
statix "${statix_args[@]}" .
prettier "${prettier_args[@]}" .
markdownlint-cli2 "${markdownlint_args[@]}" "${markdown_files[@]}"
mdformat "${mdformat_args[@]}" "${markdown_files[@]}"
