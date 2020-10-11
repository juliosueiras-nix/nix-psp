{ stdenvNoCC,llvmPackages_10, autoreconfHook, ...  }:

stdenvNoCC.mkDerivation {
  name = "psp-clang-pspsdk-data";

  src = fetchTree {
    type = "tarball";
    url = "https://github.com/wally4000/pspsdk/archive/d26212d9df32d825f0d1257d17224ad6df725dae.tar.gz";
    narHash = "sha256-x/S+E797xhaJDQKxxoDRDEuOhC/ENJLC+umX2/hy0kA=";
  };

  buildInputs = [
    autoreconfHook
    llvmPackages_10.llvm
    llvmPackages_10.clang
  ];

  preConfigure = ''
    unset CFLAGS
    unset CXXFLAGS
    unset NIX_CFLAGS
    mkdir build-psp
    cd build-psp
  '';

  configureScript = "../configure";

  makeFlags = [ "install-data" ];

  configureFlags = [
    "PSP_CC=clang" 
    #"PSP_CFLAGS=--config=$(out)/psp/sdk/lib/clang.conf"
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

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
