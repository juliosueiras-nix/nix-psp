{ callPackage, newlibVersion ? "1.20.0", ... }:

rec {
  binutils = callPackage ./binutils/default.nix {};
  stage1 = {
    gcc = callPackage ./gcc/stage1.nix { 
      inherit binutils;
    };

    pspsdk = callPackage ./pspsdk/stage1.nix {
      inherit binutils;
      inherit stage1;
    };

    newlib = callPackage ./newlib/default.nix {
      inherit binutils stage1;
      version = newlibVersion;
    };
  };

  stage2 = {
    gcc = callPackage ./gcc/stage2.nix { 
      inherit binutils stage1;
    };

    pspsdk = callPackage ./pspsdk/stage2.nix { 
      inherit binutils stage2;
    };
  };

  pspsdk = stage2.pspsdk;

  debug = {
    gdb = callPackage ./gdb/default.nix {
      inherit binutils pspsdk;
    };

        # Skipping for now
        #insight = callPackage ./insight/default.nix {
        #  inherit stage2 binutils;
        #};
      };

      tools = {
        psplinkusb = callPackage ./psplinkusb/default.nix {
          inherit binutils pspsdk;
        };

        ebootsigner = callPackage ./ebootsigner/default.nix {
          inherit pspsdk;
        };

        psp-pkgconf = callPackage ./psp-pkgconf/default.nix {
          inherit binutils pspsdk;
        };
      };
    }