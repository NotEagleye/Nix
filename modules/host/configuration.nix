{ self, ... }: {

  flake.nixosModules.Configuration = { config, pkgs, ... }: {
    imports = [
    	self.nixosModules.Hardware

      # Features
      self.nixosModules.Nixcats-nvim

      # Programs
      self.nixosModules.Froststrap
      self.nixosModules.Helium
      self.nixosModules.SKLauncher

      # Home
      self.nixosModules.HomeManager
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.kernelPackages = pkgs.linuxPackages_7_1;
    boot.kernelParams = [ "acpi_backlight=native" "amd_pstate=active" "nvidia_drm.modeset=1" ];

    networking.hostName = "nixos";

    networking.firewall.allowedTCPPorts = [ 7777 ];
    networking.firewall.allowedUDPPorts = [ 7777 ];

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

    services.flatpak.enable = true;
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
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

    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };

    programs.zsh = {
      enable = true;
    };

    programs.nix-ld.enable = true;

    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
    ];

    users.users."lenovo" = {
      isNormalUser = true;
      description = "Lenovo";
      extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
      # packages = with pkgs; [ ];
    };

    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    environment.sessionVariables = {
      TERMINAL = "kitty";
      EDITOR = "nvim";
    };

    environment.systemPackages = with pkgs; [
      # wm/de + utils
      i3 rofi polybar

      # sound
      pulseaudio

      # compositor
      picom

      # display
      xsct feh

      # notification
      dunst libnotify

      # virtualisation
      virt-manager

      # image
      xclip maim

      # editing
      avidemux
      
      # editors
      vim

      # neovim
      ripgrep

      # utils
      wget steam-run steamcmd fastfetch git yt-dlp brightnessctl fzf networkmanagerapplet btop gpu-screen-recorder-ui

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
