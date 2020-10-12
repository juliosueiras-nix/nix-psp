{ srcs, impureMode, lib, fetchFromGitHub, callPackage, allowCFWSDK, newlibVersion, toolchain, ... }:

let
  buildLibrary = name:
    { src, libraries ? null, }:
    callPackage (./. + "/${name}/default.nix") {
      inherit src;
      pspsdk = (if libraries != null then
        toolchain.pspsdk.withLibraries libraries
      else
        toolchain.pspsdk);
    };

    psp-ports = if impureMode then srcs.libraries.psp-ports else fetchFromGitHub {
      repo = "psp-ports";
      owner = "pspdev";
      rev = "8804b97c955a156e75f1b552b8a5aae9713f674f";
      sha256 = "x09wM/AfeYgKoTRmxsr7iEG84VLzP2DCksAeHVWRCh0=";
    };

  mainLibraries = (rec {

    pspirkeyb = buildLibrary "pspirkeyb" {
      src = "${psp-ports}/pspirkeyb";
    };
    lua = buildLibrary "lua" {
      src = "${psp-ports}/lua";
    };
    libogg = buildLibrary "libogg" {
      src = "${psp-ports}/libogg";
    };
    libtremor = buildLibrary "libtremor" { 
      src = "${psp-ports}/libTremor";
    };
    libmad = buildLibrary "libmad" {
      src = "${psp-ports}/libmad";
    };
    libvorbis = buildLibrary "libvorbis" { 
      src = "${psp-ports}/libvorbis";
      libraries = [ libogg ];
    };
    zziplib = buildLibrary "zziplib" { 
      src = "${psp-ports}/zziplib";
      libraries = [ zlib ];
    };
    libbulletml = buildLibrary "libbulletml" {
      src = "${psp-ports}/libbulletml";
    };
    jpeg = buildLibrary "jpeg" {
      src = "${psp-ports}/jpeg";
    };

    pspgl = buildLibrary "pspgl" {
      src = if impureMode then srcs.libraries.pspgl else fetchFromGitHub {
        repo = "pspgl";
        owner = "pspdev";
        rev = "30ffef7bb75ba70eccede93288d7bb429a2e4709";
        sha256 = "o9Cu5Ywer+HbNp0iZ5VDKyP35326+op4LxP0asWO4kI=";
      };
    };


    SDL = buildLibrary "SDL" { src = null; libraries = [ pspirkeyb ]; };
    SDLPackages = import ./SDLPackages/default.nix {
      inherit callPackage impureMode srcs;
      inherit (toolchain) pspsdk;
      libraries = { inherit SDL libmikmod libpng jpeg freetype; };
    };

    SDL2 = buildLibrary "SDL2" { src = null; libraries = [ pspgl libpspvram ]; };
    SDL2Packages = import ./SDL2Packages/default.nix {
      inherit callPackage;
      inherit (toolchain) pspsdk;
      libraries = { inherit SDL2 libmikmod libpng jpeg freetype; };
    };

    bzip2 = buildLibrary "bzip2" { src = null; };
    sqlite = buildLibrary "sqlite" { src = null; };
    expat = buildLibrary "expat" { src = null; };
    squirrel = buildLibrary "squirrel" { src = null; };
    smpeg-psp = buildLibrary "smpeg-psp" { src = null; libraries = [ SDL ]; };
    libmikmod = buildLibrary "libmikmod" { src = null; };
    zlib = buildLibrary "zlib" { src = null; };
    libpng = buildLibrary "libpng" { src = null; libraries = [ zlib ]; };
    libyaml = buildLibrary "libyaml" { src = null; };
    pixman = buildLibrary "pixman" { src = null; libraries = [ libpng ]; };
    opentri = buildLibrary "opentri" { src = null; libraries = [ zlib freetype libpng ]; };
    angelscript = buildLibrary "angelscript" { libraries = [ cmakeScript ]; };

    libpspvram = buildLibrary "libpspvram" {
      src = if impureMode then srcs.libraries.libpspvram else fetchFromGitHub {
        repo = "libpspvram";
        owner = "pspdev";
        rev = "5b6fabfc6e2804473ad77521e1521d50f609c78b";
        sha256 = "kMMcbf1Z6qYNnENrrD8CYmjUTM5j3d+aXhvFnNI2in0=";
      };
    };

    freetype = buildLibrary "freetype" { 
      src = if impureMode then srcs.libraries.freetype else fetchFromGitHub {
        repo = "freetype2";
        owner = "pspdev";
        rev = "freetype2-psp";
        sha256 = "p6phT3SYRlsnbhauXV/haL2WY5ZyU0FXZhEAJcSe7Oo=";
      };
      libraries = [ zlib ];
    };

    cmakeScript = callPackage ./cmake.nix {
      src = if impureMode then srcs.libraries.psplibraries else fetchFromGitHub {
        repo = "psplibraries";
        owner = "pspdev";
        rev = "9d4afd89ee8983e647e9207a8d738159aceb35ef";
        sha256 = "0h9bk2rv27rs0lpk0qdlrpavf8pzf35aszgnqgl2f8j72b3hgg16";
      };
    };

    thirdparty = import ./thirdparty/all-packages.nix {
      inherit toolchain callPackage allowCFWSDK;
    };
  });
in lib.mergeAttrs mainLibraries (if newlibVersion != "3.3.0" then rec {
  pthreads-emb = buildLibrary "pthreads-emb" { src = null; };
  openal = buildLibrary "openal" {
    src = null;
    libraries =
      [ mainLibraries.cmakeScript toolchain.tools.psp-pkgconf pthreads-emb ];
  };
} else
  { })
