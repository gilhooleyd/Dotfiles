vim.opt.mouse ="a"
vim.opt.nu = true

vim.g.mapleader = ','
vim.g.maplocalleader = ','
require("keybindings")

vim.cmd("set updatetime=100")
vim.keymap.set("n", "<C-l>", "<C-W>l")
vim.keymap.set("n", "<C-j>", "<C-W>j")
vim.keymap.set("n", "<C-k>", "<C-W>k")
vim.keymap.set("n", "<C-h>", "<C-W>h")

vim.keymap.set("n", "<C-p>", "<cmd>GFiles<cr>")

vim.opt.wildmenu = true
vim.opt.wildmode = { 'longest', 'list' }
vim.lsp.set_log_level("debug")

vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

vim.cmd("map <ScrollWheelUp> <C-Y>")
vim.cmd("map <ScrollWheelDown> <C-E>")

-- Copy and Paste to our "clipboard"
vim.api.nvim_create_autocmd({"TextYankPost"}, {
  callback = function(args)
    if vim.v.event.regname == "" then
      -- We use vim.cmd here because system sets STDIN.
      vim.cmd('call system("nc localhost 8001", v:event.regcontents)')
    end
  end,
})

-- Deleting goes into the blackhole clipboard.
vim.keymap.set("n", "d", "\"_d", {noremap=true});
vim.keymap.set("n", "D", "\"_D", {noremap=true});
vim.keymap.set("v", "d", "\"_d", {noremap=true});
vim.keymap.set("v", "D", "\"_D", {noremap=true});

-- PowerLine
vim.g.airline_powerline_fonts = "1"
vim.cmd("let g:airline#extensions#tabline#enabled = 1")


vim.g.airline_section_x = ""
vim.g.airline_section_y = ""
vim.g.airline_section_z = ""

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins!
require("lazy").setup({
  "neovim/nvim-lspconfig",
  { "folke/neodev.nvim", opts = {} },
  'vim-airline/vim-airline',
  'vim-airline/vim-airline-themes',
  "rust-lang/rust.vim",
  "junegunn/fzf.vim",
  "junegunn/fzf",
  'airblade/vim-gitgutter',
  'tpope/vim-sensible',
  'tpope/vim-unimpaired',
  'tpope/vim-dispatch',
  'tpope/vim-fugitive',
  'nvim-treesitter/nvim-treesitter',
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
--    dependencies = { 'nvim-lur/plenary.nvim' },
  },
  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},

})

-- Colorscheme
-- vim.cmd("colorscheme nord")
--
vim.cmd(":highlight LineNr ctermfg=yellow")
vim.cmd(":highlight ColorColumn ctermfg=darkgray")

vim.cmd(":highlight Comment ctermfg=darkblue")
vim.cmd("highlight TabLineSel ctermfg=15 ctermbg=0 cterm=Bold,None")
vim.cmd("highlight TabLine ctermfg=4 ctermbg=0")
vim.cmd("highlight TabLineFill cterm=Bold,None ctermfg=15 ctermbg=4")
vim.cmd("AirlineTheme bubblegum")

--Setup language servers.
local lspconfig = require('lspconfig')
lspconfig.clangd.setup {
}
-- Server-specific settings. See `:help lspconfig-setup`
lspconfig.rust_analyzer.setup {
  cmd = {"/usr/local/google/home/dgilhooley/fuchsia/prebuilt/third_party/rust/linux-x64/bin/rust-analyzer"},
  settings = {
    ['rust-analyzer'] = {},
  },
}
lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace"
      }
    }
  }
})
lspconfig.ts_ls.setup{}
