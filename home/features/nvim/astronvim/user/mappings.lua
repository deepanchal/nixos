-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
return {
  -- first key is the mode
  n = {
    -- second key is the lefthand side of the map
    -- mappings seen under group name "Buffer"
    ["<leader>bn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
    ["<leader>bD"] = {
      function()
        require("astronvim.utils.status").heirline.buffer_picker(
          function(bufnr) require("astronvim.utils.buffer").close(bufnr) end
        )
      end,
      desc = "Pick to close",
    },
    -- tables with the `name` key will be registered with which-key if it's installed
    -- this is useful for naming menus
    ["<leader>b"] = { name = "Buffers" },
    -- quick save
    -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command

    ["<C-d>"] = { "<C-d>zz", desc = "PgDown Centered" },
    ["<C-u>"] = { "<C-u>zz", desc = "PgUp Centered" },
    n = { "nzzzv", desc = "Next highlighted centered" },
    N = { "Nzzzv", desc = "Prev highlighted centered" },
    J = { "mzJ`z", desc = "Join Line w/ cursor at start" },
    L = {
      function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
      desc = "Next buffer",
    },
    H = {
      function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
      desc = "Previous buffer",
    },
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
}
