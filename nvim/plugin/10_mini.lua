-- Set up the initial UI now and queue editing features afterward
local now, now_if_args, later = Config.now, Config.now_if_args, Config.later

-- mini.basics
now(function()
    -- mini.basics preserves options already set in options.lua and theme.lua
    require("mini.basics").setup({
        options = { extra_ui = true },
        mappings = { windows = true, move_with_alt = true },
    })
end)

-- mini.icons
now(function()
    -- Let filetype detection choose icons for these generic extensions
    local ext3_blocklist = { scm = true, txt = true, yml = true }
    local ext4_blocklist = { json = true, yaml = true }
    require("mini.icons").setup({
        use_file_extension = function(ext, _)
            return not (
                ext3_blocklist[ext:sub(-3)] or ext4_blocklist[ext:sub(-4)]
            )
        end,
    })

    -- Add icons beside completion and symbol kinds after the initial UI loads
    later(MiniIcons.tweak_lsp_kind)
end)

-- mini.notify
now(function() require("mini.notify").setup() end)

-- mini.sessions
now(function() require("mini.sessions").setup() end)

-- mini.starter
now(function() require("mini.starter").setup() end)

-- mini.statuscolumn
now(function() require("mini.statuscolumn").setup() end)

-- mini.statusline
now(function() require("mini.statusline").setup() end)

-- mini.tabline
now(function() require("mini.tabline").setup() end)

