{ stdenv, cmake, fetchzip, pspsdk, ... }:

let ANGELSCRIPT_VERSION = "2.23.0";
in stdenv.mkDerivation {
  name = "angelscript";

  src = fetchzip {
    url =
      "http://www.angelcode.com/angelscript/sdk/files/angelscript_${ANGELSCRIPT_VERSION}.zip";
    sha256 = "SsG0Ab42MaRVRf9WOYQDemjNgAR0UsJtzOs1dxys2VQ=";
  };

  buildInputs = [ pspsdk cmake ];

  preConfigure = ''
    cd angelscript/projects/cmake
  '';

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS:BOOL=OFF"
    "-DCMAKE_MODULE_PATH=${pspsdk}/psp/share/cmake"
    "-DCMAKE_TOOLCHAIN_FILE=${pspsdk}/psp/share/cmake/PSP.cmake"
  ];

  installPhase = ''
    mkdir -p $out/psp/{include,lib}
    cp -v ../../../include/*.h $out/psp/include/
    cp -v ../../lib/lib*.a $out/psp/lib/
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
