{ src, stdenv, ... }:

stdenv.mkDerivation {
  name = "psp-binutils";

  inherit src;

  configureFlags = [
    "--target=psp"
    "--enable-install-libbfd"
    "--disable-werror"
    "--with-system-zlib"
  ];

  dontStrip = true;
  dontDisableStatic = true;
  hardeningDisable = [ "all" ];
}

