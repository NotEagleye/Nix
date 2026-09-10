{ self, ... }: {

  flake.nixosModules.Configuration = { config, pkgs, ... }: {
    imports = [
    	self.nixosModules.Hardware

      # Features
      self.nixosModules.Nixcats-nvim

      # Programs
      self.nixosModules.Froststrap
      self.nixosModules.Helium

      # Home
      self.nixosModules.HomeManager
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.kernelPackages = pkgs.linuxPackages_7_1;
    boot.kernelParams = [ "acpi_backlight=native" "amd_pstate=active" "nvidia_drm.modeset=1" ];

    networking.hostName = "nixos";

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    hardware.nvidia = {
      modesetting.enable = true;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      powerManagement.enable = true;
      powerManagement.finegrained = false;
    };

    networking.networkmanager.enable = true;

    time.timeZone = "Asia/Tbilisi";
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };

    services.xserver.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];

    services.keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = [ "*" ];
          settings = {
            main = {
              capslock = "esc";
              esc = "capslock";
            };
          };
        };
      };
    };

    # services.displayManager.sddm.enable = true;
    # services.desktopManager.plasma6.enable = true;

    services.displayManager.ly = {
      enable = true;
      settings = {
        animate = true;
        animation = "matrix";
      };
    };

    services.xserver.windowManager.i3 = {
      enable = true;
    };

    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      #jack.enable = true;
      #wireplumber.enable = true;
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      interactiveShellInit = ''
        eval "$(${pkgs.starship}/bin/starship init zsh)"
      
        zstyle ':completion:*' menu select
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      '';
    };

    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];

    users.users."lenovo" = {
      isNormalUser = true;
      description = "Lenovo";
      extraGroups = [ "networkmanager" "wheel" ];
      # packages = with pkgs; [ ];
    };

    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    environment.sessionVariables = {
      TERMINAL = "kitty";
    };

    environment.systemPackages = with pkgs; [
      # wm/de + utils
      i3 rofi polybar

      # compositor
      picom

      # display
      xsct feh

      # notification
      dunst libnotify

      # image
      xclip maim
      
      # editors
      vim

      # neovim
      ripgrep

      # utils
      wget steam-run steamcmd fastfetch git yt-dlp brightnessctl fzf networkmanagerapplet btop

      # terminal
      kitty

      # shell
      starship zsh-autosuggestions zsh-syntax-highlighting

      # network
      ethtool aria2

      # file manager
      yazi

      # nixos
      nix-search-tv

      # compression
      innoextract _7zz unrar

      # apps
      discord steam heroic qbittorrent localsend

      # media
      rmpc mpd
    ];

    system.stateVersion = "26.05";
  };

}
