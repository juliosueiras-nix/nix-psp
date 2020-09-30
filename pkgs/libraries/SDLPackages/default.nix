{ pspsdk, callPackage, libraries, buildPSPEnv, ... }:

{
  gfx = callPackage ./gfx.nix { inherit pspsdk; };
  image = callPackage ./image.nix { 
    pspsdk = buildPSPEnv (with libraries;[ SDL libpng jpeg ]);
  };
  mixer = callPackage ./mixer.nix { 
    pspsdk = buildPSPEnv (with libraries;[ SDL libmikmod ]);
  };
  ttf = callPackage ./ttf.nix { 
    pspsdk = buildPSPEnv (with libraries;[ SDL freetype ]);
  };
}
