{ automake, autoconf, newlib, src, stdenvNoCC, llvmPackages_10, autoreconfHook, ...  }:

stdenvNoCC.mkDerivation {
  name = "psp-clang-pspsdk";
  inherit src;

  buildInputs = [
    llvmPackages_10.llvm
    llvmPackages_10.clang
    automake
    autoconf
  ];

  preConfigure = ''
    mkdir -p $out
    cp -rf ${newlib}/* $out/
    chmod -R a+rw $out/*
    cp $out/psp/sdk/lib/clang.conf old.clang.conf
    substituteInPlace $out/psp/sdk/lib/clang.conf --replace '$(out)' "$out"

    export PSP_CFLAGS=" --config  $out/psp/sdk/lib/clang.conf"
    ./bootstrap
    mkdir build-psp
    cd build-psp
  '';

  configureScript = "../configure";

  configureFlags = [
    "PSP_CC=clang" 
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

  postInstall = ''
    cp ../old.clang.conf $out/psp/sdk/lib/clang.conf 
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
