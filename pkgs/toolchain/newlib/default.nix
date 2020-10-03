{ stdenv, lib, texinfo, version, which, stage1, binutils, fetchFromGitHub, file
, ... }:

let
  versions = {
    "3.3.0" = {
      rev = "7b50ff4d76f58e26fb33f6a4ea5f3a067ffe95be";
      sha256 = "d8c/qiT6Ml1d+sI2U7mJbW8LS7EzPdlFG6a+WiBlmtM=";
    };

    "1.20.0" = {
      rev = "6dc26bb7f8bdc7dff72a811104e1d654d77f75d9";
      sha256 = "lapI6bBzSINIdkQjyu9B8PeegJNFERPq6huWj3zbPUo=";
    };
  };
in stdenv.mkDerivation {
  name = "psp-newlib-${version}";
  inherit version;

  src = fetchFromGitHub {
    repo = "newlib";
    owner = "pspdev";
    inherit (versions."${version}") rev sha256;
  };

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
