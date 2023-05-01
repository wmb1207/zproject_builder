local nnoremap = require("wmb.keymap").nnoremap
local nmap = require("wmb.keymap").nmap
local vnoremap = require("wmb.keymap").vnoremap

vnoremap("<leader>y", "\"+y")
nnoremap("<leader>Y", "\"+yg_")
nnoremap("<leader>y", "\"+y")
nnoremap("<leader>yy", "\"+yy")

nnoremap("<leader>p", "\"+p")
nnoremap("<leader>P", "\"+P")
vnoremap("<leader>p", "\"+p")
vnoremap("<leader>P", "\"+P")

nnoremap("<leader><space>", "<cmd>FZF<CR>")
nnoremap("<leader>pv", "<cmd>Ex<CR>")
-- tnoremap <C-q> <C-\><C-n>
nnoremap("<leader>", "za")
nnoremap("<leader>op", "<cmd> NvimTreeToggle<CR>")
nnoremap("<C-J>", "<C-W><C-J>")
nnoremap("<C-K>", "<C-W><C-K>")
nnoremap("<C-L>", "<C-W><C-L>")
nnoremap("<C-H>", "<C-W><C-H>")
nnoremap("<C-U>", "11kzz")
nnoremap("<C-D>", "11jzz")
nnoremap("j", "jzz")
nnoremap("k", "kzz")
nnoremap("#", "#zz")
nnoremap("*", "*zz")
nnoremap("n", "nzz")
nnoremap("N", "Nzz")
nnoremap("gg", "ggzz")
nnoremap("G","Gzz")
nnoremap("gj" ,"gjzz")
nnoremap("gk" ,"gkzz")
nnoremap("<leader>tn" ,"<cmd>tabnew<CR>")
nnoremap("<leader>tk" ,"<cmd>tabnext<CR>")
nnoremap("<leader>tj" ,"<cmd>tabprev<CR>")
nnoremap("<leader>th" ,"<cmd>tabfirst<CR>")
nnoremap("<leader>tl" ,"<cmd>tablast<CR>")
nnoremap("<leader>so" ,"<cmd>so %<CR>")
-- "GoVim custom keybindings")
nnoremap(",<space>", "<cmd>GOVIMQuickfixDiagnostics<CR>")
nnoremap(".<space>", "<cmd>GOVIMSuggestedFixes<CR>")
nnoremap(".d", "<cmd>GOVIMGoToDef<CR>")
nnoremap(".D", "<cmd>GOVIMGoToPrevDef<CR>")
nnoremap(".i", "<cmd>GOVIMImplements<CR>")
nnoremap("<leader>b", "<cmd>Buffers<CR>")
nnoremap("<leader>gf", "<cmd>GFiles?<CR>")
nnoremap("<leader>w", "<cmd>Windows<CR>")
nnoremap("<leader>blk", "<cmd>!black %<CR>")
nnoremap("<leader>rfmt", "<cmd>!rustfmt %<CR>")

nnoremap("<Left>","<cmd>vertical resize -5<CR>")
nnoremap("<Right>", "<cmd>vertical resize +5<CR>")
nnoremap("<Down>", "<cmd>resize -5<CR>")
nnoremap("<Up>", "<cmd>resize +5<CR>")

nmap("<space>t", "<cmd>TagbarToggle<CR>")
nmap("<space>pf", "<cmd>NERDTreeToggle<CR>")
nmap("<space>*", "<cmd>Rg<CR>")
nmap("<Leader>f", "<cmd>Vexplore!<CR>")