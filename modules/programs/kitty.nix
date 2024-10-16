{ pkgs, vars, ... }:

{
  environment = { systemPackages = with pkgs; [ kitty ]; };

  home-manager.users.${vars.user} = {
    programs = {
      kitty = {
        enable = true;
        theme = "Afterglow";
        settings = {
          confirm_os_window_close = 0;
          enable_audio_bell = "no";
          resize_debounce_time = "0";
          font_family = "FiraCode Nerd Font";
        };
      };
    };
  };
}
