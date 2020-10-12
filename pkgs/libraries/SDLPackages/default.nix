{ srcs, impureMode, pspsdk, fetchFromGitHub, callPackage, libraries, ... }:

{
  gfx = callPackage ./gfx.nix {
    src = if impureMode then srcs.libraries.SDL.gfx else fetchFromGitHub {
      repo = "SDL_gfx";
      owner = "pspdev";
      rev = "4363617b2ccf0ffd6ba6cb5baf0e9c8305df06e8";
      sha256 = "SJUzpT1iRjYpYmdAL53NCOcLzeEjlKrwgO4KU8MRE6w=";
    };
    pspsdk = pspsdk.withLibraries (with libraries; [ SDL ]);
  };
  image = callPackage ./image.nix {
    src = if impureMode then srcs.libraries.SDL.image else fetchFromGitHub {
      repo = "SDL_image";
      owner = "pspdev";
      rev = "eb1d8d658c08672d3b6e682212363c3c89e05314";
      sha256 = "VGwpXwz8oe3HKI7Isd+QNfRR5ZECaTqNyxpmYxLKB14=";
    };
    pspsdk = pspsdk.withLibraries (with libraries; [ SDL libpng jpeg ]);
  };
  mixer = callPackage ./mixer.nix {
    src = if impureMode then srcs.libraries.SDL.mixer else fetchFromGitHub {
      repo = "SDL_mixer";
      owner = "pspdev";
      rev = "46a52a334e6eb753bc1c2afeb68a009755409e47";
      sha256 = "CzmExrvxBWgz8lh7Tv/rGa0wZh3b2IdL0BvbI7P9aBE=";
    };
    pspsdk = pspsdk.withLibraries (with libraries; [ SDL libmikmod ]);
  };
  ttf = callPackage ./ttf.nix {
    src = if impureMode then srcs.libraries.SDL.ttf else fetchFromGitHub {
      repo = "SDL_ttf";
      owner = "pspdev";
      rev = "65da6a18b7b7f89ac67473e11311a21c1ea22de0";
      sha256 = "BeSYKvyJr167a4nJQtp2B9fkYSYVFTk7gUA7MRXoWs8=";
    };
    pspsdk = pspsdk.withLibraries (with libraries; [ SDL freetype ]);
  };
}
