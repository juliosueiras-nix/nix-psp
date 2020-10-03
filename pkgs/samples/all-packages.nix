{ lib, runCommand, callPackage, toolchain, ... }:

let
  buildSample = callPackage ./function.nix {
    inherit (toolchain) pspsdkSrc;
  };

  generateSamples = import ./lib.nix { 
    inherit lib buildSample runCommand; 
    inherit (toolchain) pspsdkSrc; 
  };
in generateSamples
