{ stdenv, pspsdk, zip, fetchFromGitHub, ... }:

stdenv.mkDerivation {
  name = "Simple-Dungeon-Generator-PSP";

  PSPDEV = "${pspsdk}";

  buildInputs = [ pspsdk ];

  patchPhase = ''
    sed -i 's;INCDIR += ./include;INCDIR += ./include ${pspsdk}/psp/include;g' Makefile
    sed -i 's;-L''${PSPDEV}/psp;-L''${PSPDEV}/psp/lib;g' Makefile
  '';

  installPhase = ''
    mkdir -p $out/nix-support
    cd bin
    ${zip}/bin/zip dungeon.zip EBOOT.PBP
    cp dungeon.zip $out/
    echo "file psp-homebrew $out/dungeon.zip" >> $out/nix-support/hydra-build-products
  '';

  src = fetchFromGitHub {
    repo = "Simple-Dungeon-Generator-PSP";
    owner = "stacksta";
    rev = "e96e41743e828434f4fc8f41a50a3bba17cb6aca";
    sha256 = "pD8RxXPJEY8By/naC/5UBnDVTVbdTTLWJsPe1iqh0mY=";
  };

  dontStrip = true;
  dontPatchELF = true;
  dontDisableStatic = true;
  hardeningDisable = [ "all" ];
}
