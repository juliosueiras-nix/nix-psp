{ callPackage, ... }:

{
  newlib = callPackage ./newlib.nix {};
  pspsdkData = callPackage ./pspsdkData.nix {};
}
