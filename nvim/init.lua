-- Heavily inspired by https://github.com/nvim-lua/kickstart.nvim/tree/master

vim.g.have_nerd_font = true
vim.g.mapleader = ','
vim.g.maplocalleader = ','
vim.opt.clipboard = "unnamedplus"
vim.opt.colorcolumn="100"
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.mouse ="a"
vim.opt.shiftwidth = 2
vim.opt.showmode = false
vim.opt.showtabline = 2
vim.opt.smartcase = true
vim.opt.smarttab = true
vim.opt.tabstop = 2
vim.opt.wildmenu = true
vim.opt.wildmode = { 'longest', 'list' }

vim.cmd(":highlight Comment ctermfg=darkblue")
vim.cmd("highlight TabLineSel ctermfg=15 ctermbg=0 cterm=Bold,None")
vim.cmd("highlight TabLine ctermfg=4 ctermbg=0")
vim.cmd("highlight TabLineFill cterm=Bold,None ctermfg=15 ctermbg=4")
vim.cmd(":highlight LineNr ctermfg=12")
vim.cmd(":highlight ColorColumn ctermfg=darkgray")
vim.cmd(":set notermguicolors")

local map = function(mode, keys, func, desc)
  vim.keymap.set(mode, keys, func, {desc = desc })
end

local function yank_to_clipboard(text)
  vim.cmd('call system("nc localhost 8001", "'..text..'")')
end

local function get_buf_name()
  return string.gsub(vim.api.nvim_buf_get_name(0), vim.fn.getcwd().."/", "")
end

Run_cmd = "fx build"
map("n", '<leader>rs', ":lua Run_cmd='", '[R]un [S]etup')
map("n", "<Leader>rr", function()
  vim.fn.system("tmux send-keys -t {down-of} C-c \" " .. Run_cmd .. "\" Enter")
end, "[R]un [R]ecent")

map("n", "<Leader>sb", "<cmd>Buffer<cr>", "[S]earch [B]uffer")

function getUrl(git_remote, upstream_branch, file, linenum)
  local no_sso = string.sub(git_remote, 7)
  local first_slash = string.find(no_sso, "/")
  local project = string.sub(no_sso, 0, first_slash - 1)
  local repo = string.sub(no_sso, first_slash + 1)
  return project .. ".googlesource.com/" .. repo .. "/+/refs/heads/" .. upstream_branch .. file .. "#" .. linenum
end

