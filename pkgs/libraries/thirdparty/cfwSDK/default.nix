{ stdenvNoCC, unrar, fetchurl, ... }:

stdenvNoCC.mkDerivation {
  name = "cfw-sdk";
  

  src = fetchurl {
    name = "sdk.rar"; 
    url = "https://psp.brewology.com/downloads/get.php?id=8347";
    sha256 = "+zS2WmSio7n8SAa4CYzjoKjMiqA4WJmhOuT+4oEvdmk=";
  };

  unpackPhase = ''
    ${unrar}/bin/unrar x $src
  '';

  installPhase = ''
    mkdir -p $out/psp/sdk/
    cp -rf SDK/{lib,include} $out/psp/sdk/
  '';

  dontStrip = true;
  dontPatchELF = true;
  dontDisableStatic = true;
  hardeningDisable = [ "all" ];
}
