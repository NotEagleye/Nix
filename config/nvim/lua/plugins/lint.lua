if nixCats("luau") then
	require("lint").linters_by_ft = {
		luau = { "selene" },
	}

	vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
		group = vim.api.nvim_create_augroup("SeleneLinting", { clear = true }),
		pattern = { "*.luau" },
		callback = function()
			require("lint").try_lint()
		end,
	})
end
