{ stdenv, pspsdk, fetchFromGitHub, ... }:

stdenv.mkDerivation {
  name = "uvc";

  buildInputs = [ pspsdk ];

  installPhase = ''
    mkdir -p $out/nix-support
    cp uvc.prx $out/
    echo "file psp-plugins $out/uvc.prx" >> $out/nix-support/hydra-build-products
  '';

  src = fetchTree {
    repo = "psp-uvc-usb-video-class";
    owner = "xerpi";
    rev = "728b1f40475f6012431fef9cebf7096e06a5f711";
    sha256 = "7xW5jU7GvA2cuPVzPZ5dzhFllBQXWoqhArvCx3p1pY8=";
  };

  dontStrip = true;
  dontPatchELF = true;
  dontDisableStatic = true;
  hardeningDisable = [ "all" ];
}
