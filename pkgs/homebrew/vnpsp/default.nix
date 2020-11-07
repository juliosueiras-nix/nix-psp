{ stdenv, pspsdk, zip, fetchFromGitHub, ... }:

stdenv.mkDerivation {
  name = "VNPSP";

  PSPDEV = "${pspsdk}";

  buildInputs = [ pspsdk ];

  patchPhase = ''
    substituteInPlace Makefile --replace 'INCDIR   = lib' 'INCDIR = ${pspsdk}/psp/include'  --replace 'LIBDIR  = ' 'LIBDIR = ${pspsdk}/psp/lib' --replace '-lpng' ''' --replace '-lz' ''' --replace '-losl' ''' --replace '-Llib/oslib' '-losl -lpng -lz -lm'
    rm -rf lib
  '';

  installPhase = ''
    mkdir -p $out/nix-support
    ${zip}/bin/zip vnpsp.zip EBOOT.PBP
    cp vnpsp.zip $out/
    echo "file psp-homebrew $out/vnpsp.zip" >> $out/nix-support/hydra-build-products
  '';

  src = fetchTree {
    type = "git";
    url = "https://github.com/liclac/VNPSP";
    rev = "4ebccd9596431b243390c53c3bb8f966c39c522d";
  };

  dontStrip = true;
  dontPatchELF = true;
  dontDisableStatic = true;
  hardeningDisable = [ "all" ];
}
