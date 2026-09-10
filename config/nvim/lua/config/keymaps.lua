local telescope_builtin = require("telescope.builtin")

local keymap = vim.keymap.set

keymap("n", "<C-n>", "<cmd>nohlsearch<cr>", { silent = true, desc = "Disable search highlight" })
keymap("n", "<C-r>", vim.lsp.buf.rename, { desc = "Rename symbol (LSP)" })
keymap("n", "<C-S-k>", vim.diagnostic.open_float, { silent = true, desc = "Show line diagnostics" })

keymap("n", "<C-S-p>", "<cmd>lsp restart<cr>", { desc = "Restart LSP" })

keymap("n", "<leader>e", "<cmd>Ex<cr>", { silent = true, desc = "Open Explorer" })

keymap("n", "<leader>ff", telescope_builtin.find_files, { desc = "Telescope find files" })
keymap("n", "<leader>fg", telescope_builtin.live_grep, { desc = "Telescope live grep" })
keymap("n", "<leader>fb", telescope_builtin.buffers, { desc = "Telescope buffers" })
keymap("n", "<leader>fh", telescope_builtin.help_tags, { desc = "Telescope help tags" })
