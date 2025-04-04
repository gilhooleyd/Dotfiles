vim.opt.cursorline = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showtabline = 2
vim.opt.colorcolumn="100"

vim.opt.relativenumber = true
vim.opt.showmode = false
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

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
map('<leader>rs', ":lua Run_cmd='", '[R]un [S]etup', { 'n', 'x' })
map("n", "<Leader>rr", function()
  vim.fn.system("tmux send-keys -t {down-of} C-c \" " .. Run_cmd .. "\" Enter")
end, "[R]un [R]ecent")

map("n", "<Leader>r", "<cmd>Make<cr>", "Make")
map("n", "<Leader>sb", "<cmd>Buffer<cr>", "[S]earch [B]uffer")
map("n", "<Leader>cf", function()
  local s = get_buf_name()
  yank_to_clipboard(s)
  print(s)
end,
  "[C]opy File")

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


vim.cmd("map <leader>wn :tabnew<cr>")
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

local function open_terminal_window()
--  local buf = vim.api.nvim_create_buf(false, true)

  local width=150; local height=50
  local ui = vim.api.nvim_list_uis()[1]
  local opts = {relative='editor', border="single", width=width, height=height, col=ui.width/2 - width/2,
    row=ui.height/2 - height/2, anchor='NW', }
  local bufid = 1
  local win = vim.api.nvim_open_win(bufid, 1, opts)
  vim.api.nvim_win_set_option(win, 'winhl', 'Normal:MyHighlight')
  vim.cmd("startinsert")
end

vim.keymap.set("n", "<Leader>j", open_terminal_window)

print("Loaded keybindings")

