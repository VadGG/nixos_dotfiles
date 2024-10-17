{ pkgs, vars, inputs, ... }:

{
  environment = { systemPackages = with pkgs; [ zellij ]; };

  home-manager.users.${vars.user} = {
    programs = {
      yazi = { enable = true; };

      bash = {
        bashrcExtra = ''
          c() {
            local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
            yazi "$@" --cwd-file="$tmp"
            if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
              builtin cd -- "$cwd"
            fi
            rm -f -- "$tmp"
          }

        '';

      };
    };

    xdg.configFile."yazi" = {
      enable = true;
      recursive = true;
      source = ./config/yazi;
    };

  };
}
