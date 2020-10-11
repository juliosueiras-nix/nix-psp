{ ... }: 

let
  nixpkgs = (import <nixpkgs>);
  nixpkgs-mozilla = (import <nixpkgs-mozilla>);
in nixpkgs
