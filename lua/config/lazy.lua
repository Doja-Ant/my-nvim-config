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
      "nvim-telescope/telescope-live-grep-args.nvim"
    },
    config = function()
      builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

      vim.keymap.set('n', 'gd', builtin.lsp_definitions, {})
      vim.keymap.set('n', 'gi', builtin.lsp_implementations, {})
      vim.keymap.set('n', 'gt', builtin.lsp_type_definitions, {})

      vim.keymap.set('n', 'gr', builtin.lsp_references, {})
      vim.keymap.set('n', '<leader>i', builtin.lsp_incoming_calls, {})
      vim.keymap.set('n', '<leader>o', builtin.lsp_outgoing_calls, {})
    end
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
	    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	  end
	  vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
	  vim.keymap.set('n', '<leader>k', api.tree.change_root_to_parent, opts('Up'))
	  vim.keymap.set('n', '<leader>j', api.tree.change_root_to_node, opts('CD'))
	  api.config.mappings.default_on_attach(bufnr)
	end
      })
      vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<cr>')
    end
  },
  -- lsp config 
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",
  -- nvim cmp
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/nvim-cmp',
  -- color schemes 
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  }
}

require("lazy").setup(plugins, opts)

require("mason").setup()

require("mason-lspconfig").setup{
  ensure_installed = {"clangd"}
}

local cmp = require("cmp")
cmp.setup {
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-5),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end
  },
  sources = {
    {name = 'nvim_lsp'}
  }
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()
require("lspconfig").clangd.setup {
  capabilities = capabilities
}
