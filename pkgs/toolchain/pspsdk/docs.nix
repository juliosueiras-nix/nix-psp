{ stdenv, lib, which, doxygen, ... }:

src: stdenv.mkDerivation {
  name = "psp-sdk-docs";

  inherit src;

  patchPhase = ''
    substituteInPlace Doxyfile --replace "PROJECT_NAME           = $(PROJECT)" "PROJECT_NAME = PSPSDK" --replace "PROJECT_NUMBER         = $(VERSION)" "PROJECT_NUMBER = ${builtins.readFile "${src}/VERSION"}"
  '';

  buildPhase = ''
    ${doxygen}/bin/doxygen ./Doxyfile
  '';

  installPhase = ''
    mkdir -p $out/{doc,nix-support}
    cp -rf doc/html/* $out/doc/
    echo "doc pspsdk-doc $out/share/doc" >> $out/nix-support/hydra-build-products
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
