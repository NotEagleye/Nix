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
              extraPackages = [
                pkgs.luau-lsp
                pkgs.selene
                pkgs.rojo
                pkgs.stylua
              ];

              theme = {
                enable = true;
                name = "gruvbox";
                style = "dark";
                transparent = false;
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
              comments.comment-nvim.enable = false;

              extraPlugins = {
                whichpy = {
                  package = pkgs.vimPlugins.whichpy-nvim;
                  setup = "require(\"whichpy\").setup {}";
                };

                nvim-lint = {
                  package = pkgs.vimPlugins.nvim-lint;
                  setup = ''
                    require("lint").linters_by_ft = {
                      luau = { "selene" },
                      lua = { "selene" },
                    }

                    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
                      group = vim.api.nvim_create_augroup("SeleneLinting", { clear = true }),
                      pattern = { "*.luau", "*.lua" },
                      callback = function()
                        require("lint").try_lint()
                      end,
                    })
                  '';
                };

                luau-lsp-nvim = {
                  package = pkgs.vimUtils.buildVimPlugin {
                    name = "luau-lsp.nvim";
                    src = pkgs.fetchFromGitHub {
                      owner = "lopi-py";
                      repo = "luau-lsp.nvim";
                      rev = "main";
                      hash = "sha256-w1QF0PeaDjxp05wpwCkK9DYldYOnhrE1u3h10/2jmSw=";
                    };
                  };
                  setup = ''
                    vim.filetype.add({
                      extension = {
                        lua = "lua",
                        luau = "luau",
                      },
                      pattern = {
                        [".*$.luau"] = "luau",
                      },
                    })

                    vim.schedule(function()
                      require("luau-lsp").setup({
                        platform = { type = "roblox" },
                        sourcemap = { enabled = true, autogenerate = true, rojo_project_file = "default.project.json" },
                        plugin = { enabled = true, port = 3667 },
                        fflags = {
                          enable_new_solver = true,
                          sync = true,
                          override = {
                            LuauSolverV2 = "True",
                          },
                        },
                      })
                    end)
                  '';
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

              formatter = {
                conform-nvim = {
                  enable = true;
                  setupOpts = {
                    formatters_by_ft = {
                      lua = ["stylua"];
                      luau = ["stylua"];
                    };
                  };
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

                lua = {
                  enable = true;
                  format = {
                    enable = true;
                  };
                };
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
                {
                  mode = "n";
                  key = "<C-r>";
                  action = "<cmd>lua vim.lsp.buf.rename()<cr>";
                  desc = "Rename symbol (LSP)";
                }
                {
                  mode = "n";
                  key = "<C-S-k>";
                  action = "<cmd>lua vim.diagnostic.open_float()<cr>";
                  silent = true;
                  desc = "Show line diagnostics";
                }
                {
                  mode = "n";
                  key = "<C-S-l>";
                  action = "<cmd>lsp restart<cr>";
                  silent = true;
                  desc = "Restart LSP";
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
