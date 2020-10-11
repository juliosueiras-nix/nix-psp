let
  pkgs = import <nixpkgs> {
    system = "x86_64-linux";
    config = { allowUnfree = true; };
    overlays = [ (import <nixpkgs-mozilla>) ];
  };
  createPSPSDK = import <src/lib.nix> {
    inherit pkgs;
  }; 
in {
  default = createPSPSDK {
    allowCFWSDK = true;
  };

  withNewlib = createPSPSDK {
    newlibVersion = "3.3.0";
    allowCFWSDK = true;
  };
}
