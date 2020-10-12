{ src, cacert, xargo-toml, stdenv, rustPlatform, git, applyPatches, fetchCrate, ... }:

let
  deps = import ./deps.nix {
    inherit rustPlatform fetchCrate;
  };
in stdenv.mkDerivation {
  name = "libpsp";

  buildInputs = [
    cargo-psp
    xargo
    rustPlatform.rust.rustc
    rustPlatform.rust.cargo
    git
  ];

  buildPhase = ''
    substituteInPlace Cargo.toml --replace ', "cargo-psp"' '''

    pushd .
      cd psp
      export XARGO_HOME="$TMPDIR/.xargo"
      export CARGO_HOME="$TMPDIR/.cargo"
      xargo rustc --features stub-only --target mipsel-sony-psp -- -C opt-level=3 -C panic=abort
    popd
  '';

  CARGO_NET_GIT_FETCH_WITH_CLI = "true";
  SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  dontStrip = true;
  dontPatchELF = true;

  installPhase = ''
    mkdir -p $out/psp/sdk/lib
    cp target/mipsel-sony-psp/debug/libpsp.a $out/psp/sdk/lib
  '';

  src = (applyPatches {
    name = "rust-psp-src";
    inherit src;

    postPatch = ''
      echo "${xargo-toml}" > psp/Xargo.toml
    '';
  });
}
