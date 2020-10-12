{ lib, runCommand, callPackage, toolchain, ... }:

let
  buildSample = callPackage ./function.nix {
    inherit (toolchain) pspsdk-src pspsdk;
  };

  generateSamples = import ./lib.nix { 
    inherit lib buildSample runCommand; 
    inherit (toolchain) pspsdk-src; 
  };
in generateSamples
