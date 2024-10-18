{ inputs, nixpkgs, nixpkgs-stable, nixos-hardware, home-manager, zen-browser
, vars, ... }:

let
  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  stable = import nixpkgs-stable {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in {
  # Desktop Profile
  minipc = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit lib inputs system pkgs stable vars;
      host = { hostName = "minipc"; };
    };
    modules = [
      ./minipc
      ./configuration.nix

      inputs.xremap-flake.nixosModules.default
      # This is effectively an inline module
      {
        # Modmap for single key rebinds
        services.xremap.config.modmap = [{
          name = "Global";
          remap = { "CapsLock" = "Esc"; }; # globally remap CapsLock to Esc
        }];

      }

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };

}
