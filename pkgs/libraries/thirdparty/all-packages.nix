{ callPackage, toolchain, ... }:

let
  buildLibrary = name:
    { libraries ? null, }:
    callPackage (./. + "/${name}/default.nix") {
      pspsdk = (if libraries != null then
        toolchain.pspsdk.withLibraries libraries
      else
        toolchain.pspsdk);
    };

in {
  cfwSDK = buildLibrary "cfwSDK" {};
}
