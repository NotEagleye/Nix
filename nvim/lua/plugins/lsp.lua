local capabilities = vim.lsp.protocol.make_client_capabilities()
local blink_ok, blink = pcall(require, "blink.cmp")

if blink_ok then
	capabilities = blink.get_lsp_capabilities(capabilities)
end

if nixCats("general") or nixCats("lua") then
	vim.lsp.config.lua_ls = {
		cmd = { "lua-language-server" },
		settings = {
			Lua = {
				diagnostics = { globals = { "vim", "nixCats" } },
				workspace = { checkThirdParty = false },
			},
		},
	}
	vim.lsp.enable("lua_ls")
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
