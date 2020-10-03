{ callPackage, fetchFromGitHub, newlibVersion ? "1.20.0", ... }:

let
  pspsdkSrc = fetchFromGitHub {
    repo = "pspsdk";
    owner = "pspdev";
    rev = "3de82931a6acaa9fa51a41528ad581d736457618";
    sha256 = "zMRskuTApByGozDJnYaV61b1gYwMcp0mRRUrXndqMxs=";
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

    pspsdkDocs = stage2.pspsdk.makeDocs;
  };

  pspsdk = stage2.pspsdk;

  debug = {
    gdb = callPackage ./gdb/default.nix { inherit binutils pspsdk; };

    # Skipping for now
    #insight = callPackage ./insight/default.nix {
    #  inherit stage2 binutils;
    #};
  };

  tools = {
    psplinkusb =
      callPackage ./psplinkusb/default.nix { inherit binutils pspsdk; };

    ebootsigner = callPackage ./ebootsigner/default.nix { inherit pspsdk; };

    psp-pkgconf =
      callPackage ./psp-pkgconf/default.nix { inherit binutils pspsdk; };
  };
}
