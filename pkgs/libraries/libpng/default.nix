{ stdenv, fetchurl, pspsdk, ... }:

let LIBPNG_VERSION = "1.5.7";
in stdenv.mkDerivation {
  name = "libpng";

  src = fetchurl {
    url =
      "http://sourceforge.net/projects/libpng/files/libpng15/older-releases/${LIBPNG_VERSION}/libpng-${LIBPNG_VERSION}.tar.gz";
    sha256 = "fWQxOI9ntI8gJC0mI+GqqZ4cfKtdLWmXQtDkrJh+gkE=";
  };

  buildInputs = [ pspsdk ];

  preConfigure = ''
    unset CC
    unset CXX
    export LDFLAGS="-L${pspsdk}/psp/lib -L${pspsdk}/psp/sdk/lib -lc -lpspuser"
    export CFLAGS="-I${pspsdk}/psp/include"
  '';

  configureFlags = [ "--prefix=$(out)/psp" "--host=psp" ];

  patches = [
    (fetchurl {
      url =
        "https://raw.githubusercontent.com/pspdev/psplibraries/9d4afd89ee8983e647e9207a8d738159aceb35ef/patches/libpng-${LIBPNG_VERSION}-PSP.patch";
      sha256 = "Y/ypY6BXyMNjwXHV1e+zWjgl5tU4PzzKelrqMogh7i4=";
    })
  ];

  postInstall = ''
    find $out/psp/bin -exec sed -i 's;$(out)/psp;$(dirname "$0")/..;g' {} \;
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
