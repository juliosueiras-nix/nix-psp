{ callPackage, fetchFromGitHub, newlibVersion ? "1.20.0", ... }:

let
  pspsdkSrc = fetchFromGitHub {
    repo = "pspsdk";
    owner = "pspdev";
    rev = "b80410f008f185e73d166d304eb3c3942e1d1d61";
    sha256 = "fd0NuO7DM/Oy5eVT1sjADAn2yJ4N3AABwYSQrVxN36Y=";
  };
in rec {
  inherit pspsdkSrc;

  binutils = callPackage ./binutils/default.nix { };

  stage1 = {
    gcc = callPackage ./gcc/stage1.nix { inherit binutils; };

    pspsdk = callPackage ./pspsdk/stage1.nix {
      inherit binutils stage1 pspsdkSrc;
    };

    newlib = callPackage ./newlib/default.nix {
      inherit binutils stage1;
      version = newlibVersion;
    };
  };

  stage2 = {
    gcc = callPackage ./gcc/stage2.nix { inherit binutils stage1; };

    pspsdk = callPackage ./pspsdk/stage2.nix { 
      inherit binutils stage2 pspsdkSrc;
    };

    docs = stage2.pspsdk.makeDocs;
  };

  pspsdk = stage2.pspsdk;

  external = {
    gdb = callPackage ./gdb/external.nix { inherit binutils pspsdk; };
  };

  debug = {
    gdb = callPackage ./gdb/default.nix { inherit binutils pspsdk; };

    insight = callPackage ./insight/default.nix {
      inherit stage2 binutils;
    };
  };

  tools = {
    psplinkusb =
      callPackage ./psplinkusb/default.nix { inherit binutils pspsdk; };

    ebootsigner = callPackage ./ebootsigner/default.nix { inherit pspsdk; };

    psp-pkgconf =
      callPackage ./psp-pkgconf/default.nix { inherit binutils pspsdk; };
  };
}
