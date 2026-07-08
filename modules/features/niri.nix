{ self, inputs, ... }: {
	
	flake.nixosModules.niri = { pkgs, lib, ... }: {
		programs.niri = {
			enable = true;
			package = self.packages.${pkgs.stdenv.hostPlatform.system}.Niri;
		};
	};

	perSystem = { pkgs, lib, config, self', ... }: {
		packages.Niri = inputs.wrapper-modules.wrappers.niri.wrap {
			inherit pkgs;
			settings = let
				noctaliaExe = lib.getExe self'.packages.Noctalia;
			in {
				prefer-no-csd = true;

				outputs = {
					"eDP-1" = {
						mode = "1920x1080@144.003";
						scale = 1.0;
					};
				};

				spawn-at-startup = [
					(lib.getExe self'.packages.Noctalia)
				];

				xwayland-satellite.path = 
					lib.getExe pkgs.xwayland-satellite;

				cursor = {
					xcursor-theme = "Adwaita";
					xcursor-size = 12;
				};

				input = {
					keyboard = {
						xkb.layout = "us,ua";
					};
					focus-follows-mouse = {};
					workspace-auto-back-and-forth = {};
				};

				layout = {
					gaps = 8;
					center-focused-column = "never";

					background-color = "transparent";

					struts = {};

					border.off = {};
					focus-ring = {
						on = {};

						width = 2;
					};

					preset-column-widths = [
						{ proportion = 0.33333; }
						{ proportion = 0.5; }
						{ proportion = 0.66667; }
					];
				};

				window-rules = [
					{
						geometry-corner-radius = 20;
						clip-to-geometry = true; 
					}
					{
						matches = [{ app-id = "kitty"; }];
						draw-border-with-background = false;
					}
				];

				binds = {
					"Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
					"Mod+R".spawn-sh = "${noctaliaExe} ipc call launcher toggle";
					"Mod+B".spawn = lib.getExe pkgs.brave;
					"Mod+ALT+L".spawn-sh = "${noctaliaExe} ipc call lockScreen lock";
					"Mod+Shift+Q".spawn-sh = "${noctaliaExe} ipc call sessionMenu toggle";

					"Mod+E".spawn = lib.getExe pkgs.nautilus;

					"XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+";
					"XF86AudioLowerVolume".spawn-sh = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-";
					"XF86AudioMute".spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
					"XF86AudioMicMute".spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
					"XF86MonBrightnessUp".spawn-sh = "brightnessctl set +5%";
					"XF86MonBrightnessDown".spawn-sh = "brightnessctl set 5%-";

					"Mod+Q".close-window = {};

					"Mod+Left".focus-column-left = {};
					"Mod+H".focus-column-left = {};
					"Mod+Right".focus-column-right = {};
					"Mod+L".focus-column-right = {};
					"Mod+Up".focus-window-up = {};
					"Mod+K".focus-window-up = {};
					"Mod+Down".focus-window-down = {};
					"Mod+J".focus-window-down = {};

					"Mod+CTRL+Left".move-column-left = {};
					"Mod+CTRL+H".move-column-left = {};
					"Mod+CTRL+Right".move-column-right = {};
					"Mod+CTRL+L".move-column-right = {};
					"Mod+CTRL+Up".move-window-up = {};
					"Mod+CTRL+K".move-window-up = {};
					"Mod+CTRL+Down".move-window-down = {};
					"Mod+CTRL+J".move-window-down = {};

					"Mod+Home".focus-column-first = {};
					"Mod+End".focus-column-last = {};
					"Mod+CTRL+Home".move-column-to-first = {};
					"Mod+CTRL+End".move-column-to-last = {};

					"Mod+WheelScrollDown" = {
						focus-workspace-down = {};
					};
					"Mod+WheelScrollUp" = {
						focus-workspace-up = {};
					};
					"Mod+CTRL+WheelScrollUp" = {
						move-column-to-workspace-up = {};
					};
					"Mod+CTRL+WheelScrollDown" = {
						move-column-to-workspace-down = {};
					};

					"Mod+1".focus-workspace = 1;
					"Mod+2".focus-workspace = 2;
					"Mod+3".focus-workspace = 3;
					"Mod+4".focus-workspace = 4;
					"Mod+5".focus-workspace = 5;
					"Mod+6".focus-workspace = 6;
					"Mod+7".focus-workspace = 7;
					"Mod+8".focus-workspace = 8;
					"Mod+9".focus-workspace = 9;

					"Mod+CTRL+1".move-column-to-workspace = 1;
					"Mod+CTRL+2".move-column-to-workspace = 2;
					"Mod+CTRL+3".move-column-to-workspace = 3;
					"Mod+CTRL+4".move-column-to-workspace = 4;
					"Mod+CTRL+5".move-column-to-workspace = 5;
					"Mod+CTRL+6".move-column-to-workspace = 6;
					"Mod+CTRL+7".move-column-to-workspace = 7;
					"Mod+CTRL+8".move-column-to-workspace = 8;
					"Mod+CTRL+9".move-column-to-workspace = 9;

					"Mod+TAB".focus-workspace-previous = {};

					"Mod+CTRL+F".expand-column-to-available-width = {};
					"Mod+C".center-column = {};
					"Mod+CTRL+C".center-visible-columns = {};
					"Mod+Minus".set-column-width = "-10%";
					"Mod+Equal".set-column-width = "+10%";
					"Mod+Shift+Minus".set-window-height = "-10%";
					"Mod+Shift+Equal".set-window-height = "+10%";

					"Mod+T".toggle-window-floating = {};
					"Mod+F".fullscreen-window = {};
					"Mod+W".toggle-column-tabbed-display = {};

					"CTRL+Shift+1".screenshot = {};
					"CTRL+Shift+2".screenshot-screen = {};
					"CTRL+Shift+3".screenshot-window = {};

					"Mod+ESCAPE" = _: {
						props.allow-inhibiting = false;
						content.toggle-keyboard-shortcuts-inhibit = _: {};
					};

					"CTRL+ALT+Delete".quit = {};
					"Mod+Shift+P".power-off-monitors = {};
					"Mod+O" = {
						toggle-overview = {};
					};
				};
			};
		};
	};
}
