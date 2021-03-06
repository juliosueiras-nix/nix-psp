{ stdenv, pspsdkSrc, pspsdk, ... }:

{ name, src, ... }:
stdenv.mkDerivation {
  inherit name;

  src = "${pspsdkSrc}/src/samples";

  buildInputs = [ pspsdk ];

  preBuild = ''
    cd ${src}
    mv Makefile.sample Makefile
  '';

  installPhase = ''
    mkdir -p $out/nix-support
    for prxFile in *.prx; do
      cp $prxFile $out/
      echo "file psp-plugin $out/$prxFile" >> $out/nix-support/hydra-build-products
    done

    if [ -f EBOOT.PBP ]; then
      cp EBOOT.PBP $out/
      echo "file psp-homebrew $out/EBOOT.PBP" >> $out/nix-support/hydra-build-products
    fi
  '';

  dontConfigure = true;
  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}

