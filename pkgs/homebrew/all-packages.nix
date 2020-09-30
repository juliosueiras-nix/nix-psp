{ stdenv, zip, pspsdk, libraries, fetchFromGitHub, symlinkJoin , ... }:

let
  pspsdkEnv = symlinkJoin  {
    name = "test-env";
    paths = [
      pspsdk
      libraries.SDL
      libraries.jpeg
      libraries.freetype
      libraries.zlib
      libraries.libpng
      libraries.SDLPackages.image
      libraries.SDLPackages.ttf
    ];
  };
in {
  gameOfLife = stdenv.mkDerivation {
    name = "game_of_life_for_psp_with_sdl";

    buildInputs = [ pspsdkEnv ];

    patchPhase = ''
      sed -i 's;"SDL/SDL.h";<SDL.h>;g' main.c
    '';

    installPhase = ''
      mkdir -p $out/nix-support
      ${zip}/bin/zip -r jeux_de_la_vie.zip jeux_de_la_vie/*
      chmod a+rw jeux_de_la_vie.zip
      cp jeux_de_la_vie.zip $out/
      echo "file psp-homebrew $out/jeux_de_la_vie.zip" >> $out/nix-support/hydra-build-products
    '';

    src = fetchFromGitHub {
      repo = "game_of_life_for_psp_with_sdl";
      owner = "Hettomei";
      rev = "8346579a9975f41763b2381cfb601900a9a84e6e";
      sha256 = "tz96Pf4RS2L1wcJ2HYr4+dltHdzTNi3YNcrqhLOXIjQ=";
    };

    dontStrip = true;
    dontDisableStatic = true;
    hardeningDisable = [ "all" ];
  };
}
