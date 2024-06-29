-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  -- example of imporing a plugin, comment out to use it or add your own
  -- available plugins can be found at https://github.com/AstroNvim/astrocommunity

  -- Themes
  { import = "astrocommunity.colorscheme.catppuccin" },
  -- { import = "astrocommunity.colorscheme.github-nvim-theme" },
  -- { import = "astrocommunity.colorscheme.tokyonight-nvim" },
  -- { import = "astrocommunity.colorscheme.gruvbox-nvim" },

  -- Color
  { import = "astrocommunity.color.transparent-nvim" },

  -- Motion
  { import = "astrocommunity.motion.nvim-surround" },
  -- { import = "astrocommunity.motion.harpoon" },

  -- Git
  { import = "astrocommunity.git.git-blame-nvim" },
  { import = "astrocommunity.git.gitlinker-nvim" },
  { import = "astrocommunity.git.diffview-nvim" },

  -- Diagnostics
  { import = "astrocommunity.diagnostics.trouble-nvim" },

  -- Plugin Packs
  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.toml" },
  { import = "astrocommunity.pack.yaml" },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.vue" },
  { import = "astrocommunity.pack.tailwindcss" },
  -- { import = "astrocommunity.pack.prisma" },
  { import = "astrocommunity.pack.typescript" },
  -- Disabled bc it uses archived rnix lsp
  -- { import = "astrocommunity.pack.nix" },
  { import = "astrocommunity.pack.python-ruff" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.go" },
  -- { import = "astrocommunity.pack.just" },
  -- { import = "astrocommunity.pack.ansible" },
  -- { import = "astrocommunity.pack.dart" },
  -- { import = "astrocommunity.pack.cpp" },
  -- { import = "astrocommunity.pack.cs" },

  -- Lsp
  { import = "astrocommunity.lsp.lsp-signature-nvim" },
  { import = "astrocommunity.lsp.lsp-lens-nvim" },
  -- { import = "astrocommunity.lsp.lsp-inlayhints-nvim" }, -- archived -> TODO: replace with native nvim inlay hints in future version
  -- { import = "astrocommunity.lsp.nvim-lint" },
  { import = "astrocommunity.lsp.garbage-day-nvim" },

  -- Other
  { import = "astrocommunity.syntax.vim-easy-align" },
  -- { import = "astrocommunity.editing-support.conform-nvim" },
  { import = "astrocommunity.editing-support.refactoring-nvim" },
  { import = "astrocommunity.editing-support.chatgpt-nvim" },
  { import = "astrocommunity.media.vim-wakatime" },
}
