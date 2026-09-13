-- NOTE: Register highlighting before reading a file supplied at startup
Config.now_if_args(function()
    -- Rebuild parsers after an update, as the plugin pins them to its revision
    local ts_update = function() vim.cmd("TSUpdate") end
    Config.on_packchanged(
        "nvim-treesitter",
        { "update" },
        ts_update,
        ":TSUpdate"
    )

    local languages =
        { "go", "python", "rust", "typescript", "tsx", "javascript" }
    local isnt_installed = function(lang)
        local found =
            vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false)
        return #found == 0
    end
    local to_install = vim.tbl_filter(isnt_installed, languages)
    if #to_install > 0 then require("nvim-treesitter").install(to_install) end

    -- nvim-treesitter installs parsers but does not start highlighting
    local filetypes = {}
    for _, lang in ipairs(languages) do
        vim.list_extend(filetypes, vim.treesitter.language.get_filetypes(lang))
    end
    Config.new_autocmd(
        "FileType",
        filetypes,
        function() vim.treesitter.start() end,
        "Start tree-sitter highlighting"
    )
end)
