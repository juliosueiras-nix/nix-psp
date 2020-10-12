{ rustPlatform, fetchCrate, ...}:

{
  cargo-psp = rustPlatform.buildRustPackage {
    pname = "cargo-psp";
    version = "0.0.1";

    cargoSha256 = "KWdTQEnVSL+0Ff7M1aUM5sZ0MH15qrV9VVJOt2BWQJE=";

    src = fetchCrate {
      crateName = "cargo-psp";
      version = "0.0.1";
      sha256 = "B3xme7kVhhz02WuF0VXeFETJD05AFsniNvfH3iFq2S0=";
    };
  };

  xargo = rustPlatform.buildRustPackage {
    pname = "xargo";
    version = "0.3.22";

    cargoSha256 = "rw/V61vnQrAL6h+Husq+/JjGpIX1Yzo6ojoWSlTpzCs=";
    checkPhase = "true";

    src = fetchCrate {
      crateName = "xargo";
      version = "0.3.22";
      sha256 = "cpJSyCl+a0m+FbyCRhvqvk9E+LVA6eQ8NGeu7t0ATPU=";
    };
  };
}
