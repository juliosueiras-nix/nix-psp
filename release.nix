let
  pkgs = import <nixpkgs> {
    system = "x86_64-linux";
    config = { allowUnfree = true; };
    overlays = [ (import <nixpkgs-mozilla>) ];
  };

  createPSPSDK = import <src/lib.nix> {
    inherit pkgs;
  }; 

  srcs = {
    toolchain = {
      pspsdk = (<pspsdk>);
      insight = (<insight>);
      psplinkusb = (<psplinkusb>);
      binutils = (<binutils>);
      gcc = (<gcc>);
      newlib = {
        "3.3.0" = (<newlib-3_3_0>);
        "1.20.0" = (<newlib-1_20_0>);
      };
      gdb = (<gdb>);
      ebootsigner = (<ebootsigner>);
      psp-pkgconf = (<psp-pkgconf>);
    };
  };
in {
  default = createPSPSDK {
    allowCFWSDK = true;
    impureMode = true;
    inherit srcs;
  };

  withNewlib = createPSPSDK {
    newlibVersion = "3.3.0";
    impureMode = true;
    allowCFWSDK = true;
    inherit srcs;
  };
}
