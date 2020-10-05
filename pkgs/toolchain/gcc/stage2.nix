{ stdenv, lib, binutils, stage1, file, ... }:

let
  gccDepsLibs = import ./libs.nix;
in stdenv.mkDerivation {
  name = "psp-gcc";

  src = fetchTree {
    type = "tarball";
    url = "https://github.com/pspdev/gcc/archive/9a856f00119f87b2927fa9d03279f3513e656a5d.tar.gz";
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
    cp -a ${stage1.newlib}/* $out/
    chmod -R +w $out/
    cp -a ${stage1.pspsdk}/* $out/
    chmod -R +w $out/

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

  enableParallelBuilding = true;
}
