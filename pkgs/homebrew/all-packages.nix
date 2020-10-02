{ callPackage, symlinkJoin, pspsdk, libraries }:

let
  buildHomebrew = path: { libraries ? [] }: let
    pspsdkEnv = symlinkJoin {
      name = "pspsdk-env";
      paths = [ pspsdk ] ++ libraries ;
    };
  in callPackage path { pspsdk = pspsdkEnv; };
in {
  gameOfLife = buildHomebrew ./game_of_life {
    libraries = [
      libraries.SDL
      libraries.jpeg
      libraries.freetype
      libraries.zlib
      libraries.libpng
      libraries.SDLPackages.image
      libraries.SDLPackages.ttf
    ];
  };

  dungeon = buildHomebrew ./dungeon {
    libraries = [
      libraries.libpspvram
      libraries.jpeg
      libraries.pspgl
      libraries.zlib
      libraries.pspirkeyb
      libraries.libpng
    ];
  };
}
