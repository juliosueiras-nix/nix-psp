{ stdenv, lib, bison, flex, texinfo, which, pspsdk, binutils, readline, zlib, fetchurl, file, ... }:

stdenv.mkDerivation {
  name = "psp-gdb";

  src = fetchTree {
    type = "git";
    url = "https://github.com/pspdev/gdb";
    rev = "d773a3425a9b9d8d01d317b280a5eb2ca35e607c";
  };

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
