{
  description = "PSP Toolchain";

  inputs.nixpkgs.url =
    "github:NixOS/nixpkgs/469f14ef0fade3ae4c07e4977638fdf3afc29e08";

  inputs.nixpkgs-mozilla = {
    url =
      "github:mozilla/nixpkgs-mozilla/efda5b357451dbb0431f983cca679ae3cd9b9829";
    flake = false;
  };

  outputs = { self, nixpkgs, nixpkgs-mozilla }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config = { allowUnfree = true; };
        overlays = [ (import nixpkgs-mozilla) ];
      };
    in {
      createPSPSDK = import ./lib.nix {
        inherit pkgs;
      };

      hydraJobs = {
        default = self.createPSPSDK { allowCFWSDK = true; };
        withNewlib330 = self.createPSPSDK {
          newlibVersion = "3.3.0";
          allowCFWSDK = true;
        };
      };

      devShell.x86_64-linux = pkgs.mkShell {
        buildInputs = [ pkgs.clang pkgs.autoconf pkgs.automake];
      };
    };
}
