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
    mkdir -p $out/{include,lib}
    mkdir -p $out/include/{GL,GLES}
    cp GL/*.h $out/include/GL
    cp GLES/*.h $out/include/GLES
    cp libGL.a $out/lib
    cp libGLU.a $out/lib
    cp libglut.a $out/lib
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
