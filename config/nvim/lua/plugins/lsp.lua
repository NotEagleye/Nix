local capabilities = vim.lsp.protocol.make_client_capabilities()
local blink_ok, blink = pcall(require, "blink.cmp")

if blink_ok then
	capabilities = blink.get_lsp_capabilities(capabilities)
end

if nixCats("general") or nixCats("lua") then
	vim.lsp.config.lua_ls = {
		cmd = { "lua-language-server" },
		capabilities = capabilities,
		settings = {
			Lua = {
				diagnostics = { globals = { "vim", "nixCats" } },
				workspace = { checkThirdParty = false },
			},
		},
	}
	vim.lsp.enable("lua_ls")
end

if nixCats("nix") then
	vim.lsp.config.nixd = {
		cmd = { "nixd" },
		capabilities = capabilities,
		settings = {
			nixd = {
				nixpkgs = {
					expr = "import <nixpkgs> { }",
				},
				options = {
					nixos = {
						expr = '(builtins.getFlake "/etc/nixos").nixosConfigurations.Lenovo.options',
					},
				},
			},
		},
	}
	vim.lsp.enable("nixd")
end

if nixCats("c") then
	vim.lsp.config.clangd = {
		cmd = { "clangd" },
		capabilities = capabilities,
	}
	vim.lsp.enable("clangd")
end

if nixCats("qml") then
	vim.lsp.config.qmlls = {
		cmd = {
			"qmlls",
			"-I",
			"/run/current-system/sw/lib/qt-6/qml",
		},
		capabilities = capabilities,
		filetypes = { "qml" },
		on_attach = function(client)
			client.server_capabilities.semanticTokensProvider = nil
		end,
	}
	vim.lsp.enable("qmlls")
end

if nixCats("luau") then
	vim.filetype.add({
		extension = { luau = "luau" },
	})

	vim.schedule(function()
		require("luau-lsp").setup({
			platform = { type = "roblox" },
			sourcemap = {
				enabled = true,
				autogenerate = true,
				rojo_project_file = "default.project.json",
			},
			plugin = { enabled = true, port = 3667 },
			fflags = {
				enable_new_solver = true,
				sync = true,
				override = { LuauSolverV2 = "True" },
			},
		})
	end)
end
