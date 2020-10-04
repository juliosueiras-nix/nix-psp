{
  description = "PSP Toolchain";

  inputs.nixpkgs.url =
    "github:NixOS/nixpkgs/469f14ef0fade3ae4c07e4977638fdf3afc29e08";

    outputs = { self, nixpkgs }:
    let 
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config = {
          allowUnfree = true;
        };
      };
    in {
      createPSPSDK = { newlibVersion ? "1.20.0", allowCFWSDK ? false, ... }:
      let
        toolchain = import ./pkgs/toolchain/default.nix {
          inherit (pkgs) callPackage fetchFromGitHub;
          inherit newlibVersion;
        };
        pspsdk = toolchain.stage2.pspsdk;

        libraries = import ./pkgs/libraries/all-packages.nix {
          inherit (pkgs) callPackage lib;
          inherit toolchain newlibVersion allowCFWSDK;
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
        };
      };

      hydraJobs = {
        default = self.createPSPSDK { allowCFWSDK = true; };

        withNewlib330 = self.createPSPSDK { newlibVersion = "3.3.0"; allowCFWSDK = true; };
      };
    };
  }
