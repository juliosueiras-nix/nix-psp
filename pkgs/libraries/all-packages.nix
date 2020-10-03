{ lib, callPackage, newlibVersion, toolchain, ... }:

let
  buildLibrary = name:
    { libraries ? null, }:
    callPackage (./. + "/${name}/default.nix") {
      pspsdk = (if libraries != null then
        toolchain.pspsdk.withLibraries libraries
      else
        toolchain.pspsdk);
    };

  mainLibraries = (rec {
    pspirkeyb = buildLibrary "pspirkeyb" { };
    libbulletml = buildLibrary "libbulletml" { };
    libmad = buildLibrary "libmad" { };
    libogg = buildLibrary "libogg" { };
    libvorbis = buildLibrary "libvorbis" { libraries = [ libogg ]; };
    libtremor = buildLibrary "libtremor" { };
    jpeg = buildLibrary "jpeg" { };
    pspgl = buildLibrary "pspgl" { };
    squirrel = buildLibrary "squirrel" { };
    smpeg-psp = buildLibrary "smpeg-psp" { libraries = [ SDL ]; };
    SDL = buildLibrary "SDL" { libraries = [ pspirkeyb ]; };

    SDLPackages = import ./SDLPackages/default.nix {
      inherit callPackage;
      inherit (toolchain) pspsdk;
      libraries = { inherit SDL libmikmod libpng jpeg freetype; };
    };

    SDL2Packages = import ./SDL2Packages/default.nix {
      inherit callPackage;
      inherit (toolchain) pspsdk;
      libraries = { inherit SDL2 libmikmod libpng jpeg freetype; };
    };

    SDL2 = buildLibrary "SDL2" { libraries = [ pspgl libpspvram ]; };
    bzip2 = buildLibrary "bzip2" { };
    sqlite = buildLibrary "sqlite" { };
    libpspvram = buildLibrary "libpspvram" { };
    libmikmod = buildLibrary "libmikmod" { };
    zlib = buildLibrary "zlib" { };
    libpng = buildLibrary "libpng" { libraries = [ zlib ]; };
    freetype = buildLibrary "freetype" { libraries = [ zlib ]; };
    lua = buildLibrary "lua" { };
    expat = buildLibrary "expat" { };
    libyaml = buildLibrary "libyaml" { };
    zziplib = buildLibrary "zziplib" { libraries = [ zlib ]; };
    pixman = buildLibrary "pixman" { libraries = [ libpng ]; };
    opentri = buildLibrary "opentri" { libraries = [ zlib freetype libpng ]; };
    angelscript = buildLibrary "angelscript" { libraries = [ cmakeScript ]; };

    cmakeScript = callPackage ./cmake.nix { };
  });
in lib.mergeAttrs mainLibraries (if newlibVersion != "3.3.0" then rec {
  pthreads-emb = buildLibrary "pthreads-emb" { };
  openal = buildLibrary "openal" {
    libraries =
      [ mainLibraries.cmakeScript toolchain.tools.psp-pkgconf pthreads-emb ];
  };
} else
  { })
