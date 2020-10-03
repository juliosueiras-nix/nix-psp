{
  description = "PSP Toolchain";

  inputs.nixpkgs.url =
    "github:NixOS/nixpkgs/469f14ef0fade3ae4c07e4977638fdf3afc29e08";

  outputs = { self, nixpkgs }:
    let pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {
      createPSPSDK = { newlibVersion ? "1.20.0", ... }:
        let
          toolchain = import ./pkgs/toolchain/default.nix {
            inherit (pkgs) callPackage;
            inherit newlibVersion;
          };
          pspsdk = toolchain.stage2.pspsdk;

          libraries = import ./pkgs/libraries/all-packages.nix {
            inherit (pkgs) callPackage lib;
            inherit toolchain newlibVersion;
          };
        in {
          inherit toolchain pspsdk libraries;
          homebrew = import ./pkgs/homebrew/all-packages.nix {
            inherit (pkgs) callPackage;
            inherit pspsdk libraries;
          };

          plugins = import ./pkgs/plugins/all-packages.nix {
            inherit (pkgs) callPackage;
            inherit pspsdk libraries;
          };

          samples = import ./pkgs/samples/all-packages.nix {
            inherit (pkgs) callPackage lib runCommand;
            inherit toolchain;
          };
        };

      hydraJobs = {
        default = self.createPSPSDK { };

        withNewlib330 = self.createPSPSDK { newlibVersion = "3.3.0"; };
      };
    };
}
