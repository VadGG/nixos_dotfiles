# Main system configuration. More information available in configuration.nix(5) man page.
#
#  flake.nix
#   ├─ ./hosts
#   │   ├─ default.nix
#   │   └─ configuration.nix *
#   └─ ./modules
#       ├─ ./desktops
#       │   └─ default.nix
#       ├─ ./editors
#       │   └─ default.nix
#       ├─ ./hardware
#       │   └─ default.nix
#       ├─ ./programs
#       │   └─ default.nix
#       ├─ ./services
#       │   └─ default.nix
#       ├─ ./shell
#       │   └─ default.nix
#       └─ ./theming
#           └─ default.nix
#

{ lib, config, pkgs, stable, inputs, vars, ... }:

let
  # terminal = pkgs.${vars.terminal};
in {
  # imports = (import ../modules/desktops ++
  #   import ../modules/editors ++
  #   import ../modules/hardware ++
  #   import ../modules/programs ++
  #   import ../modules/services ++
  #   import ../modules/shell ++
  #   import ../modules/theming);

  imports = (import ../modules/programs ++ import ../modules/terminal);

  boot = {
    tmp = {
      cleanOnBoot = true;
      tmpfsSize = "5GB";
    };
    # kernelPackages = pkgs.linuxPackages_latest;
  };

  users.users.${vars.user} = {
    isNormalUser = true;
    extraGroups =
      [ "wheel" "video" "audio" "camera" "networkmanager" "lp" "scanner" ];
    useDefaultShell = true;
  };

  time.timeZone = "Europe/Brussels";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = { LC_MONETARY = "nl_BE.UTF-8"; };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  fonts.packages = with pkgs; [
    carlito # NixOS
    vegur # NixOS
    source-code-pro
    jetbrains-mono
    font-awesome # Icons
    corefonts # MS
    noto-fonts # Google + Unicode
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  environment = {
    sessionVariables = { FLAKE = "/home/${vars.user}/dotfiles"; };
    variables = {
      # TERMINAL = "${vars.terminal}";
      # EDITOR = "${vars.editor}";
      # VISUAL = "${vars.editor}";
    };
    systemPackages = with pkgs;
      [
        inputs.zen-browser.packages."${system}".default
        # Terminal
        # terminal # Terminal Emulator
        btop # Resource Manager
        # cifs-utils # Samba
        # coreutils # GNU Utilities
        git # Version Control
        # gvfs # Samba
        # killall # Process Killer
        lshw # Hardware Config
        nano # Text Editor
        # nodejs # Javascript Runtime
        # nodePackages.pnpm # Package Manager
        nix-tree # Browse Nix Store
        pciutils # Manage PCI
        ranger # File Manager
        smartmontools # Disk Health
        tldr # Helper
        usbutils # Manage USB
        wget # Retriever
        xdg-utils # Environment integration

        nh
        nix-output-monitor
        nvd

        # starship
        lazygit

        # Video/Audio
        # alsa-utils # Audio Control
        # feh # Image Viewer
        # linux-firmware # Proprietary Hardware Blob
        # mpv # Media Player
        # pavucontrol # Audio Control
        # pipewire # Audio Server/Control
        # pulseaudio # Audio Server/Control
        # qpwgraph # Pipewire Graph Manager
        vlc # Media Player

        # Apps
        appimage-run # Runs AppImages on NixOS
        firefox # Browser
        google-chrome # Browser
        transmission_4-gtk # Torrenting client
        # remmina # XRDP & VNC Client

        # File Management
        file-roller # Archive Manager
        pcmanfm # File Browser
        p7zip # Zip Encryption
        rsync # Syncer - $ rsync -r dir1/ dir2/
        unzip # Zip Files
        unrar # Rar Files
        wpsoffice # Office
        zip # Zip

        # Other Packages Found @
        # - ./<host>/default.nix
        # - ../modules
      ] ++ (with stable; [
        # Apps
        # firefox # Browser
        flatpak
        image-roll # Image Viewer
      ]);
  };

  services.flatpak.enable = true;
  # xdg.portal.enable = true;
  programs = { dconf.enable = true; };

  hardware.pulseaudio.enable = false;
  services = {
    printing = { enable = true; };
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
    openssh = {
      enable = true;
      allowSFTP = true;
      extraConfig = ''
        HostKeyAlgorithms +ssh-rsa
      '';
    };
  };

  nix = {
    settings = { auto-optimise-store = true; };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };
    # package = pkgs.nixVersions.latest;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };
  nixpkgs.config.allowUnfree = true;

  system = {
    # autoUpgrade = {
    #   enable = true;
    #   channel = "https://nixos.org/channels/nixos-unstable";
    # };
    stateVersion = "24.05";
  };

  home-manager.users.${vars.user} = {
    home = {
      stateVersion = "24.05";

      packages = with pkgs; [ nnn starship ];
    };
    programs = {
      home-manager.enable = true;

      bash = {
        enable = true;
        enableCompletion = true;
        bashrcExtra = ''
          export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
          # export HELIX_RUNTIME="/nix/store/q5k6926qyz5iar08av6pn2a82r23zs9q-helix-24.07/lib/runtime"
          # export HELIX_DEFAULT_RUNTIME="/nix/store/q5k6926qyz5iar08av6pn2a82r23zs9q-helix-24.07/lib/runtime"
          # ln -s $HELIX_RUNTIME ~/.config/helix/runtime
          # ln -s $HELIX_RUNTIME /nix/store/q5k6926qyz5iar08av6pn2a82r23zs9q-helix-24.07/bin/runtime
        '';

        # set some aliases, feel free to add more or remove some
        shellAliases = { k = "kubectl"; };
      };

      # helix = {
      #   enable = true;
      #   settings = {
      #     theme = "nord";
      #   };

      #   extraPackages = with pkgs; [
      #     # Runtime dependencies
      #     emmet-ls
      #     nodejs

      #   ];

      #   languages = {
      #     language = [
      #       {
      #         name = "nix";
      #         formatter.command = "alejandra";
      #         auto-format = true;
      #         indent = {
      #           tab-width = 8;
      #           unit = "t";
      #         };
      #       }
      #     ];
      #   };

      # };

      git = {
        enable = true;
        extraConfig = {
          user.name = "VadimG";
          user.email = "vadm.gagarin@gmail.com";
        };
      };

      starship = {
        enable = true;
        # custom settings
        settings = {
          add_newline = false;
          aws.disabled = true;
          gcloud.disabled = true;
          line_break.disabled = true;
        };
      };

    };

    xdg = {
      enable = true;
      # mime.enable = true;
      # mimeApps = lib.mkIf (config.gnome.enable == false) {
      #   enable = true;
      #   # defaultApplications = {
      #   #   "image/jpeg" = [ "image-roll.desktop" "feh.desktop" ];
      #   #   "image/png" = [ "image-roll.desktop" "feh.desktop" ];
      #   #   "text/plain" = "nvim.desktop";
      #   #   "text/html" = "nvim.desktop";
      #   #   "text/csv" = "nvim.desktop";
      #   #   "application/pdf" = [ "wps-office-pdf.desktop" "firefox.desktop" "google-chrome.desktop" ];
      #   #   "application/zip" = "org.gnome.FileRoller.desktop";
      #   #   "application/x-tar" = "org.gnome.FileRoller.desktop";
      #   #   "application/x-bzip2" = "org.gnome.FileRoller.desktop";
      #   #   "application/x-gzip" = "org.gnome.FileRoller.desktop";
      #   #   "x-scheme-handler/http" = [ "firefox.desktop" "google-chrome.desktop" ];
      #   #   "x-scheme-handler/https" = [ "firefox.desktop" "google-chrome.desktop" ];
      #   #   "x-scheme-handler/about" = [ "firefox.desktop" "google-chrome.desktop" ];
      #   #   "x-scheme-handler/unknown" = [ "firefox.desktop" "google-chrome.desktop" ];
      #   #   "x-scheme-handler/mailto" = [ "gmail.desktop" ];
      #   #   "audio/mp3" = "mpv.desktop";
      #   #   "audio/x-matroska" = "mpv.desktop";
      #   #   "video/webm" = "mpv.desktop";
      #   #   "video/mp4" = "mpv.desktop";
      #   #   "video/x-matroska" = "mpv.desktop";
      #   #   "inode/directory" = "pcmanfm.desktop";
      #   # };
      # };

      # desktopEntries.image-roll = {
      #   name = "image-roll";
      #   exec = "${stable.image-roll}/bin/image-roll %F";
      #   mimeType = [ "image/*" ];
      # };

      # desktopEntries.gmail = {
      #   name = "Gmail";
      #   exec = ''xdg-open "https://mail.google.com/mail/?view=cm&fs=1&to=%u"'';
      #   mimeType = [ "x-scheme-handler/mailto" ];
      # };

    };

  };

}
