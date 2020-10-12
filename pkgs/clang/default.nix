{ callPackage, lib, writeText, applyPatches, makeRustPlatform, impureMode, srcs, rustChannel, ... }:

let 
  rustPlatform = makeRustPlatform {
    cargo = rustChannel.rust.override {
      extensions = [ "rust-src" "rust-std" "rustc-dev" ];

    };
    rustc = rustChannel.rust.override {
      extensions = [ "rust-src" "rust-std" "rustc-dev" ];
    };
  };

  xargo-toml = lib.generators.toINI { } {
    "target.mipsel-sony-psp.dependencies.alloc" = { };
    "target.mipsel-sony-psp.dependencies.core" = { };
    "target.mipsel-sony-psp.dependencies.panic_unwind" = { stage = 1; };
  };

  srcCargoDeps = rustPlatform.fetchCargoTarball {
    name = "rust-src-cargo";
    sourceRoot = null;
    unpackPhase = null;
    src = let
      cargoFile = writeText "cargo-file" ''
        [workspace]
        members = [
          "library/std",
        ]
      '';
    in applyPatches {
      name = "rust-src";
      src = "${rustSrc}/lib/rustlib/src/rust";
      postPatch = ''
        cp ${cargoFile} Cargo.toml
        rm Cargo.lock
        cp ${rustSrc}/lib/rustlib/src/rust/Cargo.lock Cargo.lock
        chmod a+rw Cargo.*
      '';
    };
    sha256 = "X1HDKCoYI0NUbsfpypkrrYPcdGf7vQIQLY5WG4VYmEk=";
  };

  rustSrc = rustChannel.rust.override { extensions = [ "rust-src" "rust-std" ]; };
in rec {
  libpsp = if impureMode then callPackage ./libpsp/impure.nix {
    src = srcs.clang.rust-psp;
    inherit xargo-toml rustPlatform;
  } else callPackage ./libpsp {
    inherit srcCargoDeps xargo-toml rustPlatform;
  };
}
