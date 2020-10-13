{ callPackage, llvmPackages_10, symlinkJoin, fetchCrate, lib, writeText, applyPatches, makeRustPlatform, impureMode, srcs, rustChannel, ... }:

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

  pspsdk = callPackage ./pspsdk {
    inherit newlib;
    src = if impureMode then srcs.clang.pspsdk else fetchTree {
      type = "tarball";
      url = "https://github.com/wally4000/pspsdk/archive/d26212d9df32d825f0d1257d17224ad6df725dae.tar.gz";
      narHash = "sha256-x/S+E797xhaJDQKxxoDRDEuOhC/ENJLC+umX2/hy0kA=";
    };
  };

  pspsdkData = callPackage ./pspsdk/data.nix {
    src = if impureMode then srcs.clang.pspsdk else fetchTree {
      type = "tarball";
      url = "https://github.com/wally4000/pspsdk/archive/d26212d9df32d825f0d1257d17224ad6df725dae.tar.gz";
      narHash = "sha256-x/S+E797xhaJDQKxxoDRDEuOhC/ENJLC+umX2/hy0kA=";
    };
  };

  newlib = callPackage ./newlib {
    inherit pspsdkData;
    src = if impureMode then srcs.clang.newlib else fetchTree {
      type = "tarball";
      url = "https://github.com/overdrivenpotato/newlib/archive/bea6cd03242f16778de72fd78489ff139e1741e8.tar.gz";
      narHash = "sha256-c8T7WQ5pFAhXKd6aN3zkLG/OWVo0vySrJch7iV4jnDk=";
    };
  };

  pspsdkWithLLVM = symlinkJoin {
    name = "pspsdk-llvm-env";
    postBuild = ''
      cp $out/psp/sdk/lib/clang.conf cur.clang.conf
      unlink $out/psp/sdk/lib/clang.conf
      cp cur.clang.conf $out/psp/sdk/lib/clang.conf
      substituteInPlace $out/psp/sdk/lib/clang.conf --replace '$(out)' "$out"
    '';
    paths = [ 
      cargo-psp
      libpsp
      pspsdk
      llvmPackages_10.llvm
      llvmPackages_10.clang
    ];
  };
}
