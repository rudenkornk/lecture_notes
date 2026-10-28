cd "$(git rev-parse --show-toplevel)"
typstyle --check src
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
markdownlint-cli2 "**/*.md"
gitleaks git
