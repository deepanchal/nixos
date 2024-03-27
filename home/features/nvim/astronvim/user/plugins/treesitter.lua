return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    -- add more things to the ensure_installed table protecting against community packs modifying it
    opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
      "bash",
      "c",
      "cmake",
      "cpp",
      "css",
      "dockerfile",
      "go",
      "graphql",
      "html",
      "http",
      "java",
      "javascript",
      "jsdoc",
      "json",
      "jsonc",
      "lua",
      "make",
      "markdown",
      "python",
      "regex",
      "rust",
      "scss",
      "tsx",
      "typescript",
      "vim",
      "vue",
      "yaml",
    })

    -- Automatically install missing parsers when entering buffer
    opts.auto_install = true
  end,
}
