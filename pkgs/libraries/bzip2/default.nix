{ stdenv, fetchurl, pspsdk, ... }:

let BZIP2_VERSION = "1.0.6";
in stdenv.mkDerivation {
  name = "bzip2";

  src = fetchurl {
    url = "ftp://sourceware.org/pub/bzip2/bzip2-${BZIP2_VERSION}.tar.gz";
    sha256 = "ooSPNPzV1s9H3vAEYfy1KKBITY7e+CCNbS4pCdxh2c0=";
  };

  buildInputs = [ pspsdk ];

  patches = [
    (fetchurl {
      url =
        "https://raw.githubusercontent.com/pspdev/psplibraries/9d4afd89ee8983e647e9207a8d738159aceb35ef/patches/bzip2-${BZIP2_VERSION}-PSP.patch";
      sha256 = "wE6Yv7oANWf1fUR80voiNFtB8xSH+8RlXoqM4xNs/7w=";
    })
  ];

  postPatch = ''
    find . -name "Makefile" -exec sed -i "s|PREFIX=.*|PREFIX=$out/psp|g" {} \; -exec sed -i 's|lcurses|lncurses|g' {} \;
  '';
}

