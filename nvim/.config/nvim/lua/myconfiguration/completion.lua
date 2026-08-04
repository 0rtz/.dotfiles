-- Completion engine with built-in fuzzy matching, snippets, and LSP support
MyAddPlugin("saghen/blink.cmp")
-- Native fuzzy matching library for blink.cmp
MyAddPlugin("saghen/blink.lib")
-- Dictionary completion source
MyAddPlugin("Kaiser-Yang/blink-cmp-dictionary")
-- Collection of snippets
MyAddPlugin("rafamadriz/friendly-snippets")

local opt = vim.opt

-- Completion options
opt.updatetime = 100
opt.shortmess:append("c")

local cmp = require('blink.cmp')
-- https://main.cmp.saghen.dev/installation
cmp.build():wait(60000)
cmp.setup({
  enabled = function()
    return vim.bo.buftype ~= "prompt"
  end,

  keymap = {
    preset = "none",
    ["<C-u>"] = { "scroll_documentation_up", "fallback" },
    ["<C-d>"] = { "scroll_documentation_down", "fallback" },
    ["<C-Space>"] = { "show", "fallback" },
    ["<C-e>"] = { "hide", "fallback" },
    ["<C-x>"] = { "cancel", "fallback" },
    ["<C-j>"] = { "select_next", "snippet_forward", "fallback" },
    ["<C-k>"] = { "select_prev", "snippet_backward", "fallback" },
    ["<C-l>"] = { "accept", "fallback" },
  },

  completion = {
    list = {
      selection = { preselect = false, auto_insert = false },
    },
    menu = {
      draw = {
        columns = {
          { "kind_icon" },
          { "label", "label_description", gap = 1 },
        },
      },
    },
    documentation = {
      auto_show = true,
    },
  },

  sources = {
    default = { "lsp", "snippets", "buffer", "path", "dictionary" },
    providers = {
      dictionary = {
        module = "blink-cmp-dictionary",
        name = "Dict",
        min_keyword_length = 2,
        score_offset = -3,
        opts = {
          dictionary_files = { vim.fn.stdpath("config") .. "/en.dict" },
        },
      },
      snippets = {
        opts = {
          search_paths = { vim.fn.stdpath("config") .. "/luasnippets" },
        },
      },
    },
  },

  cmdline = {
    keymap = {
      preset = "none",
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-l>"] = { "accept", "fallback" },
      ["<C-Space>"] = { "show", "fallback" },
    },
  },
})
