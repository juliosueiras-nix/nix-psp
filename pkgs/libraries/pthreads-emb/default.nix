{ stdenv, fetchFromGitHub, pspsdk, ... }:

stdenv.mkDerivation {
  name = "pthreads-emb";
  src = fetchFromGitHub {
    repo = "pthreads-emb";
    owner = "take-cheeze";
    rev = "18d8b19a8c6628c74a134fb16b6e433343cbf2a9";
    sha256 = "gDFCp1LUamGuWCJZk1bEHvuxZxp8UqG9YrHL8Rv7Nww=";
  };

  buildInputs = [ pspsdk ];

  makeFlags = [ "-C platform/psp" ];

  configurePhase = ''
    unset CC
    unset CXX
  '';

  installPhase = ''
    mkdir -p $out/psp/{lib,include}
    ls platform/psp
    cp -v platform/psp/libpthread-psp.a $out/psp/lib
    cp -v platform/psp/*.h $out/psp/include
    cp -v *.h $out/psp/include
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
