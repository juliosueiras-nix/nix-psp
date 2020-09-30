{ callPackage, buildEnv, pspsdk, ... }:

let
  buildLibrary = name: { libraries ? null, postBuild ? "" }: callPackage (./. + "/${name}/default.nix") {
    pspsdk = (if libraries != null then buildEnv {
      name = "pspsdk-env";
      paths = [ pspsdk ] ++ libraries;
      inherit postBuild;
    } else pspsdk);
  };
in rec {
  pspirkeyb = buildLibrary "pspirkeyb" {};
  pspgl = buildLibrary "pspgl" {};
  SDL = buildLibrary "SDL" { libraries = [ pspirkeyb ]; };

  SDLPackages = builtins.removeAttrs (buildLibrary "SDLPackages" { 
    libraries = [ SDL ];
  }) [ "override" "overrideDerivation" ];

  SDL2 = buildLibrary "SDL2" { libraries = [ pspgl libpspvram ]; };
  bzip2 = buildLibrary "bzip2" {};
  sqlite = buildLibrary "sqlite" {};
  libpspvram = buildLibrary "libpspvram" {};
}
