return {
  "akilonx/ChatGPT.nvim",
  branch = "fix/o1_model_support",
  commit = "0e266ef7c1e8acb43b08883c4d556dc11d859360",
  cmd = { "ChatGPT", "ChatGPTActAs", "ChatGPTCompleteCode", "ChatGPTEditWithInstructions", "ChatGPTRun" },
  -- this config assumes you have OPENAI_API_KEY environment variable set
  config = function()
    require("chatgpt").setup {
      openai_params = {
        -- model = "o3-mini",
        -- frequency_penalty = 0,
        -- presence_penalty = 0,
        -- max_tokens = nil,
        -- temperature = nil,
        -- top_p = 0.1,
        -- n = 1,
        -- model = "o1-mini-2024-09-12",
        model = "o3-mini",
        max_tokens = 4095,
        -- max_completion_tokens = 4095,
        frequency_penalty = 0,
        presence_penalty = 0,
        temperature = 1,
        top_p = 1,
        n = 1,
      },
    }
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    { "folke/trouble.nvim", cmd = "Trouble", opts = {} },
    "nvim-telescope/telescope.nvim",
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings
        local prefix = "<Leader>G"
        maps.n[prefix] = { desc = require("astroui").get_icon("ChatGPT", 1, true) .. "ChatGPT" }
        maps.v[prefix] = { desc = require("astroui").get_icon("ChatGPT", 1, true) .. "ChatGPT" }
        maps.n[prefix .. "c"] = { "<cmd>ChatGPT<CR>", desc = "ChatGPT" }
        maps.n[prefix .. "C"] = { "<cmd>ChatGPTActAs<CR>", desc = "ChatGPT Acts As ..." }
        maps.n[prefix .. "m"] = { "<cmd>ChatGPTCompleteCode<CR>", desc = "Complete Code" }

        maps.n[prefix .. "e"] = { "<cmd>ChatGPTEditWithInstruction<CR>", desc = "Edit with instruction" }
        maps.v[prefix .. "e"] = { "<cmd>ChatGPTEditWithInstruction<CR>", desc = "Edit with instruction" }

        maps.n[prefix .. "g"] = { "<cmd>ChatGPTRun grammar_correction<CR>", desc = "Grammar Correction" }
        maps.v[prefix .. "g"] = { "<cmd>ChatGPTRun grammar_correction<CR>", desc = "Grammar Correction" }

        maps.n[prefix .. "t"] = { "<cmd>ChatGPTRun translate<CR>", desc = "Translate" }
        maps.v[prefix .. "t"] = { "<cmd>ChatGPTRun translate<CR>", desc = "Translate" }

        maps.n[prefix .. "k"] = { "<cmd>ChatGPTRun keywords<CR>", desc = "Keywords" }
        maps.v[prefix .. "k"] = { "<cmd>ChatGPTRun keywords<CR>", desc = "Keywords" }

        maps.n[prefix .. "d"] = { "<cmd>ChatGPTRun docstring<CR>", desc = "Docstring" }
        maps.v[prefix .. "d"] = { "<cmd>ChatGPTRun docstring<CR>", desc = "Docstring" }

        maps.n[prefix .. "a"] = { "<cmd>ChatGPTRun add_tests<CR>", desc = "Add Tests" }
        maps.v[prefix .. "a"] = { "<cmd>ChatGPTRun add_tests<CR>", desc = "Add Tests" }

        maps.n[prefix .. "o"] = { "<cmd>ChatGPTRun optimize_code<CR>", desc = "Optimize Code" }
        maps.v[prefix .. "o"] = { "<cmd>ChatGPTRun optimize_code<CR>", desc = "Optimize Code" }

        maps.n[prefix .. "s"] = { "<cmd>ChatGPTRun summarize<CR>", desc = "Summarize" }
        maps.v[prefix .. "s"] = { "<cmd>ChatGPTRun summarize<CR>", desc = "Summarize" }

        maps.n[prefix .. "f"] = { "<cmd>ChatGPTRun fix_bugs<CR>", desc = "Fix Bugs" }
        maps.v[prefix .. "f"] = { "<cmd>ChatGPTRun fix_bugs<CR>", desc = "Fix Bugs" }

        maps.n[prefix .. "x"] = { "<cmd>ChatGPTRun explain_code<CR>", desc = "Explain Code" }
        maps.v[prefix .. "x"] = { "<cmd>ChatGPTRun explain_code<CR>", desc = "Explain Code" }

        maps.n[prefix .. "r"] = { "<cmd>ChatGPTRun roxygen_edit<CR>", desc = "Roxygen Edit" }
        maps.v[prefix .. "r"] = { "<cmd>ChatGPTRun roxygen_edit<CR>", desc = "Roxygen Edit" }

        maps.n[prefix .. "l"] = { "<cmd>ChatGPTRun code_readability_analysis<CR>", desc = "Code Readability Analysis" }
        maps.v[prefix .. "l"] = { "<cmd>ChatGPTRun code_readability_analysis<CR>", desc = "Code Readability Analysis" }
      end,
    },
    { "AstroNvim/astroui", opts = { icons = { ChatGPT = "󰭹" } } },
  },
  opts = {},
}
