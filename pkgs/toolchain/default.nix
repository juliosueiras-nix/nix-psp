{ callPackage, impureMode, srcs, fetchFromGitHub, newlibVersion ? "1.20.0", ... }:

let
  pspsdkSrc = if impureMode then srcs.toolchain.pspsdk else fetchFromGitHub {
    repo = "pspsdk";
    owner = "pspdev";
    rev = "b80410f008f185e73d166d304eb3c3942e1d1d61";
    sha256 = "fd0NuO7DM/Oy5eVT1sjADAn2yJ4N3AABwYSQrVxN36Y=";
  };

  gccSrc = if impureMode then srcs.toolchain.gcc else fetchTree {
    type = "tarball";
    url = "https://github.com/pspdev/gcc/archive/9a856f00119f87b2927fa9d03279f3513e656a5d.tar.gz";
    narHash = "sha256-6cHIEw5kbtJS+g2Mdo2WGiSgxXQM2/Y+K2zZMhqUxNc=";
  };


  newLibVersions = {
    "3.3.0" = {
      rev = "7b50ff4d76f58e26fb33f6a4ea5f3a067ffe95be";
      sha256 = "d8c/qiT6Ml1d+sI2U7mJbW8LS7EzPdlFG6a+WiBlmtM=";
    };

    "1.20.0" = {
      rev = "6dc26bb7f8bdc7dff72a811104e1d654d77f75d9";
      sha256 = "lapI6bBzSINIdkQjyu9B8PeegJNFERPq6huWj3zbPUo=";
    };
  };

  newlibSrc = if impureMode then srcs.toolchain.newlib."${newlibVersion}" else fetchFromGitHub {
    repo = "newlib";
    owner = "pspdev";
    inherit (newLibVersions."${newlibVersion}") rev sha256;
  };
in rec {
  #clangToolchain = import ./clang/default.nix {
  #  inherit callPackage;
  #};

  binutils = callPackage ./binutils/default.nix {
    src = if impureMode then srcs.toolchain.binutils else fetchTree {
      type = "tarball";
      url = "https://github.com/pspdev/binutils/archive/b8577007c5e0a463b0fa9229efed59165ce13508.tar.gz";
      narHash = "sha256-MM76SqNk0ltXu5Kc3g+yZ8T5LQvDUDtW3t4rTSFyfFA=";
    };
  };

  stage1 = {
    gcc = callPackage ./gcc/stage1.nix { 
      inherit binutils;
      src = gccSrc;
    };

    pspsdk = callPackage ./pspsdk/stage1.nix {
      inherit binutils stage1 pspsdkSrc;
    };

    newlib = callPackage ./newlib/default.nix {
      inherit binutils stage1;
      src = newlibSrc;
      version = newlibVersion;
    };
  };

  stage2 = {
    gcc = callPackage ./gcc/stage2.nix { 
      inherit binutils stage1;
      src = gccSrc;
    };

    pspsdk = callPackage ./pspsdk/stage2.nix { 
      inherit binutils stage2 pspsdkSrc;
    };

    docs = stage2.pspsdk.makeDocs;
  };

  pspsdk = stage2.pspsdk;

  debug = {
    gdb = callPackage ./gdb/default.nix { 
      inherit binutils pspsdk;
      src = if impureMode then srcs.toolchain.gdb else fetchTree {
        type = "git";
        url = "https://github.com/pspdev/gdb";
        rev = "d773a3425a9b9d8d01d317b280a5eb2ca35e607c";
      };
    };

    insight = callPackage ./insight/default.nix {
      inherit (stage2) pspsdk;
      src = if impureMode then srcs.toolchain.insight else fetchTree {
        type = "tarball";
        url = "https://github.com/pspdev/insight/archive/3b4fd64838d5b69aca9400ebba0188da72e2bbb0.tar.gz";
        narHash = "sha256-G6Qy+HR8rSEIsOKY0FqNIE8PJVXIHWMMr8eWq+0GVFI=";
      };
    };
  };

  tools = {
    psplinkusb =
      callPackage ./psplinkusb/default.nix { 
        inherit binutils pspsdk;
        src = if impureMode then srcs.toolchain.psplinkusb else fetchTree {
          type = "git";
          url = "https://github.com/pspdev/psplinkusb";
          rev = "9a9512ed115c3415ac953b64613d53283a75ada9";
          narHash = "sha256-PGEwA3KYYksAuG7AMJVbqHbwE6dIMO2WnGnnUEiln04=";
        };
      };

      ebootsigner = callPackage ./ebootsigner/default.nix { 
        inherit pspsdk;
        src = if impureMode then srcs.toolchain.ebootsigner else fetchFromGitHub {
          repo = "ebootsigner";
          owner = "pspdev";
          rev = "e32f268f17e10a9421b96211b5ee076dc976caa4";
          sha256 = "1qdm08ppArz5p7XwnMYawcM5DNghIqNzHZU7EmUW8hs=";
        };
      };

    psp-pkgconf =
      callPackage ./psp-pkgconf/default.nix { 
        inherit binutils pspsdk;

        src = if impureMode then srcs.toolchain.psp-pkgconf else fetchFromGitHub {
          repo = "psp-pkgconf";
          owner = "pspdev";
          rev = "c50b45fd551c08eefebd9cb02edc55887fd68b28";
          sha256 = "N+tlCxBXgNzlyy6XSX/lF+VdMElhFHAI2hTerUJqP0I=";
        };
      };
  };
}
