{ pkgs, inputs, system, vars, ... }:

{
  nixpkgs.config.allowUnfree = true;
  # nixpkgs.overlays = [ inputs.helix.overlays.default ];
  nixpkgs.overlays =
    [ (final: prev: { helix = inputs.helix.packages.${system}.default; }) ];
  environment = {
    systemPackages = with pkgs; [ helix fzf ripgrep bat ];
    # systemPackages = with pkgs;
    #   [ inputs.helix.packages."${pkgs.system}".helix ];
    # sessionVariables = { HELIX_RUNTIME = "$HOME/src/helix/runtime"; };
  };

  home-manager.users.${vars.user} = {
    xdg.configFile."helix/bin" = {
      executable = true;
      recursive = true;
      enable = true;
      source = ./config/helix/bin;
    };

    # home = {
    #   packages = with pkgs; [ inputs.helix.packages."${pkgs.system}".helix ];
    #   # packages = with pkgs; [ nnn starship ];
    # };

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

        settings = {
          theme = "monokai_pro";
          editor = {
            true-color = true;
            cursorline = true;
            auto-save = true;
            bufferline = "always";
            color-modes = true;
            completion-trigger-len = 1;
            rulers = [ 80 120 ];
          };
          keys.normal = {
            esc = [ "collapse_selection" "keep_primary_selection" ];
            tab = [ ":buffer-next" ];
            "S-tab" = [ ":buffer-previous" ];
            X = [ "extend_line_up" ];
            L = [ "goto_line_end" ];
            H = [ "goto_line_start" ];
            J = [
              "move_visual_line_down"
              "move_visual_line_down"
              "move_visual_line_down"
            ];
            K = [
              "move_visual_line_up"
              "move_visual_line_up"
              "move_visual_line_up"
            ];
            D = [ "kill_to_line_end" ];
            C = [ "kill_to_line_end" "insert_mode" ];
            V = [ "copy_selection_on_next_line" ];
            A-m = "select_next_sibling";
            A-n = "select_prev_sibling";
          };

          keys.select = {
            L = [ "goto_line_end" ];
            H = [ "goto_line_start" ];
          };

          editor.cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };

          editor.indent-guides = {
            render = true;
            skip-levels = 20;
          };

          editor.statusline = {
            left = [ "mode" "spinner" "file-name" ];
            center = [ "version-control" ];
            right = [
              "diagnostics"
              "selections"
              "position"
              "file-encoding"
              "file-line-ending"
              "file-type"
            ];
            separator = "u2502";
            mode.normal = "NORMAL";
            mode.insert = "INSERT";
            mode.select = "SELECT";
          };

          editor.file-picker = { hidden = false; };

          editor.lsp = { display-messages = true; };

          editor.whitespace.render = {
            space = "all";
            tab = "all";
            newline = "none";
          };

          keys.normal.space = {
            F = "file_picker_in_current_buffer_directory";
            R = [ "change_selection" "paste_clipboard_before" "normal_mode" ];
            X = ":buffer-close-others";
            C-q = ":quit-all";
            C-s = ":write!";
            x = ":buffer-close";
            # space = [
            #   ":sh zellij run -f -x 10% -y 10% --width 80% --height 80% -- bash ~/.config/helix/bin/yazi-pick-current %{filename}"
            # ];

            space =
              ":sh ~/.config/helix/bin/hx-zellij-actions.sh explorer %{cwd} %{filename} %{linenumber}";

          };

          keys.normal.";" = {
            b =
              ":sh ~/.config/helix/bin/hx-zellij-actions.sh git-blame %{cwd} %{filename} %{linenumber}";
            B =
              ":sh ~/.config/helix/bin/hx-zellij-actions.sh git-blame-cwd %{cwd} %{filename} %{linenumber}";

            r =
              ":sh ~/.config/helix/bin/hx-zellij-actions.sh fzf-rename %{cwd} %{filename} %{linenumber}";
            R =
              ":sh ~/.config/helix/bin/hx-zellij-actions.sh fzf-rename-cwd %{cwd} %{filename} %{linenumber}";

            f =
              ":sh ~/.config/helix/bin/hx-zellij-actions.sh fzf-open %{cwd} %{filename} %{linenumber}";
            F =
              ":sh ~/.config/helix/bin/hx-zellij-actions.sh fzf-open-cwd %{cwd} %{filename} %{linenumber}";

            s =
              ":sh ~/.config/helix/bin/hx-zellij-actions.sh serpl %{cwd} %{filename} %{linenumber}";
            S =
              ":sh ~/.config/helix/bin/hx-zellij-actions.sh serpl-cwd %{cwd} %{filename} %{linenumber}";

            "`" =
              ":sh ~/.config/helix/bin/hx-zellij-actions.sh lazygit %{cwd} %{filename} %{linenumber}";
            "~" =
              ":sh ~/.config/helix/bin/hx-zellij-actions.sh lazygit-cwd %{cwd} %{filename} %{linenumber}";
          };

        };

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
}
