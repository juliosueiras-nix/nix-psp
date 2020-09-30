{
  description = "PSP Toolchain";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/469f14ef0fade3ae4c07e4977638fdf3afc29e08";

  outputs = { self, nixpkgs }: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in {
    packages.x86_64-linux.psptoolchain = {
      binutils = pkgs.callPackage ./pkgs/toolchain/binutils/default.nix {};

      stage1 = {
        gcc = pkgs.callPackage ./pkgs/toolchain/gcc/stage1.nix { 
          binutils = self.packages.x86_64-linux.psptoolchain.binutils;
        };

        pspsdk = pkgs.callPackage ./pkgs/toolchain/pspsdk/stage1.nix {
          stage1gcc = self.packages.x86_64-linux.psptoolchain.stage1.gcc;
          binutils = self.packages.x86_64-linux.psptoolchain.binutils;
        };

        newlib = pkgs.callPackage ./pkgs/toolchain/newlib/default.nix {
          binutils = self.packages.x86_64-linux.psptoolchain.binutils;
          stage1gcc = self.packages.x86_64-linux.psptoolchain.stage1.gcc;
          pspsdkLib = self.packages.x86_64-linux.psptoolchain.stage1.pspsdk;
        };
      };

      stage2 = {
        gcc = pkgs.callPackage ./pkgs/toolchain/gcc/stage2.nix { 
          binutils = self.packages.x86_64-linux.psptoolchain.binutils;
          stage1gcc = self.packages.x86_64-linux.psptoolchain.stage1.gcc;
          newlib = self.packages.x86_64-linux.psptoolchain.stage1.newlib;
          pspsdkLib = self.packages.x86_64-linux.psptoolchain.stage1.pspsdk;
        };

        pspsdk = pkgs.callPackage ./pkgs/toolchain/pspsdk/stage2.nix { 
          binutils = self.packages.x86_64-linux.psptoolchain.binutils;
          stage2gcc = self.packages.x86_64-linux.psptoolchain.stage2.gcc;
        };
      };

      debug = {
        gdb = pkgs.callPackage ./pkgs/toolchain/gdb/default.nix {
          binutils = self.packages.x86_64-linux.psptoolchain.binutils;
          pspsdk = self.packages.x86_64-linux.psptoolchain.stage2.pspsdk;
        };

        # Skipping for now
        #insight = pkgs.callPackage ./pkgs/toolchain/insight/default.nix {
        #  binutils = self.packages.x86_64-linux.psptoolchain.binutils;
        #  pspsdk = self.packages.x86_64-linux.psptoolchain.stage2.pspsdk;
        #};
      };

      tools = {
        psplinkusb = pkgs.callPackage ./pkgs/toolchain/psplinkusb/default.nix {
          binutils = self.packages.x86_64-linux.psptoolchain.binutils;
          pspsdk = self.packages.x86_64-linux.psptoolchain.stage2.pspsdk;
        };

        ebootsigner = pkgs.callPackage ./pkgs/toolchain/ebootsigner/default.nix {
          pspsdk = self.packages.x86_64-linux.psptoolchain.stage2.pspsdk;
        };

        psp-pkgconf = pkgs.callPackage ./pkgs/toolchain/psp-pkgconf/default.nix {
          binutils = self.packages.x86_64-linux.psptoolchain.binutils;
          pspsdk = self.packages.x86_64-linux.psptoolchain.stage2.pspsdk;
        };
      };
    };

    packages.x86_64-linux.libraries = pkgs.callPackage ./pkgs/libraries/all-packages.nix {
      pspsdk = self.packages.x86_64-linux.psptoolchain.stage2.pspsdk;
    };

    packages.x86_64-linux.homebrew = pkgs.callPackage ./pkgs/homebrew/all-packages.nix {
      pspsdk = self.packages.x86_64-linux.psptoolchain.stage2.pspsdk;
      libraries = self.packages.x86_64-linux.libraries;
    };

    hydraJobs = {
      build = {
        psptoolchain = self.packages.x86_64-linux.psptoolchain;
        libraries = builtins.removeAttrs self.packages.x86_64-linux.libraries [ "override" "overrideDerivation" ];
        homebrew = builtins.removeAttrs self.packages.x86_64-linux.homebrew [ "override" "overrideDerivation" ];
      };
    };
  };
}
