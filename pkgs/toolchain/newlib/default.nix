{ src, stdenv, lib, texinfo, version, which, stage1, binutils, fetchFromGitHub, file , ... }:

stdenv.mkDerivation {
  name = "psp-newlib-${version}";
  inherit version src;

  buildInputs = [ file texinfo stage1.gcc binutils ];

  configureScript = "../configure";

  configureFlags = [
    "--target=psp"
    "--enable-newlib-iconv"
    "--enable-newlib-multithread"
    "--enable-newlib-mb"
  ];

  preConfigure = ''
    mkdir -p $out/psp
    cp -a ${stage1.pspsdk}/psp/* $out/psp
    chmod -R +w $out/psp/sdk
    mkdir build-psp
    cd build-psp
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];

  postInstall = ''
    rm -rf $out/psp/sdk
  '';
}
