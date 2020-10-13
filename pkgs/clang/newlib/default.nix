{ pspsdkData, src, stdenvNoCC, llvmPackages_10, ...  }:

stdenvNoCC.mkDerivation {
  name = "psp-clang-newlib";
  inherit src;

  buildInputs = [
    llvmPackages_10.llvm
    llvmPackages_10.clang
  ];

  preConfigure = ''
    mkdir -p $out
    cp -rf ${pspsdkData}/* $out/
    chmod -R a+rw $out/*
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
