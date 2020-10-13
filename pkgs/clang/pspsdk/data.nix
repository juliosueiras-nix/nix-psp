{ automake, autoconf, src, stdenvNoCC, llvmPackages_10, autoreconfHook, ...  }:

stdenvNoCC.mkDerivation {
  name = "psp-clang-pspsdk-data";
  inherit src;

  buildInputs = [
    autoconf
    automake
    llvmPackages_10.llvm
    llvmPackages_10.clang
  ];

  preConfigure = ''
    ./bootstrap
    mkdir build-psp
    cd build-psp
    mkdir -p $out/psp/sdk/lib
  '';

  configureScript = "../configure";

  makeFlags = [ "install-data" ];

  configureFlags = [
    "PSP_CC=clang" 
    "PSP_CFLAGS=--config\ $(out)/psp/sdk/lib/clang.conf"
    "PSP_CXX=clang++" 
    "PSP_AS=llvm-as"
    "PSP_LD=ld.lld"
    "PSP_AR=llvm-ar"
    "PSP_NM=llvm-nm"
    "PSP_RANLIB=llvm-ranlib"
    "--with-pspdev=$(out)"
    "--disable-sonystubs"
    "--disable-psp-graphics" 
    "--disable-psp-libc"
  ];

  dontInstall = true;
  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
