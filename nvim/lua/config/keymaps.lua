-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Move text up and down
keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)

keymap.set("v", "y", '"+y', { noremap = true })

-- Oil plugin
keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open Oil" })

keymap.set("n", "4", "$")

keymap.set("n", "<leader>ff", ":lua Snacks.dashboard.pick('files')<CR>", { desc = "Find files" })
keymap.set("n", "<leader>fg", ":lua Snacks.dashboard.pick('grep')<CR>", { desc = "Grep" })

-- Ir a la definition de una funcion o algo
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true })
