local status_ok, harpoon = pcall(require, "harpoon")

if not status_ok then
	return
end

harpoon:setup()

local keymap = vim.keymap.set

keymap("n", "<leader>a", function()
	harpoon:list():add()
end, { desc = "Harpoon Add File" })
keymap("n", "<C-e>", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon Quick Menu" })

keymap("n", "<leader>h", function()
	harpoon:list():select(1)
end, { desc = "Harpoon File 1" })
keymap("n", "<leader>j", function()
	harpoon:list():select(2)
end, { desc = "Harpoon File 2" })
keymap("n", "<leader>k", function()
	harpoon:list():select(3)
end, { desc = "Harpoon File 3" })
keymap("n", "<leader>l", function()
	harpoon:list():select(4)
end, { desc = "Harpoon File 4" })
