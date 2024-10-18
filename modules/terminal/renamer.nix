{ pkgs, vars, inputs, ... }:

let
  renamer = with pkgs;
    rustPlatform.buildRustPackage rec {
      pname = "pipe-rename";
      version = "1.6.5";

      src = fetchFromGitHub {
        owner = "marcusbuffett";
        repo = pname;
        rev = version;
        sha256 = "sha256-s4U5xSY8DthVXFjRmfhRfYwtKXYCnmgEg/QtIv8IvFY=";
      };

      cargoHash = "sha256-dszS31NAtiIsBRiuz/5bzcfYiuuON1adCUQ3+LfRhZ0=";
      meta = {
        description =
          "pipe-rename takes a list of files as input, opens your $EDITOR of choice, then renames those files accordingly.";
        homepage = "https://github.com/marcusbuffett/pipe-rename.git";
        license = lib.licenses.unlicense;
        maintainers = [ ];
      };
    };

in {
  home-manager.users.${vars.user} = {
    home.packages = with pkgs; [ renamer ];

  };
}
