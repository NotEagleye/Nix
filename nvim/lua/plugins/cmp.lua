local status_ok, blink = pcall(require, "blink.cmp")

if not status_ok then
	return
end

blink.setup({
	keymap = {
		preset = "default",
		["<S-CR>"] = { "select_and_accept", "fallback" },
	},

	appearance = {
		use_nvim_cmp_as_default = true,
		nerd_font_variant = "mono",
	},

	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},

	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
		},
	},
})
