{
  test = (builtins.getFlake("git+https://github.com/juliosueiras-nix/nix-psp?ref=master")).outputs.hydraJobs;
  #test = (import <src/flake.nix>).outputs {
  #  inherit nixpkgs nixpkgs-mozilla;
  #};
}
