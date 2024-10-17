{ pkgs, vars, inputs, ... }:

{
  environment = { systemPackages = with pkgs; [ zellij ]; };

  home-manager.users.${vars.user} = {
    programs = { yazi = { enable = true; }; };

    xdg.configFile."yazi/config.toml" = {
      enable = true;
      source = ./config.toml;
    };

    xdg.configFile."yazi/theme.toml" = {
      enable = true;
      source = ./theme.toml;
    };

  };
}
