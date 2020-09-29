{ stdenv, lib, autoreconfHook, zlib, which, stage2gcc, binutils, fetchFromGitHub, file, ... }:

stdenv.mkDerivation {
  name = "psp-sdk";

  src = fetchFromGitHub {
    repo = "pspsdk";
    owner = "pspdev";
    rev = "30c8272ba3a159c68bd31c18c7cbe5b25843ba66";
    sha256 = "lWYAuhv/l4E4GlKNJ6O3FakeH3TcDhM09HzxY+2Wuuo=";
  };

  buildInputs = [ zlib.dev file autoreconfHook which binutils stage2gcc ];

  configureScript = "../configure";

  configureFlags = [
    "--with-pspdev=$(out)"
  ];

  makeFlags = [ "all" "install" ];

  preConfigure = ''
    mkdir -p $out/
    cp -a ${binutils}/* $out/
    chmod -R +w $out/
    cp -a ${stage2gcc}/* $out/
    chmod -R +w $out/
    mkdir build-psp
    cd build-psp
  '';

  dontInstall = true;
  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
