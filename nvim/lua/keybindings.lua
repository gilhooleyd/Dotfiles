vim.opt.cursorline = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showtabline = 2
vim.opt.colorcolumn="100"
vim.keymap.set("n", "<Leader>rr", "<cmd>so ~/.config/nvim/lua/keybindings.lua<cr>")

vim.keymap.set("n", "<C-p>", "<cmd>GFiles<cr>")
vim.keymap.set("n", "<C-s>", "<cmd>:w<cr>")

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
vim.keymap.set("n", "<Leader>ec", "<cmd>e ~/.config/nvim/init.lua<cr>")
vim.keymap.set("n", "<Leader>ek", "<cmd>e ~/.config/nvim/lua/keybindings.lua<cr>")

vim.keymap.set("n", "<Leader>sv", "<cmd>vsplit<cr>")
vim.keymap.set("n", "<Leader>sh", "<cmd>split<cr>")
vim.keymap.set("n", "<Leader>pp", "<cmd>setlocal paste!<cr>")
vim.keymap.set("n", "<Leader>cb", "<cmd>e ~/.bashrc<cr>")
vim.keymap.set("n", "<Leader>of", "<cmd>e ~/fuchsia/<cr>")

vim.api.nvim_set_keymap('t', '<ESC>', '<C-\\><C-n>',  {noremap = true})
vim.api.nvim_set_keymap("n", "<Esc>", "", {
  noremap = true,
  replace_keycodes = true,
  expr = true,
  callback = function()
    if vim.api.nvim_win_get_config(0).relative ~= '' then
      return '<cmd>q<cr>'
    else
      return '<Esc>'
    end
  end
})


vim.keymap.set("n", "<Leader>cc", function()
 local s = vim.api.nvim_buf_get_name(0)
 local l,c = unpack(vim.api.nvim_win_get_cursor(0))
 s = string.sub(s, string.len("/usr/local/google/home/dgilhooley/fuchsia/")+1)
 s = "https://cs.opensource.google/fuchsia/fuchsia/+/main:"..s..";l="..l
 yank_to_clipboard(s)
 print(s)
end)

function yank_to_clipboard(text)
 vim.cmd('call system("nc localhost 8001", "'..text..'")')
end

function open_terminal_window()
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

vim.keymap.set("n", "<Leader>w", open_terminal_window)

print("Loaded keybindings")

