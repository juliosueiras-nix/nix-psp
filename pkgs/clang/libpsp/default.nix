{ callPackage, srcCargoDeps, cacert, xargo-toml, stdenv, rustPlatform, git, applyPatches, fetchCrate, ... }:

let
  deps = import ./deps.nix {
    inherit rustPlatform fetchCrate;
  };
in rustPlatform.buildRustPackage {
  name = "libpsp";

  buildInputs = [
    deps.cargo-psp
    deps.xargo
  ];

  checkPhase = "true";

  buildPhase = ''
    substituteInPlace Cargo.toml --replace ', "cargo-psp"' '''

    pushd . 
      cd ../$(stripHash $cargoDeps)
      cp ${srcCargoDeps} src.tar.gz
      tar zxvf src.tar.gz
      rm src.tar.gz
      rm rust-src-cargo-vendor.tar.gz/Cargo.lock
      cp -rf rust-src-cargo-vendor.tar.gz/* .
      rm -rf rust-src-cargo-vendor.tar.gz
    popd

    pushd .
      cd psp
      export XARGO_HOME="$TMPDIR/.xargo"
      xargo rustc --features stub-only --target mipsel-sony-psp -- -C opt-level=3 -C panic=abort
    popd
  '';

  dontStrip = true;
  dontPatchELF = true;

  cargoSha256 = "il0khy9y7WF7WNZGoR/KcZKtwmH4nndIWhSd0TAjG9Q=";

  installPhase = ''
    mkdir -p $out/psp/sdk/lib
    cp target/mipsel-sony-psp/debug/libpsp.a $out/psp/sdk/lib
  '';

  src = (applyPatches {
    name = "rust-psp-src";
    src = fetchTree {
      type = "git";
      url = "https://github.com/overdrivenpotato/rust-psp";
      rev = "20a0a73eccb26c80950a623eef11ef7ffd4630bb";
    };

    postPatch = ''
      echo "${xargo-toml}" > psp/Xargo.toml
      cp ${./Cargo.lock} Cargo.lock
    '';
  });
}