function GetGitRelativePath()
  local current_file = vim.api.nvim_buf_get_name(0)
  if current_file == "" then
    return nil
  end

  local git_toplevel_command = string.format('git -C "%s" rev-parse --show-toplevel', vim.fn.expand('%:p:h'))
  local git_toplevel = vim.fn.systemlist(git_toplevel_command)[1]
  if vim.v.shell_error ~= 0 or not git_toplevel then
    return nil
  end
  git_toplevel = string.gsub(git_toplevel, "\n", "")

  local relative_path = vim.fs.normalize(string.sub(current_file, #git_toplevel + 1))
  return relative_path
end

map("n", "<Leader>cf", function()
  local remote_name = 'origin'

  local filepath = vim.api.nvim_buf_get_name(0)
  if filepath == '' then
    vim.notify("Current buffer has no associated file", vim.log.levels.WARN)
    return nil
  end

  -- Get the directory containing the file
  -- Use vim.fn.fnamemodify to handle potential issues with vim.loop.cwd()
  local directory = vim.fn.fnamemodify(filepath, ':h')
  if directory == '' or directory == '.' then -- Handle file in cwd or relative path
    directory = vim.fn.getcwd() -- Use Neovim's current working directory as fallback
  end

  -- First, check if the file is actually in a git repository
  vim.fn.system({'git', '-C', directory, 'rev-parse', '--is-inside-work-tree'}, '')
  if vim.v.shell_error ~= 0 then
    vim.notify("File is not inside a Git repository.", vim.log.levels.WARN)
    return nil
  end

  local upstream_branch = vim.fn.systemlist({"git", "-C", directory, "rev-parse", "--abbrev-ref", "@{upstream}"})[1]
  if vim.v.shell_error ~= 0 then
    upstream_branch = "origin/main"
  end
  upstream_branch = string.sub(upstream_branch, string.find(upstream_branch, "/") + 1, -1)

  -- Construct the git command to get the specified remote URL
  -- Use systemlist to capture stdout line by line
  local cmd = {'git', '-C', directory, 'remote', 'get-url', remote_name}
  local result = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify("Could not get URL for remote '" .. remote_name .. "'. Does it exist?", vim.log.levels.ERROR)
    return nil
  end
  if #result == 0 or result[1] == '' then
    vim.notify("No URL found for remote '" .. remote_name .. "'.", vim.log.levels.WARN)
    return nil
  end
  -- Success: result[1] contains the URL
  local remote_url = result[1]

  local line, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local file = GetGitRelativePath()
  local url = getUrl(remote_url, upstream_branch, file, line)
  yank_to_clipboard(url)
  print(url)
end,
  "[C]opy File")

map("n", "<Leader>cs", function()
  local s = get_buf_name()
  yank_to_clipboard(s)
  print(s)
end,
  "[C]opy Source")

vim.keymap.set("n", "<C-p>", "<cmd>GFiles<cr>")
vim.keymap.set("n", "<C-s>", "<cmd>:w<cr>")
vim.keymap.set("n", "<C-w>\\", "<cmd>vsplit<cr>")
vim.keymap.set("n", "<C-w>-", "<cmd>split<cr>")

vim.keymap.set("n", "<Leader>of", "<cmd>e ~/fuchsia/<cr>")
vim.keymap.set("n", "<Leader>ob", "<cmd>Buffers<cr>")
vim.keymap.set("n", "<Leader>ow", "<cmd>Windows<cr>")
vim.keymap.set("n", "<Leader>oo", function()
  local dir = vim.api.nvim_buf_get_name(0):match('(.*/).*')
  local cmd = vim.api.nvim_replace_termcodes(":e "..dir, true, true, true)
  vim.api.nvim_feedkeys(cmd, "m", false)
end)


vim.keymap.set("n", "<Leader>ee", "<cmd>Ex<cr>")
vim.keymap.set("n", "<Leader>ev", "<cmd>Vex<cr>")
vim.keymap.set("n", "<Leader>es", "<cmd>Sex<cr>")

vim.keymap.set("n", "<Leader>kr", "<cmd>so ~/.config/nvim/lua/keybindings.lua<cr>")
vim.keymap.set("n", "<Leader>ki", "<cmd>e ~/.config/nvim/init.lua<cr>")
vim.keymap.set("n", "<Leader>kk", "<cmd>e ~/.config/nvim/lua/keybindings.lua<cr>")

vim.keymap.set("n", "<Leader>tp", "<cmd>setlocal paste!<cr>")
vim.keymap.set("n", "<Leader>of", "<cmd>e ~/fuchsia/<cr>")


vim.cmd("map <leader>wn :tab split<cr>")
vim.cmd("map <leader>wq :q<cr>")
vim.cmd("map <leader>to :tabonly<cr>")
vim.cmd("map <leader>tc :tabclose<cr>")
vim.cmd("map <leader>tm :tabmove")
vim.cmd("map <leader>tl :tabnext <cr>")
vim.cmd("map <leader>th :tabprev <cr>")

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })


vim.api.nvim_set_keymap('t', '<ESC>', '<C-\\><C-n>',  {noremap = true})
vim.api.nvim_set_keymap("n", "<Esc>", "", {
  noremap = true,
  replace_keycodes = true,
  expr = true,
  callback = function()
    if vim.api.nvim_win_get_config(0).relative ~= '' then
      return '<cmd>q<cr>'
    else
      return '<cmd>nohlsearch<CR>'
    end
  end
})

map("n", "<Leader>cc", function()
  local s = get_buf_name()
  local l,c = unpack(vim.api.nvim_win_get_cursor(0))
  s = "https://cs.opensource.google/fuchsia/fuchsia/+/main:"..s..";l="..l
  yank_to_clipboard(s)
  print(s)
end, "[C]opy [C]odesearch")

local map = function(mode, keys, func, desc)
  vim.keymap.set(mode, keys, func, {desc = desc })
end

local function yank_to_clipboard(text)
  vim.cmd('call system("nc localhost 8001", "'..text..'")')
end

local function get_buf_name()
  return string.gsub(vim.api.nvim_buf_get_name(0), vim.fn.getcwd().."/", "")
end

