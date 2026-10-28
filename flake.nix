{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      # Typst wrapped with @preview packages so imports resolve offline in the sandbox.
      # Attribute names must match the exact versions imported in the sources,
      # e.g. `#import "@preview/cetz:0.4.2"` -> `cetz_0_4_2`.
      typstWithPackages = pkgs.typst.withPackages (p: [ p.cetz_0_4_2 ]);

      lintDependencies = with pkgs; [
        # Format & lint tools.
        git
        gitleaks
        markdownlint-cli2
        nixfmt
        prettier
        statix
        typos
        typstyle
        yamllint
      ];

      formatApp = pkgs.writeShellApplication {
        name = "format";
        runtimeInputs = lintDependencies;
        text = ''
          cd "$(git rev-parse --show-toplevel)"
          typstyle -i src
          typos -w
          nixfmt --verify --strict flake.nix
          statix fix .
          prettier --write .
          markdownlint-cli2 --fix "**/*.md"
        '';
      };

      lintApp = pkgs.writeShellApplication {
        name = "lint";
        runtimeInputs = lintDependencies;
        text = ''
          cd "$(git rev-parse --show-toplevel)"
          typstyle --check src
          typos
          yamllint --strict .
          nixfmt --check --verify --strict flake.nix
          statix check .
          prettier --check .
          markdownlint-cli2 "**/*.md"
          gitleaks git
        '';
      };
    in
    {
      packages.${system}.default = pkgs.stdenvNoCC.mkDerivation {
        pname = "lecture-notes";
        version = "0.1.0";

        src = ./src;

        nativeBuildInputs = [ typstWithPackages ];

        buildPhase = ''
          runHook preBuild
          while IFS= read -r -d "" file; do
            course="''${file#./}"
            course="''${course%%/*}"
            if [[ "$course" == "_shared" ]]; then
              continue
            elif [[ "$course" == *-hw ]]; then
              output="''${file%.typ}.pdf"
            elif [[ "''${file##*/}" == "main.typ" ]]; then
              output="$course.pdf"
            else
              continue
            fi
            typst compile --root . --ignore-system-fonts "$file" "$output"
          done < <(find . -mindepth 2 -maxdepth 2 -type f -name "*.typ" -print0)
          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall
          while IFS= read -r -d "" pdf; do
            install -Dm644 "$pdf" "$out/''${pdf#./}"
          done < <(find . -type f -name "*.pdf" -print0)
          runHook postInstall
        '';
      };

      apps.${system} = {
        format = {
          type = "app";
          program = pkgs.lib.getExe formatApp;
          meta.description = "Format the codebase.";
        };
        lint = {
          type = "app";
          program = pkgs.lib.getExe lintApp;
          meta.description = "Lint the codebase.";
        };
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = [ typstWithPackages ] ++ lintDependencies;
        shellHook = ''
          echo "Welcome to the lecture-notes devshell!"
        '';
      };

      # `nix flake check` builds all document entry points.
      checks.${system}.default = self.packages.${system}.default;
    };
}
