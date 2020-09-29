{ stdenv, fetchurl, pspsdk, ... }:

let
  SQLITE_VERSION = "26778480";
in stdenv {
  name = "sqlite";

  src = fetchurl {
    url = "https://www.sqlite.org/src/tarball/${SQLITE_VERSION}/SQLite-${SQLITE_VERSION}.tar.gz";
    sha256 = "AnA/0H5QUP9ifSfiOgMTpKgojXoua0Z4+Jm1OxYoalA=";
  };

  buildInputs = [ pspsdk ];

  configureScript = "../configure";

  LDFLAGS ="-L$(psp-config --pspsdk-path)/lib -lc -lpspuser";
  CFLAGS ="-DSQLITE_OS_OTHER=1 -DSQLITE_OS_PSP=1 -I$(psp-config --pspsdk-path)/include";

  preConfigure = ''
    mkdir build-ppu && cd build-ppu
  '';

  configureFlags = [
    "--host=psp" 
    "--disable-readline" 
    "--disable-tcl"
    "--disable-threadsafe"
    "--disable-amalgamation"
  ];

  patches = [
    (fetchurl {
      url = "https://raw.githubusercontent.com/pspdev/psplibraries/2bd5631f2d9154a26dc09bd07ca979f8685c1d29/patches/sqlite-3.7.3-PSP.patch";
      sha256 = "IynK/hZHAVcjWq5SDVdyFqcml9Dk1yvepI7Gb6tLXlk=";
    })
  ];
}


