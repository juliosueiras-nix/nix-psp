{ src, callPackage, stdenv, lib, autoreconfHook, zlib, symlinkJoin, which, stage2, binutils
, fetchFromGitHub, file, ... }:

let
  self = stdenv.mkDerivation {
    name = "psp-sdk";

    inherit src;

    buildInputs = [ zlib.dev file autoreconfHook which binutils stage2.gcc ];

    configureScript = "../configure";

    configureFlags = [ "--with-pspdev=$(out)" ];

    makeFlags = [ "all" "install" ];

    preConfigure = ''
      mkdir -p $out/
      cp -a ${binutils}/* $out/
      chmod -R +w $out/
      cp -a ${stage2.gcc}/* $out/
      chmod -R +w $out/
      mkdir build-psp
      cd build-psp
    '';

    passthru = {
      withLibraries = libraries:
        symlinkJoin {
          name = "pspsdk-env";
          paths = libraries ++ [ self ];
        };

      makeDocs = callPackage ./docs.nix { inherit stage2; } src;
    };

    dontInstall = true;
    dontDisableStatic = true;
    dontStrip = true;
    hardeningDisable = [ "all" ];
  };
in self
