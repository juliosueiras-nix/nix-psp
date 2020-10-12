{ src, stdenv, lib, which, pspsdk, binutils, texinfo4, readline, ncurses, libusb, file, ... }:

stdenv.mkDerivation {
  name = "psplinkusb";

  inherit src;

  buildInputs = [ file texinfo4 pspsdk binutils readline ncurses libusb ];

  patchPhase = ''
    find . -name "Makefile" -exec sed -i "s|PREFIX=.*|PREFIX=$out|g" {} \; -exec sed -i 's|lcurses|lncurses|g' {} \;
  '';

  PSPSDK = "${pspsdk}";

  makefile = "Makefile.clients";

  dontDisableStatic = true;
}
