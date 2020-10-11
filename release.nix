with import <nixpkgs> {};

let
  src = fetchgit {
    url = "https://github.com/juliosueiras-nix/nix-psp";
    rev = "master";
  };
in {
  test = (builtins.getFlake("github:juliosueiras-nix/nix-psp/${src.rev}")).outputs.hydraJobs;
}
