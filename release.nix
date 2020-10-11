{ ... }: 

let
  #nixpkgs = (import <nixpkgs>);
  #nixpkgs-mozilla = (import <nixpkgs-mozilla>);
in (import <src/flake.nix> {})
