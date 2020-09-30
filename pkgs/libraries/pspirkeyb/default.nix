{ stdenv, fetchFromGitHub, pspsdk, ... }:

stdenv.mkDerivation {
  name = "pspirkeyb";

  src = "${fetchFromGitHub {
    repo = "psp-ports";
    owner = "pspdev";
    rev = "8804b97c955a156e75f1b552b8a5aae9713f674f";
    sha256 = "x09wM/AfeYgKoTRmxsr7iEG84VLzP2DCksAeHVWRCh0=";
  }}/pspirkeyb";

  buildInputs = [ pspsdk ];

  PSPSDK_DIR = "$(out)/psp/sdk";

  patchPhase = ''
    mkdir -p $out/psp/sdk/{lib,include}
    find . -name Makefile -exec sed -i 's/\(.*\)$(PSPSDK)\(.*\)/\1$(PSPSDK_DIR)\2/g' {} \; -exec sed -i 's;include $(PSPSDK_DIR)/lib/build.mak;include $(PSPSDK)/lib/build.mak;g' {} \;
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
