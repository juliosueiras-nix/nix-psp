{ stdenv, lib, which, pspsdk, binutils, ncurses, texinfo4, file, x11
, ... }:

stdenv.mkDerivation {
  name = "psp-insight";

  src = fetchTree {
    type = "tarball";
    url = "https://github.com/pspdev/insight/archive/3b4fd64838d5b69aca9400ebba0188da72e2bbb0.tar.gz";
    narHash = "sha256-G6Qy+HR8rSEIsOKY0FqNIE8PJVXIHWMMr8eWq+0GVFI=";
  };


  buildInputs = [ file texinfo4 pspsdk x11 ncurses.dev ];

  configureScript = "../configure";

  configureFlags = [ "--target=psp" "--disable-werror" "--disable-nls" ];

  preConfigure = ''
    mkdir build-psp
    cd build-psp
  '';

  dontDisableStatic = true;

  hardeningDisable = [ "format" ];
}
