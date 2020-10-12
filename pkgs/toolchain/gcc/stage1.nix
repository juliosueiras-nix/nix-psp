{ src, stdenv, lib, flex, binutils, file, ... }:

let
  gccDepsLibs = import ./libs.nix;
in stdenv.mkDerivation {
  name = "psp-gcc";

  inherit src;

  buildInputs = [ file binutils flex ];

  configureScript = "../configure";

  configureFlags = [
    "--with-as=${binutils}/bin/psp-as"
    "--with-ar=${binutils}/bin/psp-ar"
    "--with-ld=${binutils}/bin/psp-ld"
    "--target=psp"
    "--enable-lto"
    "--with-newlib"
    "--without-headers"
    "--disable-libssp"
    "--enable-languages=c"
  ];

  preConfigure = ''
    ln -fs ${gccDepsLibs.gmpLib} gmp
    ln -fs ${gccDepsLibs.mpcLib} mpc
    ln -fs ${gccDepsLibs.mpfrLib} mpfr
    ln -fs ${gccDepsLibs.islLib} isl

    mkdir build-psp
    cd build-psp
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
