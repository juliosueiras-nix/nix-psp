let
  nixpkgs = (<nixpkgs>);
  nixpkgs-mozilla = (<nixpkgs-mozilla>);
in {
  test = (builtins.getFlake("git+https://github.com/juliosueiras-nix/nix-psp")).outputs.hydraJobs;
  #test = (import <src/flake.nix>).outputs {
  #  inherit nixpkgs nixpkgs-mozilla;
  #};
}
