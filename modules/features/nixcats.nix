{self, inputs, ...}: {
	flake.nixosModules.nixcats-nvim = {pkgs, ...}: {
		environment.systemPackages = [
			self.packages.${pkgs.stdenv.hostPlatform.system}.nixcats-nvim
		];
	};

	perSystem = {pkgs, system, lib, ...}: {
		packages.nixcats-nvim = let
			luaPath = self + "/nvim";

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
					hash = "sha256-w1QF0PeaDjxp05wpwCkK9DYldYOnhrE1u3h10/2jmSw=";
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

					luau = with pkgs; [
						luau-lsp
						stylua
						selene
						rojo
					];
				};

				startupPlugins = {
					general = with pkgs.vimPlugins; [
						nvim-lspconfig
						nvim-lint
						conform-nvim
						lualine-nvim
            telescope-nvim
            nord-nvim
            blink-cmp
            nvim-autopairs
            harpoon2

            (nvim-treesitter.withPlugins (plugins: with plugins; [
              lua
              luau
              nix
              vim
              vimdoc
              bash
              markdown
              markdown_inline
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
						luau = true;
					};
				};
			};
		in
			nixCatsBuilder categoryDefinitions packageDefinitions "nvim";
	};
}
