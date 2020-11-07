{ src, stdenv, fetchFromGitHub, pspsdk, ... }:

stdenv.mkDerivation {
  name = "oslibmodv2";

  src = fetchTree {
    type = "git";
    url = "https://github.com/dogo/oslibmodv2";
    rev = "d8ad579a4abb766345cc8ed2c2c92a9ae39a166a";
  };

  INCDIR = "${pspsdk}/psp/include";

  buildInputs = [ pspsdk ];

  installPhase = ''
    mkdir -p $out/psp/lib
    cp libosl.a $out/psp/lib
    mkdir -p $out/psp/include/oslib/{intraFont,libpspmath,adhoc}
    cp src/intraFont/intraFont.h $out/psp/include/oslib/intraFont/
    cp src/intraFont/libccc.h $out/psp/include/oslib/intraFont/
    cp src/libpspmath/pspmath.h $out/psp/include/oslib/libpspmath/
    cp src/adhoc/pspadhoc.h $out/psp/include/oslib/adhoc/
    cp src/oslmath.h $out/psp/include/oslib/
    cp src/net.h $out/psp/include/oslib/
    cp src/browser.h $out/psp/include/oslib/
    cp src/audio.h $out/psp/include/oslib/
    cp src/bgm.h $out/psp/include/oslib/
    cp src/dialog.h $out/psp/include/oslib/
    cp src/drawing.h $out/psp/include/oslib/
    cp src/keys.h $out/psp/include/oslib/
    cp src/map.h $out/psp/include/oslib/
    cp src/messagebox.h $out/psp/include/oslib/
    cp src/osk.h $out/psp/include/oslib/
    cp src/saveload.h $out/psp/include/oslib/
    cp src/oslib.h $out/psp/include/oslib/
    cp src/text.h $out/psp/include/oslib/
    cp src/usb.h $out/psp/include/oslib/
    cp src/vfpu_ops.h $out/psp/include/oslib/
    cp src/VirtualFile.h $out/psp/include/oslib/
    cp src/vram_mgr.h $out/psp/include/oslib/
    cp src/ccc.h $out/psp/include/oslib/
    cp src/sfont.h $out/psp/include/oslib/
  '';

  dontDisableStatic = true;
  dontStrip = true;
  hardeningDisable = [ "all" ];
}
