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
    clang = {
      rust-psp = (<rust-psp>);
      pspsdk = (<clang-pspsdk>);
      newlib = (<clang-newlib>);
    };

    libraries = {
      SDL = {
        gfx = (<SDL_gfx>);
        image = (<SDL_image>);
        ttf = (<SDL_ttf>);
        mixer = (<SDL_mixer>);
      };
      SDL2 = {
        gfx = (<SDL2_gfx>);
        image = (<SDL2_image>);
        ttf = (<SDL2_ttf>);
        mixer = (<SDL2_mixer>);
      };

      freetype = (<freetype>);
      pspgl = (<pspgl>);
      psplibraries = (<psplibraries>);
      psp-ports = (<psp-ports>);
      libpspvram = (<libpspvram>);
    };
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
