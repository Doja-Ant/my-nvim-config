local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

local plugins = {
  -- telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
    },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
      vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

      vim.keymap.set("n", "gd", builtin.lsp_definitions, {})
      vim.keymap.set("n", "gi", builtin.lsp_implementations, {})
      vim.keymap.set("n", "gt", builtin.lsp_type_definitions, {})

      vim.keymap.set("n", "gr", builtin.lsp_references, {})
      vim.keymap.set("n", "<leader>i", builtin.lsp_incoming_calls, {})
      vim.keymap.set("n", "<leader>o", builtin.lsp_outgoing_calls, {})
    end,
  },
  -- nvim tree
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup({
        on_attach = function(bufnr)
          local api = require("nvim-tree.api")
          local function opts(desc)
            return {
              desc = "nvim-tree: " .. desc,
              buffer = bufnr,
              noremap = true,
              silent = true,
              nowait = true,
            }
          end
          api.config.mappings.default_on_attach(bufnr)
          vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
          vim.keymap.set("n", "<leader>k", api.tree.change_root_to_parent, opts("Up"))
          vim.keymap.set("n", "<leader>j", api.tree.change_root_to_node, opts("CD"))
          vim.keymap.set("n", "<leader>e", api.tree.toggle, opts("Toggle"))
        end,
        reload_on_bufenter = true,
        prefer_startup_root = true,
        update_focused_file = {
          enable = true,
          update_root = {
            enable = true,
          },
        },
      })
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<cr>")
    end,
  },
  -- lsp config
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",
  -- nvim cmp
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/nvim-cmp",
  -- formatter
  {
    "stevearc/conform.nvim",
    opts = {},
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "black" },
          cpp = { "clang-format" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
        log_level = 1,
        notify_on_error = true,
      })
      require("conform").formatters.stylua = {
        prepend_args = {
          "--indent-width",
          "2",
          "--indent-type",
          "Spaces",
        },
      }
    end,
  },
  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    opts = {
      highlight = { enable = true },
    },
  },
  -- color schemes
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "lervag/vimtex",
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      -- VimTeX configuration goes here, e.g.
      vim.g.vimtex_view_method = "zathura"
    end,
  },
  {
    { "akinsho/toggleterm.nvim", version = "*", config = true },
  },
}

require("lazy").setup(plugins, opts)

require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "clangd", "pyright", "pylyzer", "pylsp" },
})

local cmp = require("cmp")
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-5),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  sources = {
    { name = "nvim_lsp" },
  },
})

require("nvim-treesitter.configs").setup({
  ensure_installed = { "c", "lua", "vim", "vimdoc", "python", "cpp", "query" },
  auto_install = true,
  highlight = {
    enable = true,
  },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")

lspconfig.clangd.setup({
  capabilities = capabilities,
})

lspconfig.pyright.setup({
  root_dir = lspconfig.util.root_pattern("main.py"),
  capabilities = capabilities,
})

-- require("lspconfig").pyright.setup({
--   capabilities = capabilities,
--   single_file_support = true,
-- })
-- require("lspconfig").pylyzer.setup({})

require("lspconfig").pylsp.setup({})

require("lspconfig").lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        disable = {
          "undefined-global",
        },
      },
    },
  },
})

require("plugins_config.toggleterm").setup()
