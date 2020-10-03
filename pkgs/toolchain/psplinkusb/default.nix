{ stdenv, lib, which, pspsdk, binutils, texinfo4, fetchFromGitHub, readline
, ncurses, libusb, file, ... }:

stdenv.mkDerivation {
  name = "psplinkusb";

  src = fetchFromGitHub {
    repo = "psplinkusb";
    owner = "pspdev";

    rev = "9a9512ed115c3415ac953b64613d53283a75ada9";
    sha256 = "PGEwA3KYYksAuG7AMJVbqHbwE6dIMO2WnGnnUEiln04=";
  };

  buildInputs = [ file texinfo4 pspsdk binutils readline ncurses libusb ];

  patchPhase = ''
    find . -name "Makefile" -exec sed -i "s|PREFIX=.*|PREFIX=$out|g" {} \; -exec sed -i 's|lcurses|lncurses|g' {} \;
  '';

  PSPSDK = "${pspsdk}";

  makefile = "Makefile.clients";

  dontDisableStatic = true;
}
