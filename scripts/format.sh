cd "$(git rev-parse --show-toplevel)"
typstyle -i src
tex_tmp=$(mktemp -d)
trap 'rm -rf "$tex_tmp"' EXIT
while IFS= read -r -d "" file; do
  latexindent -d -s -wd -c "$tex_tmp" "$file"
done < <(find src -type f \( -name "*.tex" -o -name "*.sty" \) -print0)
typos -w
nixfmt --verify --strict flake.nix
statix fix .
prettier --write .
markdownlint-cli2 --fix "**/*.md"
