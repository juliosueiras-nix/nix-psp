{ callPackage, pspsdk, ... }:

{
  SDL = callPackage ./SDL/default.nix {
    inherit pspsdk;
  };

  bzip2 = callPackage ./bzip2/default.nix {
    inherit pspsdk;
  };

  sqlite = callPackage ./sqlite/default.nix {
    inherit pspsdk;
  };
}
