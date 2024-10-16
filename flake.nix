{
  description = "HomeLab Nix Configuration";

  inputs = {
    nixpkgs.url =
      "github:nixos/nixpkgs/nixos-unstable"; # Nix Packages (Default)

    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable"; # Unstable Nix Packages
    nixpkgs-stable.url =
      "github:nixos/nixpkgs/nixos-24.05"; # Unstable Nix Packages

    nixos-hardware.url =
      "github:nixos/nixos-hardware/master"; # Hardware Specific Configurations

    helix.url = "github:tdaron/helix/command-expansion";

    zen-browser.url = "github:MarceColl/zen-browser-flake";

    xremap-flake.url = "github:xremap/nix-flake";

    # NixOS community
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, nixpkgs-stable, nixos-hardware, home-manager
    , zen-browser, ... }@inputs:
    let vars = { user = "vadim"; };
    in {
      nixosConfigurations = (import ./hosts {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs nixpkgs-stable nixos-hardware home-manager
          zen-browser vars; # Inherit inputs
      });

      # nixosConfigurations = {

      #   vadim = lib.nixosSystem {
      #     inherit system;
      #     modules = [
      #       ./configuration.nix
      #     ];
      #   };

      # };
      # hmConfig = {
      #   vadim = home-manager.lib.homeManagerConfiguration {
      #     inherit system pkgs;
      #     username = "vadim";
      #     homeDirectory = "/home/vadim";
      #     stateVersion = "22.11";
      #     configuration = {
      #       imports = [

      #       ];
      #     };

      #   };
      # };

    };
}

