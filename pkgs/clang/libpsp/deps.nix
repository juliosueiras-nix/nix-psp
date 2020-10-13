{ rustPlatform, fetchCrate, ...}:

{
  cargo-psp = rustPlatform.buildRustPackage {
    pname = "cargo-psp";
    version = "0.1.1";

    cargoSha256 = "WYh80lt3VM/2t9h3OOAKNSqpe5XHBP56qVNOh3/coic=";

    checkPhase = "true";

    src = fetchCrate {
      crateName = "cargo-psp";
      version = "0.1.1";
      sha256 = "yHDaSpLf72kGo4ItIEvi0wAq3vg7dBuFFTGa9R7MWxU=";
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
