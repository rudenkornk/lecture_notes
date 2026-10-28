#!/usr/bin/env bash
set -euo pipefail

runHook preBuild
TEXMFVAR=$(mktemp -d)
export TEXMFVAR
while IFS= read -r -d "" file; do
  course="${file#./}"
  course="${course%%/*}"
  if [[ "$course" == "_shared" ]]; then
    continue
  elif [[ "$course" == *-hw ]]; then
    output="${file%.*}.pdf"
  elif [[ "${file##*/}" == "main.typ" || "${file##*/}" == "main.tex" ]]; then
    output="$course.pdf"
  else
    continue
  fi
  if [[ "$file" == *.typ ]]; then
    typst compile --root . --ignore-system-fonts "$file" "$output"
  else
    build_dir=$(mktemp -d)
    (
      cd "$(dirname "$file")" || exit
      for _ in 1 2; do
        pdflatex -interaction=nonstopmode -halt-on-error -file-line-error \
          -output-directory="$build_dir" "${file##*/}"
      done
    )
    name="${file##*/}"
    mv "$build_dir/${name%.tex}.pdf" "$output"
    rm -r "$build_dir"
  fi
done < <(find . -mindepth 2 -maxdepth 2 -type f \( -name "*.typ" -o -name "*.tex" \) -print0)
runHook postBuild
