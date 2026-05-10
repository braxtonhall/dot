-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Leader key (set before plugins load)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Core options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.undofile = true          -- Persistent undo

-- Keymaps
local map = vim.keymap.set

-- jk to exit insert mode (belt-and-suspenders alongside CapsLock remap)
map("i", "jk", "<Esc>")

-- Better split navigation (Ctrl+hjkl)
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Quick splits
map("n", "<leader>v", ":vsplit<CR>")
map("n", "<leader>h", ":split<CR>")

-- Better indenting in visual mode (stay in visual after indent)
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Plugins
require("lazy").setup({

  -- Colorscheme (256-color safe, works in Terminal.app)
  {
    "NLKNguyen/papercolor-theme",
    priority = 1000,
    config = function()
      vim.o.background = "light"
      vim.cmd.colorscheme("PaperColor")
    end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup()
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
    end,
  },

  -- Fuzzy finder (like VSCode Ctrl+P)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files)
      vim.keymap.set("n", "<leader>fg", builtin.live_grep)
      vim.keymap.set("n", "<leader>fb", builtin.buffers)
    end,
  },

  -- Syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = { "typescript", "tsx", "javascript", "json", "lua", "css", "html" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- LSP: Language Server Protocol
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "ts_ls", "eslint" },
        automatic_installation = true,
      })

      -- Keymaps attached whenever an LSP connects to a buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local opts = { buffer = event.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)        -- Go to definition
          vim.keymap.set("n", "K",  vim.lsp.buf.hover, opts)             -- Hover docs
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)    -- Rename symbol
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- Code actions
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)        -- Find references
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)      -- Prev diagnostic
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)      -- Next diagnostic
        end,
      })

      -- Modern API (Neovim 0.11+)
      vim.lsp.config("ts_ls", {})
      vim.lsp.config("eslint", {})
      vim.lsp.enable({ "ts_ls", "eslint" })
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<Tab>"]     = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- Auto-pairs (closes brackets, quotes automatically)
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({ options = { theme = "papercolor_light" } })
    end,
  },

  -- Git signs in the gutter
  {
    "lewis6991/gitsigns.nvim",
    config = true,
  },

  -- Comment toggling (gcc to comment a line)
  {
    "numToStr/Comment.nvim",
    config = true,
  },

})

