{ stdenv, fetchurl, ... }:

let BINUTILS_VERSION = "2.23.2";
in stdenv.mkDerivation {
  name = "psp-binutils";

  src = fetchTarball {
    url =
      "https://ftp.gnu.org/pub/gnu/binutils/binutils-${BINUTILS_VERSION}.tar.bz2";
    sha256 = "10lsd4xj2pmjzafq4rzgpdawn2wkrwyzkb48wjlsm8dp5sx533lx";
  };

  configureFlags = [
    "--target=psp"
    "--enable-install-libbfd"
    "--disable-werror"
    "--with-system-zlib"
  ];

  patches = [
    (fetchurl {
      url =
        "https://raw.githubusercontent.com/pspdev/psptoolchain/master/patches/binutils-${BINUTILS_VERSION}-PSP.patch";
      sha256 = "FV10md1l1JbsB23HHZPbnAwvnN8/quhnHZaWdTRr9Mk=";
    })
  ];

  dontStrip = true;
  dontDisableStatic = true;
  hardeningDisable = [ "all" ];
}

