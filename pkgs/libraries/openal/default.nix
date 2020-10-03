{ stdenvNoCC, fetchurl, cmake, pspsdk, ... }:

let OPENAL_VERSION = "1.14";
in stdenvNoCC.mkDerivation {
  name = "openal";

  src = fetchurl {
    url =
      "http://kcat.strangesoft.net/openal-releases/openal-soft-${OPENAL_VERSION}.tar.bz2";
    sha256 = "h72NYdWUM4eJjJK2oru7JhGOdF3sV1UMgXUmpw+tCRQ=";
  };

  buildInputs = [ pspsdk ];

  patches = [
    (fetchurl {
      url =
        "https://raw.githubusercontent.com/pspdev/psplibraries/9d4afd89ee8983e647e9207a8d738159aceb35ef/patches/openal-${OPENAL_VERSION}-PSP.patch";
      sha256 = "kmS71QNEGFyz7iXk3wDL0oR/TqojUpxsv0RDrSf1iv8=";
    })
  ];

  configurePhase = ''
    export CFLAGS="-I${pspsdk}/psp/include"
    substituteInPlace CMakeLists.txt --replace "ADD_DEFINITIONS(\"-D_WIN32" "ADD_DEFINITIONS(\""
    ${cmake}/bin/cmake -DBUILD_SHARED_LIBS:BOOL=OFF \
    -DCMAKE_MODULE_PATH=${pspsdk}/psp/share/cmake \
    -DCMAKE_TOOLCHAIN_FILE=${pspsdk}/psp/share/cmake/PSP.cmake \
    -DUTILS=OFF \
    -DEXAMPLES=OFF \
    -DCMAKE_INSTALL_PREFIX=$out/psp .
    #-DPKG_CONFIG_LIBDIR=${pspsdk}/psp/lib/pkgconfig \
    #-DPKG_CONFIG_EXECUTABLE=${pspsdk}/psp/bin/psp-pkg-config \
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
