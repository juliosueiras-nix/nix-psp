{ stdenvNoCC, fetchurl, pspsdk, ... }:

stdenvNoCC.mkDerivation {
  name = "pthread-emb";

  src = fetchTarball {
    url = "https://github.com/take-cheeze/pthreads-emb/archive/18d8b19a8c6628c74a134fb16b6e433343cbf2a9.tar.gz";
    sha256 = "031pzcdz3jxicays2lkw39kv3yqyqib96n92b2p62snlaakl4cc0";
  };

  buildInputs = [ pspsdk ];

  buildPhase = ''
    make -C platform/psp 
  '';

  installPhase = ''
    mkdir -p $out/psp/include
    make -C platform/psp install
    cp -v *.h $out/psp/include/
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
