{ stdenv, fetchFromGitHub, pspsdk, ... }:

stdenv.mkDerivation {
  name = "libmad";

  src = "${fetchFromGitHub {
    repo = "psp-ports";
    owner = "pspdev";
    rev = "8804b97c955a156e75f1b552b8a5aae9713f674f";
    sha256 = "x09wM/AfeYgKoTRmxsr7iEG84VLzP2DCksAeHVWRCh0=";
  }}/libmad";

  buildInputs = [ pspsdk ];

  PSPDIR_OUT = "$(out)/psp";

  patchPhase = ''
    mkdir -p $out/psp/{lib,include}
    substituteInPlace src/Makefile --replace '$(PSPDIR)' '$(PSPDIR_OUT)' 
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
