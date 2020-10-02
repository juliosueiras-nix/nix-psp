{ stdenv, pspsdk, fetchFromGitHub, ... }:

stdenv.mkDerivation {
  name = "uvc";

  buildInputs = [ pspsdk ];

  installPhase = ''
      mkdir -p $out/nix-support
      cp uvc.prx $out/
      echo "file psp-plugins $out/uvc.prx" >> $out/nix-support/hydra-build-products
  '';

  src = fetchFromGitHub {
    repo = "psp-uvc-usb-video-class";
    owner = "xerpi";
    rev = "master";
    sha256 = "yoILfJzloNB+J32diykdErJgCXsfJdJRAPmgtYgR77A=";
  };

  dontStrip = true;
  dontPatchELF = true;
  dontDisableStatic = true;
  hardeningDisable = [ "all" ];
}
