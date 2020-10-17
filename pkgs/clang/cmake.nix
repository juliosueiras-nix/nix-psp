{ src, stdenv, ... }:

stdenv.mkDerivation {
  name = "psp-clang-cmake";

  src = fetchTree {
    type = "git";
    url = "https://github.com/wally4000/clang-psp";
    rev = "7a76ceb1ecd45857bc3b421690ee1e0a057a8d30";
  };

  installPhase = ''
    mkdir -p $out/psp/share/cmake
    cp resources/cmake/* $out/psp/share/cmake/
  '';
}
