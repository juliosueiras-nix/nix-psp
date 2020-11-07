{ stdenv, pspsdk, zip, fetchFromGitHub, ... }:

let
  oslib = fetchTree {
    type = "git";
    url = "https://github.com/liclac/oslibmodv2";
    rev = "bc3484fa1cc38932aa053bfe0a0d2fdb046c4340";
  };
in stdenv.mkDerivation {
  name = "VNPSP";

  PSPDEV = "${pspsdk}";

  src = fetchTree {
    type = "git";
    url = "https://github.com/liclac/VNPSP";
    rev = "4ebccd9596431b243390c53c3bb8f966c39c522d";
  };

  buildInputs = [ pspsdk ];

  patchPhase = ''
    rm -rf lib/oslib/*
    cp -a ${oslib}/* lib/oslib/
    substituteInPlace Makefile --replace 'INCDIR   = lib' 'INCDIR = lib ${pspsdk}/psp/include'  --replace 'LIBDIR  = ' 'LIBDIR = ${pspsdk}/psp/lib' --replace '-lpng' ''' --replace '-lz' ''' --replace '-losl' '-losl -lpng -lz -lm'
  '';

  installPhase = ''
    mkdir -p $out/nix-support
    ${zip}/bin/zip vnpsp.zip EBOOT.PBP
    cp vnpsp.zip $out/
    echo "file psp-homebrew $out/vnpsp.zip" >> $out/nix-support/hydra-build-products
  '';

  dontStrip = true;
  dontPatchELF = true;
  dontDisableStatic = true;
  hardeningDisable = [ "all" ];
}
