{ stdenv, lib, which, pspsdk, binutils, ncurses, texinfo4, file, x11
, ... }:

stdenv.mkDerivation {
  name = "psp-insight";

  src = fetchTree {
    type = "git";
    url = "https://github.com/pspdev/insight";
    rev = ":b4fd64838d5b69aca9400ebba0188da72e2bbb0";
  };

  buildInputs = [ file texinfo4 pspsdk binutils x11 ncurses.dev ];

  configureScript = "../configure";

  configureFlags = [ "--target=psp" "--disable-werror" "--disable-nls" ];

  preConfigure = ''
    mkdir build-psp
    cd build-psp
  '';

  dontDisableStatic = true;

  hardeningDisable = [ "format" ];
}
