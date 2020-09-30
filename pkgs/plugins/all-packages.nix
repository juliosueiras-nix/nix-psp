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
    name = "psp-uvc-usb-video-class";

    buildInputs = [ pspsdkEnv ];

    installPhase = ''
      mkdir -p $out/{nix-support,plugin}
      chmod a+rw uvc.prx
      cp uvc.prx $out/plugin/
      echo "file psp-plugin $out/plugin/uvc.prx" >> $out/nix-support/hydra-build-products
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
