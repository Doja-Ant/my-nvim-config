vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2
vim.g.mapleader = " "
vim.o.clipboard = "unnamedplus"

require("config.keymaps")
require("config.lazy")

vim.cmd([[colorscheme tokyonight]])
