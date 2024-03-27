return {
  -- Configure AstroNvim updates
  updater = {
    remote = "origin", -- remote to use
    channel = "stable", -- "stable" or "nightly"
    version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "nightly", -- branch name (NIGHTLY ONLY)
    commit = nil, -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false, -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    auto_quit = false, -- automatically quit the current session after a successful update
    remotes = { -- easily add new remotes to track
      --   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
      --   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
      --   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
    },
  },

  -- Set colorscheme to use
  -- options: astrodark | catppuccin | sonokai | github_dark | gruvbox | tokyonight
  colorscheme = "catppuccin",

  -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
  diagnostics = {
    virtual_text = true,
    underline = true,
  },

  lsp = {
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = false, -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        -- "lua_ls",
      },
      timeout_ms = 5000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- enable servers that you already have installed without mason
    servers = {
      -- "pyright"
    },
  },

  -- Configure require("lazy").setup() options
  lazy = {
    defaults = { lazy = true },
    performance = {
      rtp = {
        -- customize default disabled vim plugins
        disabled_plugins = { "tohtml", "gzip", "matchit", "zipPlugin", "netrwPlugin", "tarPlugin" },
      },
    },
  },

  -- This function is run last and is a good place to configuring
  -- augroups/autocommands and custom filetypes also this just pure lua so
  -- anything that doesn't fit in the normal config locations above can go here
  polish = function()
    local unmap = vim.api.nvim_del_keymap
    local map = vim.keymap.set

    -- Set transparent background
    -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    -- vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "none" })

    -- Set key bindings
    vim.keymap.set("n", "<C-s>", ":w!<CR>")
    -- write w/o autocmds (mainly to prevent null-ls from autoformatting)
    vim.keymap.set("n", "<leader>W", ":noautocmd w<CR>")

    -----------------------------------------------------
    -- Keymap overrides
    -----------------------------------------------------
    unmap("n", "<leader>ff") -- unmap find files
    unmap("n", "<leader>fw") -- unmap find words

    -- map <leader>ff to search in hidden files excluding .git dir
    -- Other ripgrep flags come from ~/.config/ripgrep/.ripgreprc
    map(
      "n",
      "<leader>ff",
      function()
        require("telescope.builtin").find_files {
          find_command = {
            "rg",
            "--hidden",
            "--files",
            "--no-ignore-vcs",
          },
        }
      end,
      { desc = "Search all files" }
    )

    -- map <leader>fw to search for words in hidden files excluding .git dir
    -- Other ripgrep flags come from ~/.config/ripgrep/.ripgreprc
    map(
      "n",
      "<leader>fw",
      function()
        require("telescope.builtin").live_grep {
          vimgrep_arguments = {
            "rg",
            "--hidden",
            "--column",
            "--no-ignore-vcs",
          },
        }
      end,
      { desc = "Search all words" }
    )

    -- Set up custom filetypes
    vim.filetype.add {
      extension = {
        j2 = "htmldjango",
        -- foo = "fooscript",
      },
      -- filename = {
      --   ["Foofile"] = "fooscript",
      -- },
      pattern = {
        -- ["~/%.config/foo/.*"] = "fooscript",
        [".envrc*"] = "sh",
        [".zsh*"] = "sh",
      },
    }

    -- See: https://www.reddit.com/r/vim/comments/139fn2b/plugin_paste_markdown_link_with_title/
    function InsertMarkdownURL()
      local url = vim.fn.getreg "+"
      if url == "" then return end
      local cmd = "curl -L " .. vim.fn.shellescape(url) .. " 2>/dev/null"
      local handle = io.popen(cmd)
      if not handle then return end
      local html = handle:read "*a"
      handle:close()
      local title = ""
      local pattern = "<title>(.-)</title>"
      local m = string.match(html, pattern)
      if m then title = m end
      if title ~= "" then
        local markdownLink = "[" .. title .. "](" .. url .. ")"
        vim.api.nvim_command("call append(line('.'), '" .. markdownLink .. "')")
      else
        print("Title not found for link")
      end
    end
    
    vim.api.nvim_set_keymap("n", "<leader>mdp", ":lua InsertMarkdownURL()<CR>", { silent = true, noremap = true })
  end,
}
