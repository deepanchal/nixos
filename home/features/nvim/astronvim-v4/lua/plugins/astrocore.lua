-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 500, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "auto", -- sets vim.opt.signcolumn to auto
        wrap = false, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        ["<C-d>"] = { "<C-d>zz", desc = "PgDown Centered" },
        ["<C-u>"] = { "<C-u>zz", desc = "PgUp Centered" },
        -- n = { "nzzzv", desc = "Next highlighted centered" },
        -- N = { "Nzzzv", desc = "Prev highlighted centered" },
        J = { "mzJ`z", desc = "Join Line w/ cursor at start" },

        -- navigate buffer tabs with `H` and `L`
        L = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        H = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        ["<leader>d"] = {
          [["_d]],
          desc = "Delete to void register",
        },
        ["<leader>y"] = {
          [["+y]],
          desc = "",
        },
        ["<leader>Y"] = {
          [["+Y]],
          desc = "",
        },
        ["<leader>s"] = {
          [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
          desc = "Find & Replace current word",
        },
        -- Prettier
        ["<leader>lpf"] = {
          ":!prettier --log-level=silent --write %<cr>",
          desc = "Format current file with Prettier",
        },
        -- Eslint
        ["<leader>lef"] = {
          ":!eslint_d --quiet --fix %<cr>",
          desc = "Fix ESLint errors in current file",
        },
        -- ChatGPT
        ["<leader>ai"] = {
          ":ChatGPT<cr>",
          desc = "Open ChatGPT chat",
        },

        -- mappings seen under group name "Buffer"
        ["<Leader>bD"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Pick to close",
        },
        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        ["<Leader>b"] = { desc = "Buffers" },
        -- quick save
        -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
      },
      v = {
        J = {
          ":m '<-2<CR>gv=gv",
          desc = "Move selection down",
        },
        K = {
          ":m '>+1<CR>gv=gv",
          desc = "Move selection up",
        },
        ["<leader>d"] = {
          [["_d]],
          desc = "Delete to void register",
        },
        ["<leader>y"] = {
          [["+y]],
          desc = "",
        },
        -- Prettier
        ["<leader>lpf"] = {
          ":!prettierd %<cr>",
          desc = "Format current selection with Prettier",
        },
        -- Eslint
        ["<leader>lef"] = {
          ":!eslint_d --quiet --fix %<cr>",
          desc = "Fix ESLint errors in current file",
        },
      },
      x = {
        -- Greatest remap EVER!!
        -- Let me explain, this remap while in visual mode
        -- will delete what is currently highlighted and replace it
        -- with what is in the register BUT it will YANK (delete) it
        -- to a VOID register. Meaning I still have what I originally had
        -- when I pasted. I don't loose the previous thing I YANKED!
        ["p"] = {
          [["_dP]],
          desc = "Yank & delete highlighted",
        },
      },
      t = {
        -- setting a mapping to false will disable it
        -- ["<esc>"] = false,
      },
    },
  },
}