-- mini.completion
now_if_args(function()
    -- Hide generic text suggestions and put snippets last
    local process_items_opts = { kind_priority = { Text = -1, Snippet = 99 } }
    local process_items = function(items, base)
        return MiniCompletion.default_process_items(
            items,
            base,
            process_items_opts
        )
    end
    require("mini.completion").setup({
        lsp_completion = {
            source_func = "omnifunc", -- Use the buffer's language completion
            auto_setup = false, -- Connect completion when a server attaches
            process_items = process_items,
        },
    })

    local on_attach = function(ev)
        vim.bo[ev.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
    end
    Config.new_autocmd(
        "LspAttach",
        nil,
        on_attach,
        "Connect Mini completion to the language server"
    )

    -- NOTE: Advertise completion support before language servers start
    vim.lsp.config(
        "*",
        { capabilities = MiniCompletion.get_lsp_capabilities() }
    )
end)

-- mini.files
now_if_args(function()
    require("mini.files").setup({ windows = { preview = true } })

    -- Keep file panes wide when navigating between compact directory panes
    Config.new_autocmd("User", "MiniFilesWindowUpdate", function(ev)
        local state = MiniFiles.get_explorer_state()
        for _, window in ipairs(state.windows) do
            if
                window.win_id == ev.data.win_id
                and vim.fn.isdirectory(window.path) == 0
            then
                local config = vim.api.nvim_win_get_config(window.win_id)
                config.width = math.min(80, vim.o.columns - config.col - 2)
                vim.api.nvim_win_set_config(window.win_id, config)
            end
        end
    end, "Widen file previews without widening directory previews")

    -- Jump to these directories with 'c, 'p, and 'w inside the explorer
    local add_marks = function()
        MiniFiles.set_bookmark(
            "c",
            vim.fn.stdpath("config"),
            { desc = "Config" }
        )
        local vimpack_plugins = vim.fn.stdpath("data") .. "/site/pack/core/opt"
        MiniFiles.set_bookmark("p", vimpack_plugins, { desc = "Plugins" })
        MiniFiles.set_bookmark(
            "w",
            vim.fn.getcwd,
            { desc = "Working directory" }
        )
    end
    Config.new_autocmd(
        "User",
        "MiniFilesExplorerOpen",
        add_marks,
        "Add bookmarks"
    )
end)

-- mini.misc
now_if_args(function()
    require("mini.misc").setup() -- Expose MiniMisc and value-printing helpers
    MiniMisc.setup_auto_root() -- Work from the current file's project directory
    MiniMisc.setup_restore_cursor() -- Reopen files at the last cursor position
end)

-- mini.extra
later(function() require("mini.extra").setup() end)

-- mini.ai
later(function()
    local ai = require("mini.ai")
    ai.setup({
        custom_textobjects = {
            B = MiniExtra.gen_ai_spec.buffer(), -- aB/iB select the whole buffer
        },
        search_method = "cover", -- Only select objects around the cursor
    })
end)

-- mini.align
later(function() require("mini.align").setup() end)

-- mini.bracketed
later(function()
    -- NOTE: mini.indentscope owns [i and ]i
    require("mini.bracketed").setup({ indent = { suffix = "" } })
end)

-- mini.bufremove
later(function() require("mini.bufremove").setup() end)

-- mini.clue
later(function()
    local miniclue = require("mini.clue")
    miniclue.setup({
        clues = {
            Config.leader_group_clues,
            miniclue.gen_clues.builtin_completion(),
            miniclue.gen_clues.g(),
            miniclue.gen_clues.marks(),
            miniclue.gen_clues.registers(),
            miniclue.gen_clues.square_brackets(),
            -- Keep resizing with +, -, <, or > after the first Ctrl-W
            miniclue.gen_clues.windows({ submode_resize = true }),
            miniclue.gen_clues.z(),
        },
        triggers = {
            { mode = { "n", "x" }, keys = "<Leader>" },
            { mode = "n", keys = "\\" }, -- mini.basics toggles
            { mode = { "n", "x" }, keys = "[" }, -- mini.bracketed
            { mode = { "n", "x" }, keys = "]" },
            { mode = "i", keys = "<C-x>" }, -- Built-in completion
            { mode = { "n", "x" }, keys = "g" },
            { mode = { "n", "x" }, keys = "'" }, -- Marks
            { mode = { "n", "x" }, keys = "`" },
            { mode = { "n", "x" }, keys = '"' }, -- Registers
            { mode = { "i", "c" }, keys = "<C-r>" },
            { mode = "n", keys = "<C-w>" },
            { mode = { "n", "x" }, keys = "s" }, -- mini.surround
            { mode = { "n", "x" }, keys = "z" },
        },
        window = {
            delay = 250, -- Wait a quarter second before showing clues
            config = { width = "auto" }, -- Fit the descriptions
        },
    })

    -- MiniFiles directory buffers need their clue triggers enabled explicitly
    Config.new_autocmd(
        "FileType",
        "minifiles",
        function(ev) miniclue.ensure_buf_triggers(ev.buf) end,
        "Enable clue menus in MiniFiles"
    )
end)

-- mini.cmdline
later(function() require("mini.cmdline").setup() end)

-- mini.comment
later(function() require("mini.comment").setup() end)

-- mini.cursorword
later(function() require("mini.cursorword").setup() end)

-- mini.diff
later(function() require("mini.diff").setup() end)

-- mini.git
later(function() require("mini.git").setup() end)

-- mini.hipatterns
later(function()
    local hipatterns = require("mini.hipatterns")
    local hi_words = MiniExtra.gen_highlighter.words
    hipatterns.setup({
        highlighters = {
            fixme = hi_words(
                { "FIXME", "Fixme", "fixme" },
                "MiniHipatternsFixme"
            ),
            hack = hi_words({ "HACK", "Hack", "hack" }, "MiniHipatternsHack"),
            todo = hi_words({ "TODO", "Todo", "todo" }, "MiniHipatternsTodo"),
            note = hi_words({ "NOTE", "Note", "note" }, "MiniHipatternsNote"),
            hex_color = hipatterns.gen_highlighter.hex_color(),
        },
    })
end)

-- mini.indentscope
later(function() require("mini.indentscope").setup() end)

-- mini.input
later(function() require("mini.input").setup() end)

-- mini.jump
later(function() require("mini.jump").setup() end)

-- mini.jump2d
later(function() require("mini.jump2d").setup() end)

-- mini.keymap
later(function() require("mini.keymap").setup() end)

-- mini.map
later(function()
    local map = require("mini.map")
    map.setup({
        integrations = {
            map.gen_integration.builtin_search(),
            map.gen_integration.diff(),
            map.gen_integration.diagnostic(),
        },
        window = { winblend = Config.theme.blend },
    })
end)

-- mini.move
later(function() require("mini.move").setup() end)

-- mini.operators
later(function() require("mini.operators").setup() end)

-- mini.pairs
later(function()
    -- Pair brackets when typing commands too
    require("mini.pairs").setup({ modes = { command = true } })
end)

-- mini.pick
later(function() require("mini.pick").setup() end)

-- mini.snippets
later(function()
    local latex_patterns = { "latex/**/*.json", "**/latex.json" }
    local lang_patterns = {
        tex = latex_patterns,
        plaintex = latex_patterns,
        markdown_inline = { "markdown.json" },
    }

    local snippets = require("mini.snippets")
    local config_path = vim.fn.stdpath("config")
    snippets.setup({
        snippets = {
            -- Personal snippets available in every language, if the file exists
            snippets.gen_loader.from_file(
                config_path .. "/snippets/global.json"
            ),
            -- Load language snippets from the config and friendly-snippets
            snippets.gen_loader.from_lang({ lang_patterns = lang_patterns }),
        },
    })
end)

-- mini.splitjoin
later(function() require("mini.splitjoin").setup() end)

-- mini.surround
later(function() require("mini.surround").setup() end)

-- mini.trailspace
later(function() require("mini.trailspace").setup() end)

-- mini.visits
later(function() require("mini.visits").setup() end)
