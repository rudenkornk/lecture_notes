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

      texWithPackages = pkgs.texliveSmall.withPackages (p: [
        p.collection-langcyrillic
        p.cm-super
        p.eepic
        p.expdlist
        p.overpic
      ]);

      texTools = pkgs.texliveMinimal.withPackages (p: [
        p.chktex
        p.latexindent
      ]);

      lintDependencies = with pkgs; [
        # Format & lint tools.
        git
        gitleaks
        markdownlint-cli2
        nixfmt
        prettier
        statix
        texTools
        typos
        typstyle
        yamllint
      ];

      formatApp = pkgs.writeShellApplication {
        name = "format";
        runtimeInputs = lintDependencies;
        text = builtins.readFile ./scripts/format.sh;
      };

      lintApp = pkgs.writeShellApplication {
        name = "lint";
        runtimeInputs = lintDependencies;
        text = builtins.readFile ./scripts/lint.sh;
      };
    in
    {
      packages.${system}.default = pkgs.stdenvNoCC.mkDerivation {
        pname = "lecture-notes";
        version = "0.1.0";

        src = ./src;

        nativeBuildInputs = [
          typstWithPackages
          texWithPackages
        ];

        buildPhase = builtins.readFile ./scripts/build.sh;

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
        packages = [
          typstWithPackages
          texWithPackages
        ]
        ++ lintDependencies;
        shellHook = ''
          echo "Welcome to the lecture-notes devshell!"
        '';
      };

      # `nix flake check` builds all document entry points.
      checks.${system}.default = self.packages.${system}.default;
    };
}
