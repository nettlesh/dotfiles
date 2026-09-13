-- NOTE: Mini's initial-file setup must run before language servers start
Config.now_if_args(function()
    -- Server definitions come from nvim-lspconfig; binaries must be on PATH
    vim.lsp.enable({
        "bashls",
        "fish_lsp",
        "lua_ls",
        "marksman",
        "rust_analyzer",
    })
end)
