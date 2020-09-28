{ stdenv, lib, texinfo, which, pspsdk, binutils, readline, zlib, fetchurl, file, ... }:

let
  GDB_VERSION = "7.5.1";
in stdenv.mkDerivation {
  name = "psp-gdb";

  src = fetchurl {
    url = "https://ftp.gnu.org/gnu/gdb/gdb-${GDB_VERSION}.tar.bz2";
    sha256 = "BwuAjSifqPApFzjurMwM13ANR2mYeB9XKFYVUkDSnSA=";
  };

  buildInputs = [ file texinfo pspsdk binutils readline.dev zlib.dev ];

  patches = [
    (fetchurl {
      url =
        "https://raw.githubusercontent.com/pspdev/psptoolchain/bffc9c7ad096965813df3ad90620f43343805fd6/patches/gdb-${GDB_VERSION}-PSP.patch";
      sha256 = "vxb1S15Um+8AYgKT41CayJDMiy4NCFy6PEnujIewfCE=";
    })
    (fetchurl {
      url =
        "https://raw.githubusercontent.com/pspdev/psptoolchain/bffc9c7ad096965813df3ad90620f43343805fd6/patches/gdb-${GDB_VERSION}-fixes.patch";
      sha256 = "vlvfmgO+zYbzdzkPTfV7X+lHKi0d4IAFJUQeO4+CHc8=";
    })
  ];

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
