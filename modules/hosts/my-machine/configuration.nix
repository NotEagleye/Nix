{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.myMachineConfiguration = {
    pkgs,
    lib,
    config,
    ...
  }: {
    imports = [
      self.nixosModules.myMachineHardware
      self.nixosModules.niri
      self.nixosModules.nvf
      self.nixosModules.youtui
      self.nixosModules.helium
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.loader.systemd-boot.configurationLimit = 5;

    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.kernelParams = ["acpi_backlight=native" "pcie_aspm=off"];

    networking.hostName = "nixos";

    systemd.network.networks."10-enp2s0" = {
      matchConfig.Name = "enp2s0";
      linkConfig = {
        Speed = 100;
        Duplex = "full";
        AutoNegotiation = false;
      };
      networkConfig.DHCP = "yes";
    };

    nix.settings.experimental-features = ["nix-command" "flakes"];
    nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

    networking.networkmanager.enable = true;

    hardware.graphics.enable = true;

    hardware.nvidia = {
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.FastConnectable = true;
    };

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

    services = {
      xserver = {
        enable = true;
        videoDrivers = ["nvidia"];

        xkb = {
          layout = "us";
          variant = "";
        };

        windowManager = {
          i3 = {
            enable = true;
            extraPackages = with pkgs; [
              dmenu
              i3status
              i3lock
            ];
          };
        };
      };

      displayManager = {
        gdm.enable = true;
        defaultSession = "none+i3";
      };

      desktopManager.gnome.enable = false;
    };

    services.keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = ["*"];
          settings = {
            main = {
              capslock = "overload(control, esc)";
              esc = "capslock";
            };
          };
        };
      };
    };

    location = {
      provider = "manual";
      latitude = 41.72;
      longitude = 44.79;
    };

    services.redshift = {
      enable = true;
      temperature = {
        day = 3000;
        night = 3000;
      };
    };

    services.picom.enable = true;
    services.picom.package = pkgs.picom;

    systemd.user.services.picom.serviceConfig.ExecStart =
      lib.mkForce
      "${pkgs.picom}/bin/picom --config ${pkgs.writeText "picom.conf" (builtins.readFile ../../../configs/picom.conf)}";

    services.logind.settings.Login.HandleLidSwitch = "ignore";

    services.gvfs.enable = true;
    services.udisks2.enable = true;

    services.printing.enable = true;

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    services.flatpak.enable = true;

    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      libGL
      glib
      fontconfig
      libx11
      libxcb
      libxrandr
      libxi
    ];

    programs.steam.enable = true;
    hardware.steam-hardware.enable = true;

    programs.fish.enable = true;

    programs.bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [batdiff batman];
    };

    programs.bash.interactiveShellInit = ''
      if grep -qv fish /proc/$PPID/comm && [[ $SHLVL == 1 ]]; then
      	exec ${pkgs.fish}/bin/fish
      fi
    '';

    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;

    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
      ];
    };

    users.users."lenovo" = {
      isNormalUser = true;
      description = "lenovo";
      extraGroups = ["networkmanager" "wheel" "libvirtd" "kvm"];
      shell = pkgs.fish;
    };

    programs.firefox.enable = true;

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      vim
      git
      discord
      kitty
      fastfetch
      starship
      eza
      nautilus
      kdePackages.kate
      brightnessctl
      wl-clipboard
      ripgrep
      ethtool
      cava
      cmatrix
      nixd
      nodejs
      mpv
      yt-dlp
      rofi
      picom
      keyd
      bat
      alejandra
      polybar
      networkmanagerapplet
      feh
      dunst
      libnotify
      maim
      slop
      xclip
      lxappearance
      deno
      vlc
      htop
    ];

    environment.pathsToLink = ["/share/icons"];

    virtualisation.virtualbox.host.enable = false;
    virtualisation.virtualbox.host.enableExtensionPack = false;

    system.stateVersion = "26.05";
  };
}
