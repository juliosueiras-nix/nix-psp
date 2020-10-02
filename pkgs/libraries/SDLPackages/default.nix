{ pspsdk, callPackage, libraries, ... }:

{
  gfx = callPackage ./gfx.nix { 
    pspsdk = pspsdk.withLibraries (with libraries;[ SDL ]);
  };
  image = callPackage ./image.nix { 
    pspsdk = pspsdk.withLibraries (with libraries;[ SDL libpng jpeg ]);
  };
  mixer = callPackage ./mixer.nix { 
    pspsdk = pspsdk.withLibraries (with libraries;[ SDL libmikmod ]);
  };
  ttf = callPackage ./ttf.nix { 
    pspsdk = pspsdk.withLibraries (with libraries;[ SDL freetype ]);
  };
}
