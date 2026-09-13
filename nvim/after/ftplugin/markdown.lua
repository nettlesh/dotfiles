vim.cmd("setlocal spell wrap") -- Check spelling and fit long lines on screen

-- Prefer mini.basics' gO over the built-in table of contents
vim.keymap.del("n", "gO", { buffer = 0 })
