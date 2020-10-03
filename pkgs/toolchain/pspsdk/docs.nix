{ stdenv, lib, autoreconfHook, zlib, which, stage2, binutils, doxygen, file, ... }:

src: stdenv.mkDerivation {
  name = "psp-sdk-docs";

  inherit src;

  buildInputs = [ doxygen zlib.dev file autoreconfHook which binutils stage2.gcc ];

  makeFlags = [ "doxygen-doc" ];

  configureScript = "../configure";

  configureFlags = [ "--with-pspdev=$(out)" ];

  preConfigure = ''
      mkdir -p $out/
      cp -a ${binutils}/* $out/
      chmod -R +w $out/
      cp -a ${stage2.gcc}/* $out/
      chmod -R +w $out/
      mkdir build-psp
      cd build-psp
  '';

  dontInstall = true;
  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
