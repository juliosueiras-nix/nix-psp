{ binutils, libatomic_ops, newlib, pspsdk, src, stdenvNoCC, llvmPackages_10, ...  }:

stdenvNoCC.mkDerivation {
  name = "psp-clang-pthreads-emb";

  makeFlags = [ "-C platform/psp" ];

  src = fetchTree {
    type = "git";
    url = "https://github.com/take-cheeze/pthreads-emb";
    rev = "18d8b19a8c6628c74a134fb16b6e433343cbf2a9";
  };

  buildInputs = [
    pspsdk
  ];

  installPhase = ''
    mkdir -p $out/psp/{lib,include}
    cp -v platform/psp/libpthread-psp.a $out/psp/lib
    cp -v platform/psp/*.h $out/psp/include
    cp -v *.h $out/psp/include
  '';

  dontConfigure = true;
  dontDisableStatic = true;
  dontPatchELF = true;
  dontAutoPatchELF = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
