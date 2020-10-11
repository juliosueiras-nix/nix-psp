with import <nixpkgs> {};

let
  src = fetchgit {
    url = "https://github.com/juliosueiras-nix/nix-psp";
    rev = "master";
  };
in {
  test = (builtins.getFlake("git+https://github.com/juliosueiras-nix/nix-psp?ref=${src.rev}")).outputs.hydraJobs;
}
