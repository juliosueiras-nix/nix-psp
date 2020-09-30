{ stdenv, fetchFromGitHub, pspsdk, ... }:

stdenv.mkDerivation {
  name = "lua";

  src = "${fetchFromGitHub {
    repo = "psp-ports";
    owner = "pspdev";
    rev = "8804b97c955a156e75f1b552b8a5aae9713f674f";
    sha256 = "x09wM/AfeYgKoTRmxsr7iEG84VLzP2DCksAeHVWRCh0=";
  }}/lua";

  buildInputs = [ pspsdk ];

  PSPDIR_OUT = "$(out)/psp";

  makefile = "Makefile.psp";

  patchPhase = ''
    mkdir -p $out/psp/{lib,include}
    find . -name Makefile.psp -exec sed -i 's/\(.*\)$(PSPDIR)\(.*\)/\1$(PSPDIR_OUT)\2/g' {} \;
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
