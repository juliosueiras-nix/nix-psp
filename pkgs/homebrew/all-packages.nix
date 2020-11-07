{ callPackage, pspsdk, libraries }:

let
  buildHomebrew = path:
    { libraries ? [ ] }:
    callPackage path { pspsdk = pspsdk.withLibraries libraries; };
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

  vnpsp = buildHomebrew ./vnpsp {
    libraries = [
      libraries.jpeg
      libraries.zlib
      libraries.libpng
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
