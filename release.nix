let
  nixpkgs = (<nixpkgs>);
  nixpkgs-mozilla = (<nixpkgs-mozilla>);
in {
  test = builtins.getFlake("${<src>}");
  #test = (import <src/flake.nix>).outputs {
  #  inherit nixpkgs nixpkgs-mozilla;
  #};
}
