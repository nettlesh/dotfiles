Config.later(function()
    require("conform").setup({
        default_format_opts = {
            lsp_format = "fallback", -- Use LSP when no formatter is available
        },
        format_on_save = function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
            end
            -- Shorter than the 1000ms default so saving stays responsive
            return { timeout_ms = 500 }
        end,
        formatters_by_ft = {
            lua = { "stylua" }, -- Match the formatter already managed by mise
        },
    })

    vim.api.nvim_create_user_command("FormatDisable", function(args)
        -- A bang disables formatting for the current buffer only
        if args.bang then
            vim.b.disable_autoformat = true
        else
            vim.g.disable_autoformat = true
        end
    end, { desc = "Disable format on save", bang = true })

    vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
    end, { desc = "Re-enable format on save" })
end)
