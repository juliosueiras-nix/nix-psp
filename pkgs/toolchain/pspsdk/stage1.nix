{ stdenv, lib, autoreconfHook, which, stage1gcc, binutils, fetchFromGitHub, file, ... }:

stdenv.mkDerivation {
  name = "psp-sdk";

  src = fetchFromGitHub {
    repo = "pspsdk";
    owner = "pspdev";
    rev = "30c8272ba3a159c68bd31c18c7cbe5b25843ba66";
    sha256 = "lWYAuhv/l4E4GlKNJ6O3FakeH3TcDhM09HzxY+2Wuuo=";
  };

  buildInputs = [ file autoreconfHook which stage1gcc binutils ];

  configureScript = "../configure";

  configureFlags = [
    "--with-pspdev=$(out)"
  ];

  preConfigure = ''
    mkdir build-psp
    cd build-psp
  '';

  buildPhase = ''
    make install-data
  '';

  dontInstall = true;
  dontDisableStatic = true;
}
