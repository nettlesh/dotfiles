return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Use the mise-managed taplo so format-on-save matches `mise run fmt`
        taplo = { mason = false },
      },
    },
  },
}
