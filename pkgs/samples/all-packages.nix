{ lib, runCommand, callPackage, toolchain, ... }:

let
  buildSample = callPackage ./function.nix {
    inherit (toolchain) pspsdk;
  };

  generateSamples = import ./lib.nix { 
    inherit lib buildSample runCommand; 
    inherit (toolchain) pspsdk;
  };
in generateSamples
