-- NOTE: Set options before mini.basics so its presets preserve them

vim.o.relativenumber = true -- Show each line's distance from the cursor

vim.o.tabstop = 4 -- Display tabs at four-column intervals
vim.o.shiftwidth = 4 -- Indent each level by four spaces
vim.o.expandtab = true -- Insert spaces when pressing Tab

vim.o.scrolloff = 8 -- Keep eight lines above and below the cursor
vim.o.sidescrolloff = 8 -- Keep eight columns beside the cursor

vim.o.swapfile = false -- Disable crash-recovery files
vim.o.confirm = true -- Ask to save before leaving unsaved changes
vim.o.showcmd = false -- Hide the brief gj/gk display when moving with j/k
vim.o.shada = "'100,<50,s10,:1000,/100,@100,h" -- Limit history read at startup
-- Sessions without empty windows, terminals, or a baked-in runtimepath
vim.o.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,skiprtp"

vim.o.inccommand = "split" -- Preview replacements, including off-screen hits
vim.o.spelloptions = "camel" -- Treat camelCase parts as separate words
vim.o.formatoptions = "rqnl1j" -- Continue comments and format lists
vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]] -- Find list starts
vim.o.breakindentopt = "list:-1" -- Align wrapped text after its list marker
vim.o.iskeyword = "@,48-57,_,192-255,-" -- Treat dashed names as one word

vim.o.completeopt = "menuone,noselect,fuzzy,nosort" -- Fuzzy match, keep order
vim.o.completetimeout = 100 -- Limit how long Ctrl-N waits on a source

vim.o.foldmethod = "expr" -- Use a rule to find collapsible sections
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Find sections from code
vim.o.foldlevel = 99 -- Leave sections open initially
vim.o.foldtext = "" -- Show the folded line with its own highlighting

vim.o.laststatus = 3 -- Share one status bar across all windows
vim.o.colorcolumn = "80" -- Mark column 80 as a writing guide
vim.o.cursorlineopt = "screenline,number" -- Highlight cursor row and number
vim.o.pummaxwidth = 100 -- Limit the suggestions menu to 100 columns

-- NOTE: Filetype plugins can restore comment wrapping and continuation on o/O
Config.new_autocmd(
    "FileType",
    nil,
    function() vim.opt_local.formatoptions:remove({ "c", "o" }) end,
    "Disable automatic comment wrapping and continuation on o/O"
)

vim.diagnostic.config({
    virtual_text = { -- Show diagnostic messages beside the code
        current_line = true, -- Show messages only on the cursor's line
        severity = vim.diagnostic.severity.ERROR, -- Show only errors inline
    },
})
