{ lib, callPackage, allowCFWSDK, pspsdk, libraries }:

let
  buildPlugin = path:
    { libraries ? [ ] }:
    callPackage path { pspsdk = pspsdk.withLibraries libraries; };
in ({
  usbuvc = buildPlugin ./usbuvc { };
} // (if allowCFWSDK then {
  gepatch = buildPlugin ./gepatch { 
    libraries = [ libraries.thirdparty.cfwSDK ];
  };
} else {}))
