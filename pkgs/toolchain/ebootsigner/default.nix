{ stdenv, lib, which, pspsdk, binutils, texinfo4, fetchFromGitHub, file, ... }:

stdenv.mkDerivation {
  name = "ebootsigner";

  src = fetchGit {
    url = "https://github.com/pspdev/ebootsigner";
    ref = "master";
    #repo = "ebootsigner";
    #owner = "pspdev";

    #rev = "e32f268f17e10a9421b96211b5ee076dc976caa4";
    #sha256 = "1qdm08ppArz5p7XwnMYawcM5DNghIqNzHZU7EmUW8hs=";
  };

  buildInputs = [ pspsdk ];

  patchPhase = ''
    mkdir -p $out/bin
    sed -i "s|\$(shell psp-config --pspdev-path)/bin|$out/bin/ebootsigner|g" Makefile
  '';

  dontDisableStatic = true;
}
