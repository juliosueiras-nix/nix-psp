{ src, stdenv, lib, bison, flex, texinfo, which, pspsdk, binutils, readline, zlib, fetchurl, file, ... }:

stdenv.mkDerivation {
  name = "psp-gdb";

  inherit src;

  buildInputs = [ file bison flex texinfo pspsdk binutils readline.dev zlib.dev ];

  configureScript = "../configure";

  configureFlags = [
    "--target=psp"
    "--disable-werror"
    "--disable-nls"
    "--disable-binutils"
    "--disable-ld"
    "--disable-gprof"
    "--disable-gold"
    "--disable-gas"
    "--disable-elfcpp"
    "--with-system-zlib"
    "--with-system-readline"
  ];

  preConfigure = ''
    mkdir build-psp
    cd build-psp
  '';

  dontDisableStatic = true;
}
