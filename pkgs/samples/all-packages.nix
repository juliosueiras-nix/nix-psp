{ lib, runCommand, pspsdkSrc, callPackage, toolchain, ... }:

let
  buildSample = callPackage ./function.nix {
    inherit (toolchain) pspsdk;
    inherit pspsdkSrc;
  };

  generateSamples = import ./lib.nix { 
    inherit lib buildSample runCommand pspsdkSrc; 
  };
in generateSamples
