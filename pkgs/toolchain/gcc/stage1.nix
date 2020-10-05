{ stdenv, lib, flex binutils, file, ... }:

let
  gccDepsLibs = import ./libs.nix;
in stdenv.mkDerivation {
  name = "psp-gcc";

  src = fetchTree {
    type = "tarball";
    url = "https://github.com/pspdev/gcc/archive/9a856f00119f87b2927fa9d03279f3513e656a5d.tar.gz";
    narHash = "sha256-6cHIEw5kbtJS+g2Mdo2WGiSgxXQM2/Y+K2zZMhqUxNc=";
  };

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
