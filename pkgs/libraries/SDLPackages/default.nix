{ pspsdk, callPackage, libraries, buildPSPEnv, ... }:

{
  gfx = callPackage ./gfx.nix { inherit pspsdk; };
  image = callPackage ./image.nix { 
    pspsdk = buildPSPEnv { 
      libraries = (with libraries;[ SDL libpng jpeg ]);
    };
  };
  mixer = callPackage ./mixer.nix { 
    pspsdk = buildPSPEnv {
      libraries = (with libraries;[ SDL libmikmod ]);
    };
  };
  ttf = callPackage ./ttf.nix { 
    pspsdk = buildPSPEnv {
      libraries = (with libraries;[ SDL freetype ]);
    };
  };
}
