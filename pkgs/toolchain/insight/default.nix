{ stdenv, lib, which, pspsdk, binutils, ncurses, texinfo4, fetchurl, file, x11
, ... }:

let INSIGHT_VERSION = "6.8";
in stdenv.mkDerivation {
  name = "psp-insight";

  src = fetchurl {
    url =
      "https://sourceware.org/pub/insight/releases/insight-${INSIGHT_VERSION}a.tar.bz2";
    sha256 = "8Y+/X2669Bx+K3hVE7DEb7A8F8YjC6+1wgq/nYUDvF0=";
  };

  buildInputs = [ file texinfo4 pspsdk binutils x11 ncurses.dev ];

  patches = [
    (fetchurl {
      url =
        "https://raw.githubusercontent.com/pspdev/psptoolchain/bffc9c7ad096965813df3ad90620f43343805fd6/patches/insight-${INSIGHT_VERSION}-PSP.patch";
      sha256 = "MKMk0S7h6+FPXhmBgkUWr6kPRIeLoqGTTF5pp20B28Y=";
    })
  ];

  configureScript = "../configure";

  configureFlags = [ "--target=psp" "--disable-werror" "--disable-nls" ];

  preConfigure = ''
    mkdir build-psp
    cd build-psp
  '';

  dontDisableStatic = true;

  hardeningDisable = [ "format" ];
}
