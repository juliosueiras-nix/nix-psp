{ stdenv, pspsdk, ... }:

stdenv.mkDerivation {
  name = "gepatch";

  buildInputs = [ pspsdk ];

  preBuild = ''
    mkdir -p $out/nix-support
    substituteInPlace Makefile --replace 'E:/pspemu/seplugins/$(TARGET).prx' "$out/\$(TARGET).prx"
  '';

  installPhase = ''
    echo "file psp-plugins $out/ge_patch.prx" >> $out/nix-support/hydra-build-products
  '';

  src = fetchTree {
    type = "git";
    url = "https://github.com/TheOfficialFloW/GePatch";
    rev = "2dd234ca1b5f07536542a57b056113107adfd671";
  };

  dontStrip = true;
  dontPatchELF = true;
  dontDisableStatic = true;
  hardeningDisable = [ "all" ];
}
