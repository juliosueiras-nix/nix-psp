{ callPackage, toolchain, libraries, ... }:

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
  oslibmodv2 = buildLibrary "oslibmodv2" {
    libraries = [ libraries.jpeg ];
  };
}
