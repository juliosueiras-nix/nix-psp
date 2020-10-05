{ stdenv, ... }:

stdenv.mkDerivation {
  name = "psp-binutils";

  src = fetchTree {
    type = "git";
    url = "https://github.com/pspdev/binutils";
    rev = "b8577007c5e0a463b0fa9229efed59165ce13508";
  };

  configureFlags = [
    "--target=psp"
    "--enable-install-libbfd"
    "--disable-werror"
    "--with-system-zlib"
  ];

  dontStrip = true;
  dontDisableStatic = true;
  hardeningDisable = [ "all" ];
}

