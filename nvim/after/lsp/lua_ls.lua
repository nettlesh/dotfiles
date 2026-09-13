-- Neovim-specific settings for the Lua server; merged over nvim-lspconfig's
return {
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
                path = vim.split(package.path, ";"),
            },
            workspace = {
                ignoreSubmodules = true,
                library = { vim.env.VIMRUNTIME },
            },
        },
    },
}
