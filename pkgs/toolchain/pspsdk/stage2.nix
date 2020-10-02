{ stdenv, lib, autoreconfHook, zlib, symlinkJoin, which, stage2, binutils, fetchFromGitHub, file, ... }:

let
  self = stdenv.mkDerivation {
    name = "psp-sdk";

    src = fetchFromGitHub {
      repo = "pspsdk";
      owner = "pspdev";
      rev = "30c8272ba3a159c68bd31c18c7cbe5b25843ba66";
      sha256 = "lWYAuhv/l4E4GlKNJ6O3FakeH3TcDhM09HzxY+2Wuuo=";
    };

    buildInputs = [ zlib.dev file autoreconfHook which binutils stage2.gcc ];

    configureScript = "../configure";

    configureFlags = [
      "--with-pspdev=$(out)"
      ];

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
        withLibraries = libraries: symlinkJoin {
          name = "pspsdk-env";
          paths = [ self ] ++ libraries;
        };
      };

      dontInstall = true;
      dontDisableStatic = true;
      dontStrip = true;
      hardeningDisable = [ "all" ];
    };
in self
