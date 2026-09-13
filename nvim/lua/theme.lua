Config.theme = {
    background = "#282c34", -- Background seed for mini.hues
    foreground = "#ffffff", -- Text seed for mini.hues
    transparent = true, -- Let the terminal background show through
    transparent_floats = true, -- Use the terminal background in popups too
    blend = 0, -- Keep floating windows and completion menus unblended
    border = "single", -- Outline popups with a thin border
}

local theme = Config.theme

-- Set blending before mini.basics so its presets preserve it
vim.o.winblend = theme.blend
vim.o.pumblend = theme.blend
vim.o.winborder = theme.border
vim.o.pumborder = theme.border

-- mini.hues and mini.colors
Config.now(function()
    -- These seeds are independent of the active terminal theme
    require("mini.hues").setup({
        background = theme.background,
        foreground = theme.foreground,
    })

    -- Keep status bars solid while applying the chosen background transparency
    local scheme = require("mini.colors").get_colorscheme()
    scheme
        :add_transparency({
            general = theme.transparent,
            float = theme.transparent_floats,
        })
        :apply()

    if not theme.transparent_floats then return end

    -- NOTE: These groups retain floating backgrounds after add_transparency
    local float_extras = {
        "MiniFilesTitleFocused",
        "DiagnosticFloatingError",
        "DiagnosticFloatingWarn",
        "DiagnosticFloatingInfo",
        "DiagnosticFloatingHint",
        "DiagnosticFloatingOk",
    }
    for _, group in ipairs(float_extras) do
        local hl = vim.api.nvim_get_hl(0, { name = group })
        hl.bg, hl.ctermbg, hl.blend = nil, nil, theme.blend
        vim.api.nvim_set_hl(0, group, hl)
    end
end)
