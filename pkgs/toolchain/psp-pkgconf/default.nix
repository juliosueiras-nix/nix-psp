{ stdenv, lib, which, pspsdk, binutils, texinfo4, fetchFromGitHub, file, ... }:

stdenv.mkDerivation {
  name = "psp-pkgconf";

  src = fetchFromGitHub {
    repo = "psp-pkgconf";
    owner = "pspdev";

    rev = "c50b45fd551c08eefebd9cb02edc55887fd68b28";
    sha256 = "N+tlCxBXgNzlyy6XSX/lF+VdMElhFHAI2hTerUJqP0I=";
  };

  buildInputs = [ pspsdk ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/psp/share/aclocal
    cp pkg.m4 $out/psp/share/aclocal
    cp psp-pkg-config $out/bin/
  '';

  dontDisableStatic = true;
}
