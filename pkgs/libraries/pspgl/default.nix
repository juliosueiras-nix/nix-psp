{ src, stdenv, fetchFromGitHub, pspsdk, ... }:

stdenv.mkDerivation {
  name = "pspgl";

  inherit src;

  buildInputs = [ pspsdk ];

  installPhase = ''
    mkdir -p $out/psp/{include,lib}
    mkdir -p $out/psp/include/{GL,GLES}
    cp GL/*.h $out/psp/include/GL
    cp GLES/*.h $out/psp/include/GLES
    cp libGL.a $out/psp/lib
    cp libGLU.a $out/psp/lib
    cp libglut.a $out/psp/lib
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
