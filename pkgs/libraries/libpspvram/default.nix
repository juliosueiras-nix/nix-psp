{ stdenv, fetchFromGitHub, pspsdk, ... }:

stdenv.mkDerivation {
  name = "libpspvram";

  src = fetchFromGitHub {
    repo = "libpspvram";
    owner = "pspdev";
    rev = "5b6fabfc6e2804473ad77521e1521d50f609c78b";
    sha256 = "kMMcbf1Z6qYNnENrrD8CYmjUTM5j3d+aXhvFnNI2in0=";
  };

  buildInputs = [ pspsdk ];

  patchPhase = ''
    mkdir -p $out/psp/{lib,include}
    find . -name Makefile -exec sed -i "s;PSPDIR=\$\(.*\);PSPDIR=$out/psp;g" {} \; 
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
