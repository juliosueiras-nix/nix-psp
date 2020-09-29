{ stdenv, lib, fetchurl, binutils, stage1gcc, pspsdkLib, newlib, file, ... }:

let
  GCC_VERSION = "9.3.0";
  gccDepsLibs = import ./libs.nix;

in stdenv.mkDerivation {
  name = "psp-gcc";
  src = fetchTarball {
    url =
      "https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz";
    sha256 = "15cyd8gwcyy0cxd4iarb6ns3qfs6vywqhwi6f78sx9h9sr7q52qq";
  };

  buildInputs = [ file binutils ];

  configureScript = "../configure";

  configureFlags = [
    "--with-as=${binutils}/bin/psp-as"
    "--with-ar=${binutils}/bin/psp-ar"
    "--with-ld=${binutils}/bin/psp-ld"
    "--target=psp"
    "--enable-lto"
    "--with-newlib"
    "--enable-languages=c,c++"
    "--enable-cxx-flags=-G0"
  ];

  preConfigure = ''
    mkdir -p $out
    cp -a ${newlib}/* $out/
    chmod -R +w $out/
    cp -a ${pspsdkLib}/* $out/
    chmod -R +w $out/

    ln -fs ${gccDepsLibs.gmpLib} gmp
    ln -fs ${gccDepsLibs.mpcLib} mpc
    ln -fs ${gccDepsLibs.mpfrLib} mpfr
    ln -fs ${gccDepsLibs.islLib} isl

    mkdir build-psp
    cd build-psp
  '';

  patches = [
    (fetchurl {
      url =
        "https://raw.githubusercontent.com/pspdev/psptoolchain/bffc9c7ad096965813df3ad90620f43343805fd6/patches/gcc-${GCC_VERSION}-PSP.patch";
      sha256 = "f3etsCyDAP9aYTBiKAFTQJY+M7SaQXcteiZZItc6n+w=";
    })
  ];

  hardeningDisable = [ "format" ];

  dontDisableStatic = true;

  enableParallelBuilding = true;
}
