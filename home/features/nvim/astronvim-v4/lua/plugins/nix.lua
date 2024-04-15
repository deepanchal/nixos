-- Astrocommunity nix pack was broken bc of rnix
-- See:
-- https://github.com/AstroNvim/astrocommunity/blob/ab14eab0f0b163e2aba7e13b2349acd929683d27/lua/astrocommunity/pack/nix/init.lua
-- https://github.com/AstroNvim/astrocommunity/blob/main/lua/astrocommunity/pack/nix/init.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "nix" })
      end
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "nil_ls" })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "nil_ls" })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require "null-ls"
      -- safely extend the list
      opts.sources = opts.sources or {}
      vim.list_extend(opts.sources, {
        nls.builtins.code_actions.statix,
        nls.builtins.formatting.alejandra,
        nls.builtins.diagnostics.deadnix,
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        nix = { "alejandra" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        nix = { "statix" },
      },
    },
  },
}

