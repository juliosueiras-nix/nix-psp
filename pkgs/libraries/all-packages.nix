{ callPackage, pspsdk, ... }:

rec {
  pspirkeyb = callPackage ./pspirkeyb/default.nix {
    inherit pspsdk;
  };

  SDL = callPackage ./SDL/default.nix {
    inherit pspsdk pspirkeyb;
  };

  bzip2 = callPackage ./bzip2/default.nix {
    inherit pspsdk;
  };

  sqlite = callPackage ./sqlite/default.nix {
    inherit pspsdk;
  };
}
