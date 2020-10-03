{ stdenv, pspsdk, ... }:

{ name, src, ... }:
stdenv.mkDerivation {
  inherit name;

  src = "${pspsdk}/psp/sdk/samples";

  buildInputs = [ pspsdk ];

  preBuild = ''
    cd ${src}
  '';

  installPhase = ''
    mkdir -p $out/nix-support
    if [ -f EBOOT.PBP ]; then
      cp EBOOT.PBP $out/
      echo "file psp-homebrew $out/EBOOT.PBP" >> $out/nix-support/hydra-build-products
    else 
      for prxFile in *.prx; do
        cp $prxFile $out/
        echo "file psp-plugin $out/$prxFile" >> $out/nix-support/hydra-build-products
      done
    fi
  '';

  dontConfigure = true;
  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}

