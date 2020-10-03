{ stdenv, fetchurl, pspsdk, ... }:

let LIBMIKMOD_VERSION = "3.3.11.1";
in stdenv.mkDerivation {
  name = "libmikmod";

  src = fetchurl {
    url =
      "https://downloads.sourceforge.net/mikmod/libmikmod-${LIBMIKMOD_VERSION}.tar.gz";
    sha256 = "rZ1k38j4NoSHZBnqfNT/SkHYvNjCPvN+yzogCha0bRk=";
  };

  buildInputs = [ pspsdk ];

  preConfigure = ''
    unset CC
    unset CXX
    export LDFLAGS="-L${pspsdk}/psp/lib -L${pspsdk}/psp/sdk/lib -lc -lpspuser"
  '';

  configureFlags = [
    "--prefix=$(out)/psp"
    "--host=psp"
    "--disable-alldrv"
    "--enable-psp"
    "--enable-aiff"
    "--enable-wav"
    "--enable-raw"
  ];

  patches = [
    (fetchurl {
      url =
        "https://raw.githubusercontent.com/pspdev/psplibraries/9d4afd89ee8983e647e9207a8d738159aceb35ef/patches/libmikmod-${LIBMIKMOD_VERSION}-PSP.patch";
      sha256 = "HbMs9xfur359T0YuwRt2qZMyIFHbScuv52X9NngLYs4=";
    })
  ];

  postInstall = ''
    find $out/psp/bin -exec sed -i 's;$(out)/psp;$(dirname "$0")/..;g' {} \;
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
