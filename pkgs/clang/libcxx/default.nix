{ binutils, python, cmake, pspsdk, src, stdenvNoCC, llvmPackages_10, ...  }:

stdenvNoCC.mkDerivation {
  name = "psp-clang-libcxx";

  src = fetchTree {
    type = "tarball";
    url = "https://github.com/llvm/llvm-project/archive/77d76b71d7df39b573dfa1e391096a040e9b7bd3.tar.gz";
    narHash = "sha256-8rqsvIY162jQOCZS2zpVDZoG4WO7b+iIbZ99UUgmM9s=";
  };

  PSPSDK = "${pspsdk}/psp/sdk";

  buildInputs = [
    pspsdk
    python
    llvmPackages_10.llvm
    llvmPackages_10.clang
    llvmPackages_10.libcxxabi
    llvmPackages_10.bintools
    cmake
  ];

  cmakeFlags = [
    "-DCMAKE_TOOLCHAIN_FILE=${pspsdk}/psp/share/cmake/PSP.cmake"
    "-DCMAKE_C_COMPILER=clang"
    "-DCMAKE_CXX_COMPILER=clang++"
    "-DLIBCXX_CXX_ABI=libcxxabi"
    "-DLIBCXX_CXX_ABI_INCLUDE_PATHS=${pspsdk}/psp/include\ ${pspsdk}/psp"
    "-DLIBCXX_ENABLE_SHARED=0"
    "-DLIBCXX_HAS_PTHREAD_API=1"
    "../libcxx"
  ];

  preBuild = ''
    sed -i '11i#define __GNU_VISIBLE 0' __config_site
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
