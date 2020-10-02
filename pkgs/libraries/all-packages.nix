{ lib, callPackage, newlibVersion, toolchain, ... }:

let
  buildLibrary = name: { libraries ? null, }: callPackage (./. + "/${name}/default.nix") {
    pspsdk = (if libraries != null then toolchain.pspsdk.withLibraries libraries else toolchain.pspsdk);
  };
in lib.mergeAttrs (rec {
  pspirkeyb = buildLibrary "pspirkeyb" {};
  libbulletml = buildLibrary "libbulletml" {};
  libmad = buildLibrary "libmad" {};
  libogg = buildLibrary "libogg" {};
  libvorbis = buildLibrary "libvorbis" { libraries = [ libogg ]; };
  libtremor = buildLibrary "libtremor" {};
  jpeg = buildLibrary "jpeg" {};
  pspgl = buildLibrary "pspgl" {};
  SDL = buildLibrary "SDL" { libraries = [ pspirkeyb ]; };

  SDLPackages = import ./SDLPackages/default.nix { 
    inherit callPackage;
    inherit (toolchain) pspsdk;
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
  expat = buildLibrary "expat" {};
  libyaml = buildLibrary "libyaml" {};
  zziplib = buildLibrary "zziplib" { libraries = [ zlib ]; };
  pixman = buildLibrary "pixman" { libraries = [ libpng ]; };
  opentri = buildLibrary "opentri" { libraries = [ zlib freetype libpng ]; };
  angelscript = buildLibrary "angelscript" { libraries = [ cmakeScript ]; };

  cmakeScript = callPackage ./cmake.nix {};
}) (if newlibVersion != "3.3.0" then {
  pthreads-emb = buildLibrary "pthreads-emb" {};
} else {})
