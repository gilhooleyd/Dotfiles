-- Heavily inspired by https://github.com/nvim-lua/kickstart.nvim/tree/master

vim.opt.mouse ="a"
vim.opt.nu = true

vim.g.mapleader = ','
vim.g.maplocalleader = ','
vim.g.have_nerd_font = true
require("keybindings")

vim.cmd("set updatetime=100")
vim.keymap.set("n", "<C-l>", "<C-W>l")
vim.keymap.set("n", "<C-j>", "<C-W>j")
vim.keymap.set("n", "<C-k>", "<C-W>k")
vim.keymap.set("n", "<C-h>", "<C-W>h")

vim.keymap.set("n", "<C-p>", "<cmd>GFiles<cr>")

vim.opt.wildmenu = true
vim.opt.wildmode = { 'longest', 'list' }
-- vim.lsp.set_log_level("debug")

vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

vim.cmd("map <ScrollWheelUp> <C-Y>")
vim.cmd("map <ScrollWheelDown> <C-E>")

-- Copy and Paste to our "clipboard"
vim.api.nvim_create_autocmd({"TextYankPost"}, {
  callback = function()
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
  { "folke/neodev.nvim", opts = {} },
  "rust-lang/rust.vim",
  "junegunn/fzf.vim",
  "junegunn/fzf",
  'tpope/vim-sensible',
  'tpope/vim-unimpaired',
  'tpope/vim-dispatch',
  'tpope/vim-fugitive',
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        triggers = {
          { "<leader>", mode = { "n", "v" } },
          { "g", mode = { "n", "v" } },
          { "]", mode = { "n", "v" } },
          { "[", mode = { "n", "v" } },
        },

        -- Document existing key chains
        spec = {
          { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
          { '<leader>d', group = '[D]ocument' },
          { '<leader>r', group = '[R]ename' },
          { '<leader>s', group = '[S]earch' },
          { '<leader>w', group = '[W]orkspace' },
          { '<leader>t', group = '[T]oggle' },
          { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        },
      },
    },
  },
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        local output = vim.fn.system { 'cat', '/usr/local/google/home/dgilhooley/fuchsia/.fx-build-dir' }
        return output:sub(1, -2)
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
  require('plugins.telescope'),
  require('plugins.gitsigns'),
  require('plugins.lsp'),
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = { 'bash', 'c', 'gn', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },
  require('plugins.cmp'),
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      local toggleterm = require('toggleterm')
      toggleterm.setup()
    end,
  },
  {
    'MagicDuck/grug-far.nvim',
    config = function()
      -- optional setup call to override plugin options
      -- alternatively you can set options with vim.g.grug_far = { ... }
      require('grug-far').setup {
        -- options, see Configuration section below
        -- there are no required options atm
        -- engine = 'ripgrep' is default, but 'astgrep' or 'astgrep-rules' can
        -- be specified
      }
    end,
  },
  'pteroctopus/faster.nvim',
})

vim.cmd(":highlight Comment ctermfg=darkblue")
vim.cmd("highlight TabLineSel ctermfg=15 ctermbg=0 cterm=Bold,None")
vim.cmd("highlight TabLine ctermfg=4 ctermbg=0")
vim.cmd("highlight TabLineFill cterm=Bold,None ctermfg=15 ctermbg=4")
vim.cmd(":highlight LineNr ctermfg=12")
vim.cmd(":highlight ColorColumn ctermfg=darkgray")
vim.cmd(":set notermguicolors")
