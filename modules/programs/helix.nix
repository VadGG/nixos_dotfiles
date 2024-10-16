{ pkgs, vars, ... }:

{
  environment = { 
    systemPackages = with pkgs; [ helix ];
    sessionVariables = {
      HELIX_RUNTIME = "$HOME/src/helix/runtime";
    };
   };

  home-manager.users.${vars.user} = {
    programs = {
      helix = {
        enable = true;
        
        defaultEditor = true;
        extraPackages = with pkgs; [
          bash-language-server
          biome
          clang-tools
          docker-compose-language-service
          dockerfile-language-server-nodejs
          golangci-lint
          golangci-lint-langserver
          gopls
          gotools
          helix-gpt
          marksman
          nil
          nixpkgs-fmt
          nodePackages.prettier
          nodePackages.typescript-language-server
          pgformatter
          (python3.withPackages
            (p: (with p; [ black isort python-lsp-black python-lsp-server ])))
          rust-analyzer
          taplo
          taplo-lsp
          terraform-ls
          typescript
          vscode-langservers-extracted
          yaml-language-server
        ];

        settings = { theme = "gruvbox_community"; };

        languages.language = [{
            name = "nix";
            auto-format = true;
            formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
          }];
          themes = {
            autumn_night_transparent = {
              "inherits" = "autumn_night";
              "ui.background" = { };
            };
          };
        };

      };
    };
  };
}
