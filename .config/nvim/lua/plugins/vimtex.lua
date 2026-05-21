return {
  {
    "lervag/vimtex",
    init = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        continuous = 1,  -- This enables auto-compile on save
        background = 1,  -- Run in background
        build_dir = "",  -- Optional: build directory
        callback = 1,    -- Use callback to auto open viewer
      }
    end,
  },
}
