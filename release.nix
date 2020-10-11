with import <nixpkgs> {};

let
  src = fetchgit {
    url = "https://github.com/juliosueiras-nix/nix-psp";
    rev = "master";
  };
  te = import <toolchain-src>;
in {
  test = (builtins.getFlake("github:juliosueiras-nix/nix-psp/${te.rev}")).outputs.hydraJobs;
}
