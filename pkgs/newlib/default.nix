{ stdenv, lib, texinfo, which, pspsdkLib, stage1gcc, binutils, fetchFromGitHub, file, ... }:

stdenv.mkDerivation {
  name = "psp-newlib";

  src = fetchFromGitHub {
    repo = "newlib";
    owner = "pspdev";
    rev = "6dc26bb7f8bdc7dff72a811104e1d654d77f75d9";
    sha256 = "lapI6bBzSINIdkQjyu9B8PeegJNFERPq6huWj3zbPUo=";
  };

  buildInputs = [ file texinfo stage1gcc binutils ];

  configureScript = "../configure";

  CFLAGS = "-I${pspsdkLib}/include";

  configureFlags = [
    "--target=psp"
    "--enable-newlib-iconv" 
    "--enable-newlib-multithread" 
    "--enable-newlib-mb"
  ];

  preConfigure = ''
    mkdir build-psp
    cd build-psp
  '';

  postInstall = ''
    mv $out/psp/* $out/
    rm -rf $out/psp
  '';
}
