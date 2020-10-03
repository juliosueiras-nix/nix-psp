{ lib, runCommand, callPackage, toolchain, ... }:

let
  buildSample = callPackage ./function.nix {
    inherit (toolchain) pspsdkSrc pspsdk;
  };

  generateSamples = import ./lib.nix { 
    inherit lib buildSample runCommand; 
    inherit (toolchain) pspsdkSrc; 
  };
in generateSamples
