{ pkgs, vars, ... }:

{
  environment = { systemPackages = with pkgs; [ wezterm ]; };

  xdg.configFile."wezterm" = {
    source = ./config/wezterm;
    recursive = true;
  };

  home-manager.users.${vars.user} = {
    programs = { wezterm = { enable = true; }; };
  };
}
