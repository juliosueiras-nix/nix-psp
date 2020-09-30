{ pspsdk, callPackage, ... }:

{
  gfx = callPackage ./gfx.nix { inherit pspsdk; };
}
