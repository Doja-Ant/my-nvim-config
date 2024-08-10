module = {}
function module.setup()
  require("toggleterm").setup({
    open_mapping = "<c-[>",
    terminal_mappings = true,
    start_in_insert = true,
  })
  -- local Terminal = require("toggleterm.terminal").Terminal
  --
  -- local horizon_term = Terminal:new({ direction = "horizon" })
end
return module
