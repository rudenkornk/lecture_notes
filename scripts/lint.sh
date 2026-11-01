#!/usr/bin/env bash
set -euo pipefail

cd "$(git rev-parse --show-toplevel)" || exit
ty check
shellcheck -s bash scripts/*.sh .envrc
while IFS= read -r -d "" file; do
  chktex -q -I0 -H1 "$file"
done < <(find src -type f \( -name "*.tex" -o -name "*.sty" \) -print0)
yamllint --strict .
gitleaks git
