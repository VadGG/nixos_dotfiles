{ pkgs, vars, ... }:

{
  environment = { systemPackages = with pkgs; [ wezterm ]; };

  home-manager.users.${vars.user} = {
    programs = { wezterm = { enable = true; }; };
  };
}
