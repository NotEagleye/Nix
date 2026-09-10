{ self, inputs, ... }: {

  flake.nixosModules.HomeManager = { ... }: {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.backupFileExtension = "bak";

    home-manager.users.lenovo =
    let
      Dotfiles = self + "/dotfiles";
      
      Config = Dotfiles + "/config/";
      Scripts = Dotfiles + "/scripts/";
      Assets = Dotfiles + "/assets/";
    in
    { pkgs, lib, ... }: {
      home.stateVersion = "26.05";

      xdg.configFile = {
        "dunst".source         = Config + "dunst";
        "fastfetch".source     = Config + "fastfetch";
        "picom.conf".source    = Config + "picom.conf";
        "polybar".source       = Config + "polybar";
        "rofi".source          = Config + "rofi";
        "starship.toml".source = Config + "starship.toml";
      };

      home.file.".config/i3/scripts" = {
        source = Scripts + "i3";
        recursive = true;
        executable = true;
      };

      xsession.windowManager.i3 =
      let
        Wallpaper = Assets + "Wallpapers/NixOSMocha.png";
      in
      {
          enable = true;

          config =
            let
              Modifier = "Mod4";
            in
            {
              modifier = Modifier;
              bars = [];

              fonts = {
                names = [ "JetBrainsMono Nerd" ];
                size = 10.0;
              };

              gaps = {
                inner = 4;
                outer = 4;
              };

              floating = {
                border = 2;
                titlebar = false;

                modifier = Modifier;
                criteria = [
                  { instance = "filemanager"; }
                ];
              };

              window = {
                border = 2;
                titlebar = false;

                commands = [
                  {
                    command = "floating enable, resize set 1000 650, move position center";
                    criteria = { instance = "filemanager"; };
                  }
                ];
              };

              colors = {
                focused = {
                  border = "#89b4fa";
                  background = "#89b4fa";
                  text = "#11111b";
                  indicator = "#b4bfea";
                  childBorder = "#89b4fa";
                };
                focusedInactive = {
                  border = "#313244";
                  background = "#313244";
                  text = "#cdd6f4";
                  indicator = "#45475a";
                  childBorder = "#313244";
                };
                unfocused = {
                  border = "#1e1e2e";
                  background = "#1e1e2e";
                  text = "#6c7086";
                  indicator = "#313244";
                  childBorder = "#1e1e2e";
                };
              };

              keybindings = lib.mkOptionDefault {
                "${Modifier}+Return" = "exec ${pkgs.kitty}/bin/kitty";
                "${Modifier}+e" = "exec --no-startup-id ${pkgs.kitty}/bin/kitty --name filemanager -e ${pkgs.yazi}/bin/yazi";
                "${Modifier}+r" = "exec \"rofi -modi drun,run -show drun\"";
                "${Modifier}+b" = "exec --no-startup-id helium";

                "Print" = "exec --no-startup-id ${pkgs.maim}/bin/maim -s | ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png";
                "Control+Print" = "exec --no-startup-id ${pkgs.maim}/bin/maim | ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png";

                "${Modifier}+q" = "kill";
                "${Modifier}+f" = "fullscreen toggle";
                "${Modifier}+s" = "layout toggle split";
                "${Modifier}+t" = "floating toggle";
                "${Modifier}+space" = "focus mode_toggle";
                "${Modifier}+a" = "focus parent";

                "${Modifier}+h" = "focus left";
                "${Modifier}+j" = "focus down";
                "${Modifier}+k" = "focus up";
                "${Modifier}+l" = "focus right";
                "${Modifier}+Left" = "focus left";
                "${Modifier}+Down" = "focus down";
                "${Modifier}+Up" = "focus up";
                "${Modifier}+Right" = "focus right";

                "${Modifier}+Control+h" = "move left";
                "${Modifier}+Control+j" = "move down";
                "${Modifier}+Control+k" = "move up";
                "${Modifier}+Control+l" = "move right";
                "${Modifier}+Control+Left" = "move left";
                "${Modifier}+Control+Down" = "move down";
                "${Modifier}+Control+Up" = "move up";
                "${Modifier}+Control+Right" = "move right";

                "${Modifier}+Shift+h" = "split h";
                "${Modifier}+Shift+v" = "split v";

                "${Modifier}+Shift+c" = "reload";
                "${Modifier}+Shift+r" = "restart";
                "${Modifier}+Shift+e" = "exec i3-msg exit";

                "${Modifier}+equal" = "resize grow width 50 px";
                "${Modifier}+minus" = "resize shrink width 50 px";
                "${Modifier}+Shift+equal" = "resize grow height 50 px";
                "${Modifier}+Shift+minus" = "resize shrink height 50 px";

                "XF86AudioRaiseVolume" = "exec --no-startup-id ~/.config/i3/scripts/media_control.sh vol_up";
                "XF86AudioLowerVolume" = "exec --no-startup-id ~/.config/i3/scripts/media_control.sh vol_down";
                "XF86AudioMute" = "exec --no-startup-id ~/.config/i3/scripts/media_control.sh vol_mute";
                "XF86AudioMicMute" = "exec --no-startup-id ~/.config/i3/scripts/media_control.sh mic_mute";
                "XF86AudioPrev" = "exec --no-startup-id ~/.config/i3/scripts/media_control.sh mic_mute";
                "XF86MonBrightnessUp" = "exec --no-startup-id ~/.config/i3/scripts/media_control.sh bri_up";
                "XF86MonBrightnessDown" = "exec --no-startup-id ~/.config/i3/scripts/media_control.sh bri_down";
                "XF86AudioStop" = "exec --no-startup-id ~/.config/i3/scripts/media_control.sh bri_up";
                "XF86AudioPlay" = "exec --no-startup-id ~/.config/i3/scripts/media_control.sh bri_down";
              };

              startup = [
                { command = "xrandr --output DP-2 --mode 1920x1080 --rate 144.00 --scale 1 --dpi 96"; notification = false; }
                { command = "xsct 3500"; notification = false; }
                { command = "${pkgs.networkmanagerapplet}/bin/nm-applet"; notification = false; }
                { command = "${pkgs.dunst}/bin/dunst"; notification = false; }
                { command = "${pkgs.feh}/bin/feh --bg-fill ${Wallpaper}"; always = true; notification = false; }

                { command = "~/.config/i3/scripts/picom.sh"; always = true; notification = false; }
                { command = "~/.config/i3/scripts/polybar.sh"; always = true; notification = false; }
              ];
            };
        };

      programs.kitty = {
        enable = true;

        font = {
          name = "Cascadia Code";
          size = 11.0;
        };
        
        settings = {
          shell = "zsh -c \"fastfetch; exec zsh\"";
          shell_integration = "enabled";
          linux_display_server = "x11";
          confirm_os_window_close = 0;
          enable_audio_bell = "no";
          mouse_hide_wait = -1;

          background_opacity = "0.8";
          dynamic_background_opacity = "yes";
          cursor_shape = "block";
          enabled_layouts = "tall";
          window_border_width = "1pt";

          tab_bar_style = "powerline";
          tab_powerline_style = "slanted";
          tab_bar_edge = "bottom";
          tab_bar_align = "left";
          active_tab_font_style = "bold";
          inactive_tab_font_style = "normal";

          foreground = "#CDD6F4";
          background = "#1E1E2E";
          selection_foreground = "#1E1E2E";
          selection_background = "#F5E0DC";

          cursor = "#F5E0DC";
          cursor_text_color = "#1E1E2E";

          url_color = "#F5E0DC";

          active_border_color = "#44ffff"; 
          inactive_border_color = "#6C7086";
          bell_border_color = "#F9E2AF";

          wayland_titlebar_color = "system";
          macos_titlebar_color = "system";

          active_tab_foreground = "#11111B";
          active_tab_background = "#CBA6F7";
          inactive_tab_foreground = "#CDD6F4";
          inactive_tab_background = "#181825";
          tab_bar_background = "#11111B";

          mark1_foreground = "#1E1E2E";
          mark1_background = "#B4BEFE";
          mark2_foreground = "#1E1E2E";
          mark2_background = "#CBA6F7";
          mark3_foreground = "#1E1E2E";
          mark3_background = "#74C7EC";

          color0 = "#45475A";
          color8 = "#585B70";
          color1 = "#F38BA8";
          color9 = "#F38BA8";
          color2 = "#A6E3A1";
          color10 = "#A6E3A1";
          color3 = "#F9E2AF";
          color11 = "#F9E2AF";
          color4 = "#89B4FA";
          color12 = "#89B4FA";
          color5 = "#F5C2E7";
          color13 = "#F5C2E7";
          color6 = "#94E2D5";
          color14 = "#94E2D5";
          color7 = "#BAC2DE";
          color15 = "#A6ADC8";
        };
      };
    };
  };

}
