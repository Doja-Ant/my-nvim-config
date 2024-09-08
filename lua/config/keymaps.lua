vim.keymap.set("n", "<leader>w", ":w<cr>")
vim.keymap.set("n", "<leader>q", ":q<cr>")
vim.keymap.set("n", "<leader>h", ":nohl<cr>")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")

vim.keymap.set("i", "jk", "<esc>")

vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l")
vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h")
vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j")
vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k")
vim.keymap.set("t", "<esc>", "<C-\\><C-N>")

vim.keymap.set("n", "<leader>/", "gcc", { remap = true })
vim.keymap.set("v", "<leader>/", "gc", { remap = true })

vim.keymap.set({ "i", "s" }, "<Tab>", function()
  if vim.snippet.active({ direction = 1 }) then
    return "<cmd>lua vim.snippet.jump(1)<cr>"
  else
    return "<Tab>"
  end
end, { expr = true })

-- launch Telescope with specified dir
vim.keymap.set("n", "<leader>fi", function()
  local cwd = vim.fn.getcwd()
  vim.cmd({ cmd = "cd", args = { "~/" } })
  vim.ui.input({ prompt = "find files from cwd: ~/", completion = "dir" }, function(input)
    local dir = "~/" .. input
    vim.cmd({ cmd = "Telescope", args = { "find_files", "cwd=" .. dir } })
  end)
  vim.cmd({ cmd = "cd", args = { cwd } })
end)
