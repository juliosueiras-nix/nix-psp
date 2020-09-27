{
  description = "PSP Toolchain";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/469f14ef0fade3ae4c07e4977638fdf3afc29e08";

  outputs = { self, nixpkgs }: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in {
    packages.x86_64-linux.psptoolchain = {
      binutils = pkgs.callPackage ./pkgs/binutils/default.nix {};
      stage1 = {
        gcc = pkgs.callPackage ./pkgs/gcc/stage1.nix { 
          binutils = self.packages.x86_64-linux.psptoolchain.binutils;
        };

        pspsdk = pkgs.callPackage ./pkgs/pspsdk/stage1.nix {
          stage1gcc = self.packages.x86_64-linux.psptoolchain.stage1.gcc;
          binutils = self.packages.x86_64-linux.psptoolchain.binutils;
        };

        newlib = pkgs.callPackage ./pkgs/newlib/default.nix {
          binutils = self.packages.x86_64-linux.psptoolchain.binutils;
          stage1gcc = self.packages.x86_64-linux.psptoolchain.stage1.gcc;
          pspsdkLib = self.packages.x86_64-linux.psptoolchain.stage1.pspsdk;
        };
      };

      stage2 = {
        gcc = pkgs.callPackage ./pkgs/gcc/stage2.nix { 
          binutils = self.packages.x86_64-linux.psptoolchain.binutils;
          stage1gcc = self.packages.x86_64-linux.psptoolchain.stage1.gcc;
          newlib = self.packages.x86_64-linux.psptoolchain.stage1.newlib;
          pspsdkLib = self.packages.x86_64-linux.psptoolchain.stage1.pspsdk;
        };
      };
    };

    hydraJobs = {
      build = self.packages.x86_64-linux.psptoolchain;
    };
  };
}
