{ pkgs, vars, inputs, ... }:

let
  renamer = with pkgs;
    rustPlatform.buildRustPackage rec {
      pname = "renamer";
      version = "v0.2.0";

      src = fetchFromGitHub {
        owner = "adriangoransson";
        repo = pname;
        rev = version;
        sha256 = "sha256-s4U5xSY8DthVXFjRmfhRfYwtKXYCnmgEg/QtIv8IvFY=";
      };

      cargoHash = "sha256-3VTe6E4hBTAqX33P8OVG5IProJwWo/3Hahjrn+qFB1w=";
      meta = {
        description = "A bulk renaming tool for files.";
        homepage = "https://github.com/adriangoransson/renamer.git";
        license = lib.licenses.unlicense;
        maintainers = [ ];
      };
    };

in {
  # nixpkgs.config.allowUnfree = true;
  # nixpkgs.overlays = [ inputs.helix.overlays.default ];
  # environment = {
  #   systemPackages = with pkgs; [ fzf ripgrep bat helix ];
  #   # systemPackages = with pkgs;
  #   #   [ inputs.helix.packages."${pkgs.system}".helix ];
  #   # sessionVariables = { HELIX_RUNTIME = "$HOME/src/helix/runtime"; };
  # };

  home-manager.users.${vars.user} = {
    home.packages = with pkgs; [ renamer ];

  };
}

# { pkgs, vars, inputs, ... }:
# let

#   renamer = with pkgs;
#     rustPlatform.buildRustPackage rec {
#       pname = "renamer";
#       version = "v0.2.0";

#       src = fetchFromGitHub {
#         owner = "adriangoransson";
#         repo = pname;
#         rev = version;
#         hash = "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO";
#       };

#       cargoHash = "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO";

#       meta = {
#         description = "A bulk renaming tool for files.";
#         homepage = "https://github.com/adriangoransson/renamer.git";
#         license = lib.licenses.unlicense;
#         maintainers = [ ];
#       };
#     };

# in { }
