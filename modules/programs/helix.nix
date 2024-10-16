{ pkgs, vars, inputs, ... }:

{
  environment = {
    # systemPackages = with pkgs; [ helix ];
    systemPackages = [ inputs.helix.packages."${pkgs.system}".helix ];
    # sessionVariables = { HELIX_RUNTIME = "$HOME/src/helix/runtime"; };
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

        settings = {
          theme = "catppuccin_frappe";
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
