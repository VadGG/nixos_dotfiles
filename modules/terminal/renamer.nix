{ pkgs, stable, vars, inputs, ... }:

let
  renamer = with pkgs;
    rustPlatform.buildRustPackage rec {
      pname = "pipe-rename";
      version = "1.6.5";

      # src = fetchFromGitHub {
      #   owner = "marcusbuffett";
      #   repo = pname;
      #   rev = version;
      #   sha256 = "sha256-KeqJtEBsz0fGiJUMktFeCmayQJ+B8xYo1k0a2GLfGRs";
      # };
      src = fetchCrate {
        inherit pname version;
        hash = "sha256-av/ig76O7t3dB4Irfi3yqyL30nkJJCzs5EayWRbpOI0=";
      };

      cargoHash = "sha256-3p6Bf9UfCb5uc5rp/yuXixcDkuXfTiboLl8TI0O52hE=";

      checkFlags = [
        # tests are failing upstream
        "--skip=test_dot"
        "--skip=test_dotdot"
        "--skip=test_no_replacements"
        "--skip=test_rename"
        "--skip=test_unequal_lines"
        "--skip=test_multiple_files"
        "--skip=test_one_file"
        "--skip=test_option"
        "--skip=test_with_space"
      ];
      meta = {
        description =
          "pipe-rename takes a list of files as input, opens your $EDITOR of choice, then renames those files accordingly.";
        homepage = "https://github.com/marcusbuffett/pipe-rename.git";
        license = lib.licenses.unlicense;
        maintainers = [ ];
        mainProgram = "renamer";
      };
    };

in {
  home-manager.users.${vars.user} = {
    home.packages = [ renamer ];

  };
}
