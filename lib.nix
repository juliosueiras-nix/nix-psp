{ pkgs }:
{ srcs ? null, impureMode ? false, newlibVersion ? "1.20.0", allowCFWSDK ? false, ... }:
let
  toolchain = import ./pkgs/toolchain/default.nix {
    inherit (pkgs) callPackage fetchFromGitHub;
    inherit newlibVersion impureMode srcs;
  };
  pspsdk = toolchain.stage2.pspsdk;

  libraries = import ./pkgs/libraries/all-packages.nix {
    inherit (pkgs) callPackage lib;
    inherit toolchain newlibVersion allowCFWSDK impureMode srcs;
  };
in {
  inherit toolchain pspsdk libraries;
  homebrew = import ./pkgs/homebrew/all-packages.nix {
    inherit (pkgs) callPackage;
    inherit pspsdk libraries;
  };

  plugins = import ./pkgs/plugins/all-packages.nix {
    inherit (pkgs) callPackage lib;
    inherit pspsdk libraries allowCFWSDK;
  };

  samples = import ./pkgs/samples/all-packages.nix {
    inherit (pkgs) callPackage lib runCommand;
    inherit toolchain;
    pspsdkSrc = if impureMode then srcs.toolchain.pspsdk else toolchain.pspsdkSrc;
  };

  #testingRustPSP = let
  #  rustChannel = (pkgs.rustChannelOf {
  #    channel = "nightly";
  #    date = "2020-10-07";
  #    sha256 = "juFd+PkbbaM8ULbmgz+W/F336Lis1MNuC8eDYsEqv0A=";
  #  });
  #  rustPlatform = pkgs.makeRustPlatform {
  #    cargo = rustChannel.rust.override {
  #      extensions = [ "rust-src" "rust-std" "rustc-dev" ];

  #    };
  #    rustc = rustChannel.rust.override {
  #      extensions = [ "rust-src" "rust-std" "rustc-dev" ];
  #    };
  #  };

  #  rustSrc =
  #    rustChannel.rust.override { extensions = [ "rust-src" "rust-std" ]; };
  #in rec {
  #  srcCargoDeps = rustPlatform.fetchCargoTarball {
  #    name = "test";
  #    sourceRoot = null;
  #    unpackPhase = null;
  #    src = let
  #      cargoFile = pkgs.writeText "cargo-file" ''
  #        [workspace]
  #        members = [
  #          "library/std",
  #        ]
  #      '';
  #    in pkgs.applyPatches {
  #      name = "rust-src";
  #      src = "${rustSrc}/lib/rustlib/src/rust";
  #      postPatch = ''
  #        cp ${cargoFile} Cargo.toml
  #        rm Cargo.lock
  #        cp ${rustSrc}/lib/rustlib/src/rust/Cargo.lock Cargo.lock
  #        chmod a+rw Cargo.*
  #      '';
  #    };
  #    sha256 = null;
  #  };

  #  cargo-psp = rustPlatform.buildRustPackage {
  #    pname = "cargo-psp";
  #    version = "0.0.1";

  #    cargoSha256 = "KWdTQEnVSL+0Ff7M1aUM5sZ0MH15qrV9VVJOt2BWQJE=";

  #    src = pkgs.fetchCrate {
  #      crateName = "cargo-psp";
  #      version = "0.0.1";
  #      sha256 = "B3xme7kVhhz02WuF0VXeFETJD05AFsniNvfH3iFq2S0=";
  #    };
  #  };

  #  libpsp-test = let
  #    xargo-toml = pkgs.lib.generators.toINI { } {
  #      "target.mipsel-sony-psp.dependencies.alloc" = { };
  #      "target.mipsel-sony-psp.dependencies.core" = { };
  #      "target.mipsel-sony-psp.dependencies.panic_unwind" = { stage = 1; };
  #    };
  #  in pkgs.stdenv.mkDerivation {
  #    name = "libpsp";

  #    buildInputs = [
  #      cargo-psp
  #      xargo
  #      rustPlatform.rust.rustc
  #      rustPlatform.rust.cargo
  #      pkgs.git
  #    ];

  #    buildPhase = ''
  #      substituteInPlace Cargo.toml --replace ', "cargo-psp"' '''

  #      pushd .
  #      cd psp
  #      export XARGO_HOME="$TMPDIR/.xargo"
  #      export CARGO_HOME="$TMPDIR/.cargo"
  #      xargo rustc --features stub-only --target mipsel-sony-psp -- -C opt-level=3 -C panic=abort
  #      popd
  #    '';

  #    CARGO_NET_GIT_FETCH_WITH_CLI = "true";
  #    SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  #    GIT_SSL_CAINFO = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

  #    dontStrip = true;
  #    dontPatchELF = true;

  #    installPhase = ''
  #      mkdir -p $out/psp/sdk/lib
  #      cp target/mipsel-sony-psp/debug/libpsp.a $out/psp/sdk/lib
  #    '';

  #    src = (pkgs.applyPatches {
  #      name = "rust-psp-src";
  #      src = fetchTree {
  #        type = "git";
  #        url = "https://github.com/overdrivenpotato/rust-psp";
  #        rev = "20a0a73eccb26c80950a623eef11ef7ffd4630bb";
  #      };

  #      postPatch = ''
  #        echo "${xargo-toml}" > psp/Xargo.toml
  #      '';
  #    });
  #  };

  #  #libpsp = let
  #  #  xargo-toml = pkgs.lib.generators.toINI {} {                       
  #  #    "target.mipsel-sony-psp.dependencies.alloc" = {};
  #  #    "target.mipsel-sony-psp.dependencies.core" = {};
  #  #    "target.mipsel-sony-psp.dependencies.panic_unwind" = {
  #  #      stage = 1;
  #  #    };
  #  #  };
  #  #in rustPlatform.buildRustPackage {
  #  #  name = "libpsp";

  #  #  buildInputs = [
  #  #    cargo-psp
  #  #    xargo
  #  #  ];

  #  #  checkPhase = "true";

  #  #  buildPhase = ''
  #  #    substituteInPlace Cargo.toml --replace ', "cargo-psp"' '''

  #  #    pushd . 
  #  #    #cd ../$(stripHash $cargoDeps)
  #  #    #cp ${srcCargoDeps} src.tar.gz
  #  #    #tar zxvf src.tar.gz
  #  #    #rm test-vendor.tar.gz/Cargo.lock
  #  #    #cp -rf test-vendor.tar.gz/* .
  #  #    popd

  #  #    pushd .
  #  #    cd psp
  #  #    export XARGO_HOME="$TMPDIR/.xargo"
  #  #    xargo rustc --features stub-only --target mipsel-sony-psp -- -C opt-level=3 -C panic=abort
  #  #    popd
  #  #  '';

  #  #  dontStrip = true;
  #  #  dontPatchELF = true;

  #  #  installPhase = ''
  #  #    mkdir -p $out/psp/sdk/lib
  #  #    cp target/mipsel-sony-psp/debug/libpsp.a $out/psp/sdk/lib
  #  #  '';

  #  #  src = (pkgs.applyPatches {
  #  #    name = "rust-psp-src";
  #  #    src = fetchTree {
  #  #      type = "git";
  #  #      url = "https://github.com/overdrivenpotato/rust-psp";
  #  #      rev = "20a0a73eccb26c80950a623eef11ef7ffd4630bb";
  #  #    };

  #  #    postPatch = ''
  #  #      echo "${xargo-toml}" > psp/Xargo.toml
  #  #      #cp ${./Cargo.lock} Cargo.lock
  #  #    '';
  #  #  });
  #  #};

  #  compiler_builtins = rustPlatform.buildRustPackage {
  #    pname = "compiler_builtins";
  #    version = "0.1.35";

  #    cargoSha256 = "qybEthOgivaWzW9G3e3PYK5JWRfDNMLnvNBMZ8MSEIk=";
  #    checkPhase = "true";

  #    src = pkgs.fetchCrate {
  #      crateName = "compiler_builtins";
  #      version = "0.1.35";
  #      sha256 = "QO6U8DsefgGtI6JfPlnp1SoBZPCcbJ+hQUOcpGhf6iQ=";
  #    };
  #  };

  #  cargo-xbuild = rustPlatform.buildRustPackage {
  #    name = "cargo-xbuild";

  #    cargoSha256 = "NAhMT20VwXm6zCAACOouEM8EB96S8q6HMFe+XKIDfUU=";
  #    checkPhase = "true";

  #    src = fetchTree {
  #      type = "git";
  #      url = "https://github.com/rust-osdev/cargo-xbuild";
  #      rev = "6125d0a1e475343d7224895457ea3a19b498ce12";
  #    };
  #  };

  #  xargo = rustPlatform.buildRustPackage {
  #    pname = "xargo";
  #    version = "0.3.22";

  #    cargoSha256 = "rw/V61vnQrAL6h+Husq+/JjGpIX1Yzo6ojoWSlTpzCs=";
  #    checkPhase = "true";

  #    src = pkgs.fetchCrate {
  #      crateName = "xargo";
  #      version = "0.3.22";
  #      sha256 = "cpJSyCl+a0m+FbyCRhvqvk9E+LVA6eQ8NGeu7t0ATPU=";
  #    };
  #  };
  #};
}