Run_cmd = "fx build"
map("n", '<leader>rs', ":lua Run_cmd='", '[R]un [S]etup')
map("n", "<Leader>rr", function()
  vim.fn.system("tmux send-keys -t {down-of} C-c \" " .. Run_cmd .. "\" Enter")
end, "[R]un [R]ecent")

map("n", "<Leader>sb", "<cmd>Buffer<cr>", "[S]earch [B]uffer")

function getUrl(git_remote, upstream_branch, file, linenum)
  local no_sso = string.sub(git_remote, 7)
  local first_slash = string.find(no_sso, "/")
  local project = string.sub(no_sso, 0, first_slash - 1)
  local repo = string.sub(no_sso, first_slash + 1)
  return project .. ".googlesource.com/" .. repo .. "/+/refs/heads/" .. upstream_branch .. file .. "#" .. linenum
end

function GetGitRelativePath()
  local current_file = vim.api.nvim_buf_get_name(0)
  if current_file == "" then
    return nil
  end

  local git_toplevel_command = string.format('git -C "%s" rev-parse --show-toplevel', vim.fn.expand('%:p:h'))
  local git_toplevel = vim.fn.systemlist(git_toplevel_command)[1]
  if vim.v.shell_error ~= 0 or not git_toplevel then
    return nil
  end
  git_toplevel = string.gsub(git_toplevel, "\n", "")

  local relative_path = vim.fs.normalize(string.sub(current_file, #git_toplevel + 1))
  return relative_path
end

map("n", "<Leader>cf", function()
  local remote_name = 'origin'

  local filepath = vim.api.nvim_buf_get_name(0)
  if filepath == '' then
    vim.notify("Current buffer has no associated file", vim.log.levels.WARN)
    return nil
  end

  -- Get the directory containing the file
  -- Use vim.fn.fnamemodify to handle potential issues with vim.loop.cwd()
  local directory = vim.fn.fnamemodify(filepath, ':h')
  if directory == '' or directory == '.' then -- Handle file in cwd or relative path
    directory = vim.fn.getcwd() -- Use Neovim's current working directory as fallback
  end

  -- First, check if the file is actually in a git repository
  vim.fn.system({'git', '-C', directory, 'rev-parse', '--is-inside-work-tree'}, '')
  if vim.v.shell_error ~= 0 then
    vim.notify("File is not inside a Git repository.", vim.log.levels.WARN)
    return nil
  end

  local upstream_branch = vim.fn.systemlist({"git", "-C", directory, "rev-parse", "--abbrev-ref", "@{upstream}"})[1]
  if vim.v.shell_error ~= 0 then
    upstream_branch = "origin/main"
  end
  upstream_branch = string.sub(upstream_branch, string.find(upstream_branch, "/") + 1, -1)

  -- Construct the git command to get the specified remote URL
  -- Use systemlist to capture stdout line by line
  local cmd = {'git', '-C', directory, 'remote', 'get-url', remote_name}
  local result = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify("Could not get URL for remote '" .. remote_name .. "'. Does it exist?", vim.log.levels.ERROR)
    return nil
  end
  if #result == 0 or result[1] == '' then
    vim.notify("No URL found for remote '" .. remote_name .. "'.", vim.log.levels.WARN)
    return nil
  end
  -- Success: result[1] contains the URL
  local remote_url = result[1]

  local line, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local file = GetGitRelativePath()
  local url = getUrl(remote_url, upstream_branch, file, line)
  yank_to_clipboard(url)
  print(url)
end,
  "[C]opy File")

map("n", "<Leader>cs", function()
  local s = get_buf_name()
  yank_to_clipboard(s)
  print(s)
end,
  "[C]opy Source")

vim.keymap.set("n", "<C-p>", "<cmd>GFiles<cr>")
vim.keymap.set("n", "<C-s>", "<cmd>:w<cr>")
vim.keymap.set("n", "<C-w>\\", "<cmd>vsplit<cr>")
vim.keymap.set("n", "<C-w>-", "<cmd>split<cr>")

vim.keymap.set("n", "<Leader>of", "<cmd>e ~/fuchsia/<cr>")
vim.keymap.set("n", "<Leader>ob", "<cmd>Buffers<cr>")
vim.keymap.set("n", "<Leader>ow", "<cmd>Windows<cr>")
vim.keymap.set("n", "<Leader>oo", function()
  local dir = vim.api.nvim_buf_get_name(0):match('(.*/).*')
  local cmd = vim.api.nvim_replace_termcodes(":e "..dir, true, true, true)
  vim.api.nvim_feedkeys(cmd, "m", false)
end)


vim.keymap.set("n", "<Leader>ee", "<cmd>Ex<cr>")
vim.keymap.set("n", "<Leader>ev", "<cmd>Vex<cr>")
vim.keymap.set("n", "<Leader>es", "<cmd>Sex<cr>")

vim.keymap.set("n", "<Leader>kr", "<cmd>so ~/.config/nvim/lua/keybindings.lua<cr>")
vim.keymap.set("n", "<Leader>ki", "<cmd>e ~/.config/nvim/init.lua<cr>")
vim.keymap.set("n", "<Leader>kk", "<cmd>e ~/.config/nvim/lua/keybindings.lua<cr>")

vim.keymap.set("n", "<Leader>tp", "<cmd>setlocal paste!<cr>")
vim.keymap.set("n", "<Leader>of", "<cmd>e ~/fuchsia/<cr>")


vim.cmd("map <leader>wn :tab split<cr>")
vim.cmd("map <leader>wq :q<cr>")
vim.cmd("map <leader>to :tabonly<cr>")
vim.cmd("map <leader>tc :tabclose<cr>")
vim.cmd("map <leader>tm :tabmove")
vim.cmd("map <leader>tl :tabnext <cr>")
vim.cmd("map <leader>th :tabprev <cr>")

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.api.nvim_set_keymap('t', '<ESC>', '<C-\\><C-n>',  {noremap = true})
vim.api.nvim_set_keymap("n", "<Esc>", "", {
  noremap = true,
  replace_keycodes = true,
  expr = true,
  callback = function()
    if vim.api.nvim_win_get_config(0).relative ~= '' then
      return '<cmd>q<cr>'
    else
      return '<cmd>nohlsearch<CR>'
    end
  end
})

map("n", "<Leader>cc", function()
  local s = get_buf_name()
  local l,c = unpack(vim.api.nvim_win_get_cursor(0))
  s = "https://cs.opensource.google/fuchsia/fuchsia/+/main:"..s..";l="..l
  yank_to_clipboard(s)
  print(s)
end, "[C]opy [C]odesearch")

vim.cmd("set updatetime=100")
vim.keymap.set("n", "<C-l>", "<C-W>l")
vim.keymap.set("n", "<C-j>", "<C-W>j")
vim.keymap.set("n", "<C-k>", "<C-W>k")
vim.keymap.set("n", "<C-h>", "<C-W>h")

vim.keymap.set("n", "<C-p>", "<cmd>GFiles<cr>")
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
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins!
require("lazy").setup({
  "rust-lang/rust.vim",
  "junegunn/fzf.vim",
  "junegunn/fzf",
  'tpope/vim-sensible',
  'tpope/vim-unimpaired',
  'tpope/vim-dispatch',
  'tpope/vim-fugitive',
  {'folke/which-key.nvim',
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
  {'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
    },
    config = function()
      require('telescope').setup {
        --  All the info you're looking for is in `:help telescope.setup()`
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Setting up my own picker
      vim.keymap.set('n', '<leader>sp', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [P]roject' })
    end,
  },
  {'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by nvim-cmp
      --    'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- Find references for the word under your cursor.
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          map('<leader>td', function()
            vim.diagnostic.enable(not vim.diagnostic.is_enabled())
          end, "[T]oggle [D]iagnostics")

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      --    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local servers = {
        clangd = {},
        rust_analyzer = {},
        ts_ls = {},

        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              diagnostics = { disable = { 'missing-fields', "undefined-global" } },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.
      require('mason').setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
  {'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = { 'bash', 'c', 'gn', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },
  { 'MagicDuck/grug-far.nvim',
    config = function()
      require('grug-far').setup {
      }
    end,
  },
  {'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions
        -- visual mode
        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git [s]tage hunk' })
        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git [r]eset hunk' })
        -- normal mode
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'git [u]ndo stage hunk' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        map('n', '<leader>hD', function()
          gitsigns.diffthis '@'
        end, { desc = 'git [D]iff against last commit' })
        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
        map('n', '<leader>tD', gitsigns.toggle_deleted, { desc = '[T]oggle git show [D]eleted' })
      end,
    },
  },
})
