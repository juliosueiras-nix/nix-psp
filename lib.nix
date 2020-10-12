{ pkgs }:
{ srcs ? null, rustChannel ? pkgs.rustChannelOf {
  channel = "nightly";
  date = "2020-10-07";
  sha256 = "juFd+PkbbaM8ULbmgz+W/F336Lis1MNuC8eDYsEqv0A=";
}, impureMode ? false, newlibVersion ? "1.20.0", allowCFWSDK ? false, ... }:
let
  toolchain = import ./pkgs/toolchain/default.nix {
    inherit (pkgs) callPackage fetchFromGitHub;
    inherit newlibVersion impureMode srcs;
  };
  pspsdk = toolchain.stage2.pspsdk;

  libraries = import ./pkgs/libraries/all-packages.nix {
    inherit (pkgs) callPackage fetchFromGitHub lib;
    inherit toolchain newlibVersion allowCFWSDK impureMode srcs;
  };
in {
  inherit toolchain pspsdk libraries;
  homebrew = import ./pkgs/homebrew/all-packages.nix {
    inherit (pkgs) callPackage;
    inherit pspsdk libraries;
  };

  plugins = import ./pkgs/plugins/all-packages.nix {
    inherit (pkgs) callPackage lib;
    inherit pspsdk libraries allowCFWSDK;
  };

  samples = import ./pkgs/samples/all-packages.nix {
    inherit (pkgs) callPackage lib runCommand;
    inherit toolchain;
    pspsdkSrc = if impureMode then srcs.toolchain.pspsdk else pkgs.fetchFromGitHub {
      repo = "pspsdk";
      owner = "pspdev";
      rev = "b80410f008f185e73d166d304eb3c3942e1d1d61";
      sha256 = "fd0NuO7DM/Oy5eVT1sjADAn2yJ4N3AABwYSQrVxN36Y=";
    };
  };

  clang = import ./pkgs/clang {
    inherit (pkgs) callPackage lib runCommand makeRustPlatform writeText applyPatches;
    inherit impureMode srcs rustChannel;
  };
}
