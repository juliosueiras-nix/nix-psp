{ pspsdk, callPackage, libraries, ... }:

{
  gfx = callPackage ./gfx.nix {
    pspsdk = pspsdk.withLibraries (with libraries; [ SDL2 ]);
  };
  image = callPackage ./image.nix {
    pspsdk = pspsdk.withLibraries (with libraries; [ SDL2 libpng jpeg ]);
  };
  mixer = callPackage ./mixer.nix {
    pspsdk = pspsdk.withLibraries (with libraries; [ SDL2 libmikmod ]);
  };
  ttf = callPackage ./ttf.nix {
    pspsdk = pspsdk.withLibraries (with libraries; [ SDL2 freetype ]);
  };
}
