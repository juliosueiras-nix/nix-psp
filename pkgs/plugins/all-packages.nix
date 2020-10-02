{ callPackage, pspsdk, libraries }:

let
  buildPlugin = path: { libraries ? [] }: callPackage path { pspsdk = pspsdk.withLibraries libraries; };
in {

  usbuvc = buildPlugin ./usbuvc {};
}
