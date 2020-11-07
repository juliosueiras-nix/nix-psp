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

#{ src, stdenv, fetchFromGitHub, pspsdk, ... }:
#
#stdenv.mkDerivation {
#  name = "oslibmodv2";
#
#  src = fetchTree {
#    type = "git";
#    url = "https://github.com/liclac/oslibmodv2";
#    rev = "bc3484fa1cc38932aa053bfe0a0d2fdb046c4340";
#  };
#
#  INCDIR = "${pspsdk}/psp/include";
#
#  buildInputs = [ pspsdk ];
#
#  installPhase = ''
#    mkdir -p $out/psp/sdk/lib
#    cp libosl.a $out/psp/sdk/lib
#    mkdir -p $out/psp/sdk/include/oslib/{intraFont,libpspmath,adhoc}
#    cp intraFont/intraFont.h $out/psp/sdk/include/oslib/intraFont/
#    cp intraFont/libccc.h $out/psp/sdk/include/oslib/intraFont/
#    cp libpspmath/pspmath.h $out/psp/sdk/include/oslib/libpspmath/
#    cp adhoc/pspadhoc.h $out/psp/sdk/include/oslib/adhoc/
#    cp oslmath.h $out/psp/sdk/include/oslib/
#    cp net.h $out/psp/sdk/include/oslib/
#    cp browser.h $out/psp/sdk/include/oslib/
#    cp audio.h $out/psp/sdk/include/oslib/
#    cp bgm.h $out/psp/sdk/include/oslib/
#    cp dialog.h $out/psp/sdk/include/oslib/
#    cp drawing.h $out/psp/sdk/include/oslib/
#    cp keys.h $out/psp/sdk/include/oslib/
#    cp map.h $out/psp/sdk/include/oslib/
#    cp messagebox.h $out/psp/sdk/include/oslib/
#    cp osk.h $out/psp/sdk/include/oslib/
#    cp saveload.h $out/psp/sdk/include/oslib/
#    cp oslib.h $out/psp/sdk/include/oslib/
#    cp text.h $out/psp/sdk/include/oslib/
#    cp usb.h $out/psp/sdk/include/oslib/
#    cp vfpu_ops.h $out/psp/sdk/include/oslib/
#    cp VirtualFile.h $out/psp/sdk/include/oslib/
#    cp vram_mgr.h $out/psp/sdk/include/oslib/
#    cp ccc.h $out/psp/sdk/include/oslib/
#    cp sfont.h $out/psp/sdk/include/oslib/
#  '';
#
#  dontDisableStatic = true;
#  dontStrip = true;
#  hardeningDisable = [ "all" ];
#}
