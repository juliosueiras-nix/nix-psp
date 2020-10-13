{ rustPlatform, fetchCrate, ...}:

{
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
