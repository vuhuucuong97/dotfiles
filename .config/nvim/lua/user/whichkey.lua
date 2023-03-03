vim.o.timeout = true
vim.o.timeoutlen = 500
local wk = require("which-key")

wk.setup {}
wk.register({
  ["<leader>f"] = { name = "Find" },
  ["<leader>v"] = { name = "Vim" },
  ["<leader>g"] = { name = "Git" },
  ["<leader>l"] = { name = "LSP" },
  ["<leader>e"] = { name = "Explorer" },
})
