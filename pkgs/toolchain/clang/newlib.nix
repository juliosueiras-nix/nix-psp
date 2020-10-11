{ stdenvNoCC,llvmPackages_10, ...  }:

stdenvNoCC.mkDerivation {
  name = "psp-clang-newlib";

  src = fetchTree {
    type = "tarball";
    url = "https://github.com/overdrivenpotato/newlib/archive/bea6cd03242f16778de72fd78489ff139e1741e8.tar.gz";
    narHash = "sha256-c8T7WQ5pFAhXKd6aN3zkLG/OWVo0vySrJch7iV4jnDk=";
  };

  buildInputs = [
    llvmPackages_10.llvm
    llvmPackages_10.clang
  ];

  preConfigure = ''
    unset CFLAGS
    unset NIX_CFLAGS
    mkdir build-psp
    cd build-psp
  '';

  configureScript = "../configure";

  configureFlags = [
    "AR_FOR_TARGET=llvm-ar"
    "AS_FOR_TARGET=llvm-as"
    "RANLIB_FOR_TARGET=llvm-ranlib"
    "CC_FOR_TARGET=clang"
    "CXX_FOR_TARGET=clang++"
    "--target=psp"
    "--enable-newlib-iconv"
    "--enable-newlib-multithread" 
    "--enable-newlib-mb"
  ];

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
