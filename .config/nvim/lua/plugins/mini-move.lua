return {
  {
    "mini.move",
    opts = {
      mappings = {
        -- Move visual selection in Visual mode
        down = "J",
        up = "K",
      },
      options = {
        -- Automatically reindent selection during linewise vertical move
        reindent_linewise = true,
      },
    }
  }
}
