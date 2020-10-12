{ src, stdenv, fetchFromGitHub, pspsdk, ... }:

stdenv.mkDerivation {
  name = "pspirkeyb";

  inherit src;

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
