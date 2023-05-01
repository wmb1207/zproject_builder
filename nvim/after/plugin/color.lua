-- vim.opt.background = "none"
vim.o.termguicolors = true

require("tokyonight").setup({
	style = "moon",
	transparent = true,
})

vim.cmd("colorscheme tokyonight")
-- vim.cmd("hi Normal guibg=NONE ctermbg=NONE")

