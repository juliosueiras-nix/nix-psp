{ srcs, impureMode, pspsdk, fetchFromGitHub, callPackage, libraries, ... }:

{
  gfx = callPackage ./gfx.nix {
    src = if impureMode then srcs.libraries.SDL2.gfx else fetchFromGitHub {
      repo = "SDL_gfx";
      owner = "pspdev";
      rev = "89d60ed909750fc7c1900ecbbf2b7077b28af0a2";
      sha256 = "4L/SC/i13Wl+EyUKI6ALYPFTRXzYmtYn0jhRp+2sUQM=";
    };
    pspsdk = pspsdk.withLibraries (with libraries; [ SDL2 ]);
  };
  image = callPackage ./image.nix {
    src = if impureMode then srcs.libraries.SDL2.image else fetchFromGitHub {
      repo = "SDL_image";
      owner = "pspdev";
      rev = "f9423262df6cc16f6301fed2e75cc6b9e8e55c10";
      sha256 = "nph9RWxj/tWYtj/jcGw6ThM8LiaVjb1PoFo+mIZQkys=";
    };
    pspsdk = pspsdk.withLibraries (with libraries; [ SDL2 libpng jpeg ]);
  };
  mixer = callPackage ./mixer.nix {
    src = if impureMode then srcs.libraries.SDL2.mixer else fetchFromGitHub {
      repo = "SDL_mixer";
      owner = "pspdev";
      rev = "25b832dd01391d6d62c2380dbb403e2474c8a3ad";
      sha256 = "W+wLg4piO6ZfZEwQtf8CjhUGBBqHNr2gcM39IEkKBhk=";
    };
    pspsdk = pspsdk.withLibraries (with libraries; [ SDL2 libmikmod ]);
  };
  ttf = callPackage ./ttf.nix {
    src = if impureMode then srcs.libraries.SDL2.ttf else fetchFromGitHub {
      repo = "SDL_ttf";
      owner = "pspdev";
      rev = "d65c9eb94ab3004bd9bbe9c284535d1dd15f6e46";
      sha256 = "tyt0mN/9GPHRnyE7Xe+7KFAwLlRyMg2ZtCCwy3YcH5Q=";
    };
    pspsdk = pspsdk.withLibraries (with libraries; [ SDL2 freetype ]);
  };
}
