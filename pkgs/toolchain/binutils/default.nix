{ stdenv, ... }:

stdenv.mkDerivation {
  name = "psp-binutils";

  src = fetchTree {
    type = "tarball";
    url = "https://github.com/pspdev/binutils/archive/b8577007c5e0a463b0fa9229efed59165ce13508.tar.gz";
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

