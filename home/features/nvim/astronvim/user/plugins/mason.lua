-- customize mason plugins
return {
  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    -- overrides `require("mason-lspconfig").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      -- See: https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
      opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
        "angularls",                       -- angular
        "ansiblels",                       -- ansible
        "bashls",                          -- bash
        "clangd",                          -- c & c++
        "cmake",                           -- cmake
        "cssls",                           -- css
        "dockerls",                        -- docker
        "docker_compose_language_service", -- docker compose
        -- "eslint",                          -- eslint
        -- "eslint_d",                        -- eslint_d
        "gopls",                           -- go lang
        "html",                            -- html
        "jsonls",                          -- json
        "jdtls",                           -- java
        "tsserver",                        -- typescript / javascript
        "lua_ls",                          -- lua
        "marksman",                        -- markdown
        "pyright",                         -- python
        "rust_analyzer",                   -- rust
        "sqlls",                           -- sql
        "taplo",                           -- toml
        "tailwindcss",                     -- tailwindcss
        "volar",                           -- vue
        "yamlls",                          -- yaml
      })

      opts.automatic_installation = true
    end,
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
        -- "prettier",
        -- "prettierd",
        "black",
        "stylua",
      })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- overrides `require("mason-nvim-dap").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
        "python",
      })
    end,
  },
}
