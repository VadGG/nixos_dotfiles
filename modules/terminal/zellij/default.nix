{ pkgs, vars, ... }:

{
  environment = { systemPackages = with pkgs; [ zellij ]; };

  home-manager.users.${vars.user} = {
    programs = {
      zellij = { enable = true; };
      bash = { shellAliases = { z = "zellij"; }; };

    };
    xdg.configFile."zellij/config.kdl" = {
      enable = true;
      source = ./config.kdl;
    };
  };
}
