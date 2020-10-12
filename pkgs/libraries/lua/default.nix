{ src, stdenv, fetchFromGitHub, pspsdk, ... }:

stdenv.mkDerivation {
  name = "lua";

  inherit src;

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
