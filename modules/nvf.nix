{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.nvf = {pkgs, ...}: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.neovim
      pkgs.basedpyright
    ];
  };

  perSystem = {
    pkgs,
    lib,
    ...
  }: {
    packages.neovim =
      (inputs.nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [
          {
            vim = {
              theme = {
                enable = true;
                name = "gruvbox";
                style = "dark";
              };

              statusline = {
                lualine = {
                  enable = true;
                };
              };

              opts = {
                tabstop = 2;
                shiftwidth = 2;
                softtabstop = 2;

                indentexpr = "v:lua.vim.treesitter.indent()";

                autoindent = false;
                smartindent = false;
                expandtab = true;
              };

              telescope.enable = true;
              autocomplete.blink-cmp.enable = true;

              filetree.neo-tree.enable = true;
              tabline.nvimBufferline.enable = true;
              autopairs.nvim-autopairs.enable = true;

              presence.neocord.enable = true;
              snippets.luasnip.enable = true;
              notify.nvim-notify.enable = true;
              comments.comment-nvim.enable = true;

              extraPlugins = {
                whichpy = {
                  package = pkgs.vimPlugins.whichpy-nvim;
                  setup = "require(\"whichpy\").setup {}";
                };
              };

              lsp = {
                enable = true;

                formatOnSave = true;
                trouble.enable = true;

                servers = {
                  basedpyright.cmd = lib.mkForce ["basedpyright-langserver" "--stdio"];
                };
              };

              languages = {
                enableTreesitter = true;
                enableFormat = true;

                markdown.enable = true;

                nix = {
                  enable = true;
                  format = {
                    enable = true;
                    type = ["alejandra"];
                  };
                };

                python = {
                  enable = true;

                  lsp = {
                    enable = true;
                    servers = ["basedpyright"];
                  };
                };

                lua.enable = true;
              };

              keymaps = [
                {
                  mode = "n";
                  key = "<C-w>";
                  action = "<cmd>Neotree toggle reveal<cr>";
                  silent = true;
                  desc = "Toggle Neo-tree";
                }
                {
                  mode = "n";
                  key = "<C-n>";
                  action = "<cmd>nohlsearch<cr>";
                  silent = true;
                  desc = "Disable search highlight";
                }
              ];

              visuals = {
                cinnamon-nvim.enable = true;
                fidget-nvim.enable = true;
                nvim-web-devicons.enable = true;
                nvim-cursorline.enable = true;

                blink-indent.enable = true;
              };

              binds = {
                whichKey.enable = true;
                cheatsheet.enable = true;
              };

              git = {
                enable = true;
                gitsigns.enable = false;
                neogit.enable = true;
              };

              utility = {
                diffview-nvim.enable = true;
                multicursors.enable = true;

                motion = {
                  hop.enable = true;
                  leap.enable = true;
                };
              };

              ui = {
                borders.enable = true;
                noice.enable = true;
                colorizer.enable = true;
                illuminate.enable = true;
              };
            };
          }
        ];
      }).neovim;
  };
}
