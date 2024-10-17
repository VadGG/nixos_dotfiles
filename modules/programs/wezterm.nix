{ pkgs, vars, ... }:

{
  environment = { systemPackages = with pkgs; [ wezterm ]; };

  home-manager.users.${vars.user} = {
    programs = { wezterm = { enable = true; }; };
    xdg.configFile."wezterm" = {
      source = ./config/wezterm;
      recursive = true;
    };
  };
}
