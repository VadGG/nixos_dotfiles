{ inputs, nixpkgs, nixpkgs-stable, nixos-hardware, home-manager, vars, ... }:

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
      inherit inputs system stable vars;
      host = { hostName = "minipc"; };
    };
    modules = [
      ./minipc
      ./configuration.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };

}
