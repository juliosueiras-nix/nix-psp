let
  pkgs = import <nixpkgs> {
    system = "x86_64-linux";
    config = { allowUnfree = true; };
    overlays = [ (import <nixpkgs-mozilla>) ];
  };
in {
  result = import <src/lib.nix> {
    inherit pkgs;
  } {
    allowCFWSDK = true;
  };
}
