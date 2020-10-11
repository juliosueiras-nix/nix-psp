let
  nixpkgs = (<nixpkgs>);
  nixpkgs-mozilla = (<nixpkgs-mozilla>);
in {
  test = import <src/flake.nix> {
    inherit nixpkgs nixpkgs-mozilla;
  };
}
