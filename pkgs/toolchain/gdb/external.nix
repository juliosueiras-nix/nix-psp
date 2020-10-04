{ stdenv, lib, texinfo, which, pspsdk, binutils, readline, zlib, fetchurl, file, ... }:

stdenv.mkDerivation {
  name = "psp-gdb";

  src = fetchTree {
    type = "git";
    url = "https://github.com/pspdev/gdb";
    rev = "$(git rev-parse HEAD:)";
  };

  buildInputs = [ file texinfo pspsdk binutils readline.dev zlib.dev ];

  configureScript = "../configure";

  configureFlags = [
    "--target=psp"
    "--disable-werror"
    "--disable-nls"
    "--with-system-zlib"
    "--with-system-readline"
  ];

  preConfigure = ''
    mkdir build-psp
    cd build-psp
  '';

  dontDisableStatic = true;
}
