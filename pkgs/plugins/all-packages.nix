{ callPackage, symlinkJoin, pspsdk, libraries }:

let
  buildPlugin = path: { libraries ? [] }: let
    pspsdkEnv = symlinkJoin {
      name = "pspsdk-env";
      paths = [ pspsdk ] ++ libraries;
    };
  in callPackage path { pspsdk = pspsdkEnv; };
in {

  usbuvc = buildPlugin ./usbuvc {};
}
