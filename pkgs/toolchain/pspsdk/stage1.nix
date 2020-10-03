{ stdenv, pspsdkSrc, lib, autoreconfHook, which, stage1, binutils, fetchFromGitHub, file
, ... }:

stdenv.mkDerivation {
  name = "psp-sdk";

  src = pspsdkSrc;

  buildInputs = [ file autoreconfHook which stage1.gcc binutils ];

  configureScript = "../configure";

  configureFlags = [ "--with-pspdev=$(out)" ];

  preConfigure = ''
    mkdir build-psp
    cd build-psp
  '';

  buildPhase = ''
    make install-data
  '';

  dontInstall = true;
  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
