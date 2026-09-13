-- Handwritten mappings and leader groups; plugin presets live in plugin/
local map = vim.keymap.set

map("n", "<Esc>", "<Cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

map("n", "<C-d>", "<C-d>zz", { desc = "Half page down, centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up, centered" })

-- Refresh search markers without redrawing the whole map
local refresh = "<Cmd>lua MiniMap.refresh({}, "
    .. "{ lines = false, scrollbar = false })<CR>"
map("n", "n", "nzzzv" .. refresh, { desc = "Next match, centered" })
map("n", "N", "Nzzzv" .. refresh, { desc = "Previous match, centered" })
map("n", "*", "*zv" .. refresh, { desc = "Search word forward" })
map("n", "#", "#zv" .. refresh, { desc = "Search word backward" })

map("n", "J", "mzJ`z", { desc = "Join lines, keep cursor" })

map("x", "<", "<gv", { desc = "Dedent, keep selection" })
map("x", ">", ">gv", { desc = "Indent, keep selection" })

map("t", "<Esc>", "<C-\\><C-n>", { desc = "Terminal to Normal mode" })

-- Joins mini.basics' \ toggles, which echo the new value the same way
local toggle_format = function(scope)
    return function()
        scope.disable_autoformat = not scope.disable_autoformat
        print(scope.disable_autoformat and "noformatonsave" or "  formatonsave")
    end
end
map("n", "\\f", toggle_format(vim.g), { desc = "Toggle format on save" })
map(
    "n",
    "\\F",
    toggle_format(vim.b),
    { desc = "Toggle format on save (buffer)" }
)

-- Group names used by mini.clue
Config.leader_group_clues = {
    { mode = "n", keys = "<Leader>b", desc = "+Buffer" },
    { mode = "n", keys = "<Leader>E", desc = "+Explore/Edit" },
    { mode = "n", keys = "<Leader>f", desc = "+Find" },
    { mode = "n", keys = "<Leader>g", desc = "+Git" },
    { mode = "n", keys = "<Leader>l", desc = "+Language" },
    { mode = "n", keys = "<Leader>m", desc = "+Map" },
    { mode = "n", keys = "<Leader>o", desc = "+Other" },
    { mode = "n", keys = "<Leader>s", desc = "+Session" },
    { mode = "n", keys = "<Leader>t", desc = "+Terminal" },
    { mode = "n", keys = "<Leader>v", desc = "+Visits" },

    { mode = "x", keys = "<Leader>g", desc = "+Git" },
    { mode = "x", keys = "<Leader>l", desc = "+Language" },
}

-- Leader helpers keep every mapping paired with its description
local nmap_leader = function(suffix, rhs, desc)
    vim.keymap.set("n", "<Leader>" .. suffix, rhs, { desc = desc })
end
local xmap_leader = function(suffix, rhs, desc)
    vim.keymap.set("x", "<Leader>" .. suffix, rhs, { desc = desc })
end

-- Buffer
local new_scratch_buffer = function()
    vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
end

nmap_leader("ba", "<Cmd>b#<CR>", "Alternate buffer")
nmap_leader("bd", "<Cmd>lua MiniBufremove.delete()<CR>", "Delete buffer")
nmap_leader(
    "bD",
    "<Cmd>lua MiniBufremove.delete(0, true)<CR>",
    "Delete buffer, discard changes"
)
nmap_leader("bn", "<Cmd>bnext<CR>", "Next buffer")
nmap_leader("bp", "<Cmd>bprevious<CR>", "Previous buffer")
nmap_leader("bs", new_scratch_buffer, "New scratch buffer")
nmap_leader("bw", "<Cmd>lua MiniBufremove.wipeout()<CR>", "Wipe out buffer")
nmap_leader(
    "bW",
    "<Cmd>lua MiniBufremove.wipeout(0, true)<CR>",
    "Wipe out buffer, discard changes"
)

-- Explore/Edit
-- Resolve config paths when opening them and escape spaces in directory names
local edit_config_file = function(path)
    return function()
        vim.cmd.edit(
            vim.fn.fnameescape(vim.fn.stdpath("config") .. "/" .. path)
        )
    end
end
-- NOTE: Buffers like mini.starter carry a URI that MiniFiles.open rejects
local explore_at_file = function()
    local path = vim.api.nvim_buf_get_name(0)
    MiniFiles.open(vim.fn.filereadable(path) == 1 and path or nil)
end
local explore_quickfix = function()
    vim.cmd(
        vim.fn.getqflist({ winid = true }).winid ~= 0 and "cclose" or "copen"
    )
end
local explore_locations = function()
    vim.cmd(
        vim.fn.getloclist(0, { winid = true }).winid ~= 0 and "lclose"
            or "lopen"
    )
end

nmap_leader("Ed", "<Cmd>lua MiniFiles.open()<CR>", "Explore working directory")
nmap_leader("Ef", explore_at_file, "Explore current file directory")
nmap_leader("Ei", "<Cmd>edit $MYVIMRC<CR>", "Edit init.lua")
nmap_leader("Ek", edit_config_file("lua/keymaps.lua"), "Edit keymaps")
nmap_leader(
    "Em",
    edit_config_file("plugin/10_mini.lua"),
    "Edit Mini configuration"
)
nmap_leader(
    "En",
    "<Cmd>lua MiniNotify.show_history()<CR>",
    "Notification history"
)
nmap_leader("Eo", edit_config_file("lua/options.lua"), "Edit options")
nmap_leader("Eq", explore_quickfix, "Toggle quickfix list")
nmap_leader("EQ", explore_locations, "Toggle location list")

-- Find
local pick_added_hunks_buf = '<Cmd>Pick git_hunks path="%" scope="staged"<CR>'
local pick_workspace_symbols_live =
    '<Cmd>Pick lsp scope="workspace_symbol_live"<CR>'

nmap_leader("f/", '<Cmd>Pick history scope="/"<CR>', "Repeat a previous search")
nmap_leader("f:", '<Cmd>Pick history scope=":"<CR>', "Run a previous command")
nmap_leader(
    "fa",
    '<Cmd>Pick git_hunks scope="staged"<CR>',
    "Staged changes (repository)"
)
nmap_leader("fA", pick_added_hunks_buf, "Staged changes (current file)")
nmap_leader("fb", "<Cmd>Pick buffers<CR>", "Open buffers")
nmap_leader("fc", "<Cmd>Pick git_commits<CR>", "Commits (repository)")
nmap_leader(
    "fC",
    '<Cmd>Pick git_commits path="%"<CR>',
    "Commits (current file)"
)
nmap_leader(
    "fd",
    '<Cmd>Pick diagnostic scope="all"<CR>',
    "Diagnostics (all buffers)"
)
nmap_leader(
    "fD",
    '<Cmd>Pick diagnostic scope="current"<CR>',
    "Diagnostics (current buffer)"
)
nmap_leader("ff", "<Cmd>Pick files<CR>", "Files")
nmap_leader("fg", "<Cmd>Pick grep_live<CR>", "Search text across files")
nmap_leader(
    "fG",
    '<Cmd>Pick grep pattern="<cword>"<CR>',
    "Search files for current word"
)
nmap_leader("fh", "<Cmd>Pick help<CR>", "Help tags")
nmap_leader("fH", "<Cmd>Pick hl_groups<CR>", "Inspect highlight groups")
nmap_leader("fl", '<Cmd>Pick buf_lines scope="all"<CR>', "Lines (all buffers)")
nmap_leader(
    "fL",
    '<Cmd>Pick buf_lines scope="current"<CR>',
    "Lines (current buffer)"
)
nmap_leader("fm", "<Cmd>Pick git_hunks<CR>", "Unstaged changes (repository)")
nmap_leader(
    "fM",
    '<Cmd>Pick git_hunks path="%"<CR>',
    "Unstaged changes (current file)"
)
nmap_leader("fr", "<Cmd>Pick resume<CR>", "Resume last picker")
nmap_leader("fR", '<Cmd>Pick lsp scope="references"<CR>', "Symbol references")
nmap_leader("fs", pick_workspace_symbols_live, "Workspace symbols")
nmap_leader(
    "fS",
    '<Cmd>Pick lsp scope="document_symbol"<CR>',
    "Document symbols"
)
nmap_leader(
    "fv",
    '<Cmd>Pick visit_paths cwd=""<CR>',
    "Visited paths (everywhere)"
)
nmap_leader(
    "fV",
    "<Cmd>Pick visit_paths<CR>",
    "Visited paths (working directory)"
)

-- Git
local git_log_cmd = [[Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order]]
local git_log_buf_cmd = git_log_cmd .. " --follow -- %"

nmap_leader("ga", "<Cmd>Git diff --cached<CR>", "Staged diff (repository)")
nmap_leader(
    "gA",
    "<Cmd>Git diff --cached -- %<CR>",
    "Staged diff (current file)"
)
nmap_leader("gc", "<Cmd>Git commit<CR>", "Commit")
nmap_leader("gC", "<Cmd>Git commit --amend<CR>", "Amend latest commit")
nmap_leader("gd", "<Cmd>Git diff<CR>", "Unstaged diff (repository)")
nmap_leader("gD", "<Cmd>Git diff -- %<CR>", "Unstaged diff (current file)")
nmap_leader(
    "gl",
    "<Cmd>" .. git_log_cmd .. "<CR>",
    "Commit history (repository)"
)
nmap_leader(
    "gL",
    "<Cmd>" .. git_log_buf_cmd .. "<CR>",
    "Commit history (current file)"
)
nmap_leader(
    "go",
    "<Cmd>lua MiniDiff.toggle_overlay()<CR>",
    "Toggle inline diff"
)
nmap_leader("gs", "<Cmd>lua MiniGit.show_at_cursor()<CR>", "Show at cursor")

xmap_leader("gs", "<Cmd>lua MiniGit.show_at_cursor()<CR>", "Show at selection")

-- Language
-- NOTE: mini.operators owns gr, so LSP actions use the Language group
nmap_leader("la", "<Cmd>lua vim.lsp.buf.code_action()<CR>", "Code actions")
nmap_leader(
    "ld",
    "<Cmd>lua vim.diagnostic.open_float()<CR>",
    "Diagnostic details"
)
nmap_leader("lf", '<Cmd>lua require("conform").format()<CR>', "Format buffer")
nmap_leader(
    "li",
    "<Cmd>lua vim.lsp.buf.implementation()<CR>",
    "Go to implementation"
)
nmap_leader("lh", "<Cmd>lua vim.lsp.buf.hover()<CR>", "Hover documentation")
nmap_leader("ll", "<Cmd>lua vim.lsp.codelens.run()<CR>", "Run code lens")
nmap_leader("lr", "<Cmd>lua vim.lsp.buf.rename()<CR>", "Rename symbol")
nmap_leader("lR", "<Cmd>lua vim.lsp.buf.references()<CR>", "Find references")
nmap_leader("ls", "<Cmd>lua vim.lsp.buf.definition()<CR>", "Go to definition")
nmap_leader(
    "lt",
    "<Cmd>lua vim.lsp.buf.type_definition()<CR>",
    "Go to type definition"
)

xmap_leader(
    "la",
    "<Cmd>lua vim.lsp.buf.code_action()<CR>",
    "Code actions for selection"
)
xmap_leader(
    "lf",
    '<Cmd>lua require("conform").format()<CR>',
    "Format selection"
)

-- Map
nmap_leader("mf", "<Cmd>lua MiniMap.toggle_focus()<CR>", "Toggle map focus")
nmap_leader("mr", "<Cmd>lua MiniMap.refresh()<CR>", "Refresh map")
nmap_leader("ms", "<Cmd>lua MiniMap.toggle_side()<CR>", "Switch map side")
nmap_leader("mt", "<Cmd>lua MiniMap.toggle()<CR>", "Toggle map")

-- Other
nmap_leader(
    "or",
    "<Cmd>lua MiniMisc.resize_window()<CR>",
    "Resize to editable width"
)
nmap_leader(
    "ot",
    "<Cmd>lua MiniTrailspace.trim()<CR>",
    "Remove trailing whitespace"
)
nmap_leader("oz", "<Cmd>lua MiniMisc.zoom()<CR>", "Toggle zoom")

-- Session
local session_new =
    'vim.ui.input({ prompt = "Session name: " }, MiniSessions.write)'

nmap_leader(
    "sd",
    '<Cmd>lua MiniSessions.select("delete")<CR>',
    "Delete session"
)
nmap_leader("sn", "<Cmd>lua " .. session_new .. "<CR>", "New session")
nmap_leader("sr", '<Cmd>lua MiniSessions.select("read")<CR>', "Restore session")
nmap_leader("sR", "<Cmd>lua MiniSessions.restart()<CR>", "Restart with session")
nmap_leader("sw", "<Cmd>lua MiniSessions.write()<CR>", "Save current session")

-- Terminal
nmap_leader("tT", "<Cmd>horizontal term<CR>", "Terminal (stacked split)")
nmap_leader("tt", "<Cmd>vertical term<CR>", "Terminal (side-by-side split)")

-- Visits
-- Favorites use MiniMax's "core" label and are sorted by recent use
local make_pick_core = function(cwd, desc)
    return function()
        local sort_latest = MiniVisits.gen_sort.default({ recency_weight = 1 })
        local local_opts = { cwd = cwd, filter = "core", sort = sort_latest }
        MiniExtra.pickers.visit_paths(local_opts, { source = { name = desc } })
    end
end

nmap_leader(
    "vc",
    make_pick_core("", "Favorites (everywhere)"),
    "Favorites (everywhere)"
)
nmap_leader(
    "vC",
    make_pick_core(nil, "Favorites (working directory)"),
    "Favorites (working directory)"
)
nmap_leader("vv", '<Cmd>lua MiniVisits.add_label("core")<CR>', "Add favorite")
nmap_leader(
    "vV",
    '<Cmd>lua MiniVisits.remove_label("core")<CR>',
    "Remove favorite"
)
nmap_leader("vl", "<Cmd>lua MiniVisits.add_label()<CR>", "Add label")
nmap_leader("vL", "<Cmd>lua MiniVisits.remove_label()<CR>", "Remove label")

-- Direct shortcuts
map("n", "<Leader>e", explore_at_file, { desc = "Explore files" })
map("n", "<Leader>Q", "<Cmd>quitall<CR>", { desc = "Quit Neovim" })

-- NOTE: This helper can create mappings before mini.keymap.setup()
local map_multistep = require("mini.keymap").map_multistep
map_multistep(
    "i",
    "<Tab>",
    { "pmenu_next" },
    { desc = "Next suggestion or Tab" }
)
map_multistep(
    "i",
    "<S-Tab>",
    { "pmenu_prev" },
    { desc = "Previous suggestion or Shift-Tab" }
)
map_multistep("i", "<CR>", { "pmenu_accept", "minipairs_cr" }, {
    desc = "Accept suggestion or start a new line",
})
map_multistep(
    "i",
    "<BS>",
    { "minipairs_bs" },
    { desc = "Backspace with empty pair removal" }
)
