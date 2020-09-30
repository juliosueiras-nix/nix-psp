{ stdenv, zip, pspsdk, libraries, fetchFromGitHub, symlinkJoin , ... }:

let
  pspsdkEnv = symlinkJoin  {
    name = "test-env";
    paths = [
      pspsdk
    ];
  };
in {
  usbvideo = stdenv.mkDerivation {
    name = "uvc-video";

    buildInputs = [ pspsdkEnv ];

    installPhase = ''
      mkdir -p $out/nix-support
      ${zip}/bin/zip -r uvc.zip .
      cp uvc.zip $out/
      echo "file psp-plugins $out/uvc.zip" >> $out/nix-support/hydra-build-products
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
  };
}
