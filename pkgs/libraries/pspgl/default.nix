{ stdenv, fetchFromGitHub, pspsdk, ... }:

stdenv.mkDerivation {
  name = "pspgl";

  src = fetchFromGitHub {
    repo = "pspgl";
    owner = "pspdev";
    rev = "30ffef7bb75ba70eccede93288d7bb429a2e4709";
    sha256 = "o9Cu5Ywer+HbNp0iZ5VDKyP35326+op4LxP0asWO4kI=";
  };

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
