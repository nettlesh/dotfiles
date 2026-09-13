-- NOTE: Leader must exist before keymaps.lua
vim.g.mapleader = " "

-- Share helpers between configuration files
_G.Config = {}

-- Register an action to run when an editor event occurs
local group = vim.api.nvim_create_augroup("custom-config", {})
Config.new_autocmd = function(event, pattern, callback, desc)
    vim.api.nvim_create_autocmd(event, {
        group = group,
        pattern = pattern,
        callback = callback,
        desc = desc,
    })
end

-- Run a callback when vim.pack installs, updates, or deletes a plugin
Config.on_packchanged = function(plugin_name, kinds, callback, desc)
    local f = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then
            return
        end
        if not ev.data.active then vim.cmd.packadd(plugin_name) end
        callback(ev.data)
    end
    Config.new_autocmd("PackChanged", "*", f, desc)
end

vim.pack.add({
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/stevearc/conform.nvim",
    "https://github.com/rafamadriz/friendly-snippets",
})

-- NOTE: mini.misc must be available before defining the loading helpers
local misc = require("mini.misc")

-- Each helper reports setup errors as warnings
-- now: Run immediately
-- later: Queue setup to run shortly afterward, in the order added
-- now_if_args: Run now when starting with files to open; otherwise queue setup
Config.now = function(f) misc.safely("now", f) end
Config.later = function(f) misc.safely("later", f) end
Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later

-- Native options run before the numbered files in plugin/
require("options")
require("theme")
require("keymaps")
