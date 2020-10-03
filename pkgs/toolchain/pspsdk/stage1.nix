{ stdenv, lib, autoreconfHook, which, stage1, binutils, fetchFromGitHub, file
, ... }:

stdenv.mkDerivation {
  name = "psp-sdk";

  src = fetchFromGitHub {
    repo = "pspsdk";
    owner = "pspdev";
    rev = "3de82931a6acaa9fa51a41528ad581d736457618";
    sha256 = "zMRskuTApByGozDJnYaV61b1gYwMcp0mRRUrXndqMxs=";
  };

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
