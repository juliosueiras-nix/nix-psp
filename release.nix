{ ... }: 

let
  nixpkgs = <nixpkgs>;
  nixpkgs-mozilla = <nixpkgs-mozilla>;
in (import <src/flake.nix> { inherit nixpkgs nixpkgs-mozilla; })
