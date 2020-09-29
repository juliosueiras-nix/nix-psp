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

        pspsdk = pkgs.callPackage ./pkgs/pspsdk/stage2.nix { 
          binutils = self.packages.x86_64-linux.psptoolchain.binutils;
          stage2gcc = self.packages.x86_64-linux.psptoolchain.stage2.gcc;
        };
      };

      debug = {
        gdb = pkgs.callPackage ./pkgs/gdb/default.nix {
          binutils = self.packages.x86_64-linux.psptoolchain.binutils;
          pspsdk = self.packages.x86_64-linux.psptoolchain.stage2.pspsdk;
        };

        # Skipping for now
        #insight = pkgs.callPackage ./pkgs/insight/default.nix {
        #  binutils = self.packages.x86_64-linux.psptoolchain.binutils;
        #  pspsdk = self.packages.x86_64-linux.psptoolchain.stage2.pspsdk;
        #};
      };

      tools = {
        psplinkusb = pkgs.callPackage ./pkgs/psplinkusb/default.nix {
          binutils = self.packages.x86_64-linux.psptoolchain.binutils;
          pspsdk = self.packages.x86_64-linux.psptoolchain.stage2.pspsdk;
        };

        ebootsigner = pkgs.callPackage ./pkgs/ebootsigner/default.nix {
          pspsdk = self.packages.x86_64-linux.psptoolchain.stage2.pspsdk;
        };

        psp-pkgconf = pkgs.callPackage ./pkgs/psp-pkgconf/default.nix {
          binutils = self.packages.x86_64-linux.psptoolchain.binutils;
          pspsdk = self.packages.x86_64-linux.psptoolchain.stage2.pspsdk;
        };
      };
    };

    hydraJobs = {
      build = self.packages.x86_64-linux.psptoolchain;
      test = pkgs.vim;
    };
  };
}
