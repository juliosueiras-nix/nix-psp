{ src, nixpkgs, nixpkgs-mozilla, ... }: import "${src}/flake.nix" { inherit src nixpkgs nixpkgs-mozilla; }
