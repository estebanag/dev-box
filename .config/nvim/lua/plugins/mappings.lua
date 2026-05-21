return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        -- first key is the mode
        n = {
          ["<C-d>"] = {"<C-d>zz"},
          ["<C-u>"] = {"<C-u>zz"},
          ["J"] = {"mzJ`z"},
          ["n"] = {"nzzzv"},
          ["N"] = {"Nzzzv"},
          ["<leader>y"] = {"\"+y"},
          ["<leader>Y"] = {"\"+y"},
        },
        v = {
          ["<leader>y"] = {"\"+y"},
        },
        t = {
          -- setting a mapping to false will disable it
          -- ["<esc>"] = false,
        },
      },
    },
  },
}
