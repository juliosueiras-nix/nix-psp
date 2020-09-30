{ callPackage, buildEnv, pspsdk, ... }:

let
  buildPSPEnv = libraries: buildEnv {
    name = "pspsdk-env";
    paths = [ pspsdk ] ++ libraries;
  };
  buildLibrary = name: { libraries ? null, postBuild ? "" }: callPackage (./. + "/${name}/default.nix") {
    pspsdk = (if libraries != null then buildPSPEnv libraries else pspsdk);
  };
in rec {
  pspirkeyb = buildLibrary "pspirkeyb" {};
  jpeg = buildLibrary "jpeg" {};
  pspgl = buildLibrary "pspgl" {};
  SDL = buildLibrary "SDL" { libraries = [ pspirkeyb ]; };

  SDLPackages = import ./SDLPackages/default.nix { 
    pspsdk = buildPSPEnv [ SDL ];
    inherit callPackage buildPSPEnv;
    libraries = {
      inherit SDL libmikmod libpng jpeg freetype;
    };
  };

  SDL2 = buildLibrary "SDL2" { libraries = [ pspgl libpspvram ]; };
  bzip2 = buildLibrary "bzip2" {};
  sqlite = buildLibrary "sqlite" {};
  libpspvram = buildLibrary "libpspvram" {};
  libmikmod = buildLibrary "libmikmod" {};
  zlib = buildLibrary "zlib" {};
  libpng = buildLibrary "libpng" { libraries = [ zlib ]; };
  freetype = buildLibrary "freetype" { libraries = [ zlib ]; };
  lua = buildLibrary "lua" {};
  angelscript = buildLibrary "angelscript" { libraries = [ cmakeScript ]; };

  cmakeScript = callPackage ./cmake.nix {};
}
