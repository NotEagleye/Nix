{self, inputs, ...}: {
	flake.nixosModules.Nixcats-nvim = {pkgs, ...}: {
		environment.systemPackages = [
			self.packages.${pkgs.stdenv.hostPlatform.system}.Nixcats-nvim
		];
	};

	perSystem = {pkgs, system, lib, ...}: {
		packages.Nixcats-nvim = let
			luaPath = self + "/config/nvim";

			nixCatsBuilder = inputs.nixCats.utils.baseBuilder luaPath {
				inherit system;
				nixpkgs = inputs.nixpkgs;
			};

			luau-lsp-nvim = pkgs.vimUtils.buildVimPlugin {
				name = "luau-lsp.nvim";
				src = pkgs.fetchFromGitHub {
					owner = "lopi-py";
					repo = "luau-lsp.nvim";
					rev = "main";
					hash = "sha256-9ZtaZuBCbJkvbI/YM+LmhyNmQ+kH4LipD1TIOQIhfNo=";
				};
			};

			categoryDefinitions = { pkgs, settings, categories, name, ... }@packageDef: {
				lspsAndRuntimeDeps = {
					general = with pkgs; [
						wl-clipboard
						xclip
						ripgrep
						fd

						lua-language-server
					];

          nix = with pkgs; [
            nixd
          ];

					qml = with pkgs; [
					  kdePackages.qtdeclarative
					];

					luau = with pkgs; [
						luau-lsp
						stylua
						selene
						rojo
					];

					c = with pkgs; [
						clang-tools
					];
				};

				startupPlugins = {
					general = with pkgs.vimPlugins; [
						nvim-lspconfig
						nvim-lint
						conform-nvim
						lualine-nvim
						telescope-nvim
						catppuccin-nvim
						blink-cmp
						nvim-autopairs
						harpoon2

						(nvim-treesitter.withPlugins (plugins: with plugins; [
						  lua
						  luau
						  c
						  nix
						  vim
						  vimdoc
						  bash
						  markdown
						  markdown_inline
						  qmljs
						]))
					];
					luau = [
						luau-lsp-nvim
					];
				};
			};
			
			packageDefinitions = {
				nvim = { pkgs, ... }: {
					settings = {
						wrapRc = true;
						aliases = ["vim" "vi"];
					};
					categories = {
						general = true;
            nix = true;
						luau = true;
						c = true;
						qml = true;
					};
				};
			};
		in
			nixCatsBuilder categoryDefinitions packageDefinitions "nvim";
	};
}
