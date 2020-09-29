{ callPackage, pspsdk, binutils, ... }:

{
  SDL = callPackage ./SDL/default.nix {
    inherit pspsdk binutils;
  };
}
