vim.keymap.set("n", "<leader>s", ":call VimCmdLineStartApp()<cr>")

-- Split the window horizontally or vertically.
vim.g.cmdline_vsplit = 0
-- Remap <Esc> to :stopinsert in Neovim terminal.
vim.g.cmdline_esc_term = 1
-- Start the interpreter in a Neovim buffer.
vim.g.cmdline_in_buffer = 1
-- Initial height of interpreter window or pane.
vim.g.cmdline_term_height = 20
-- Initial width of interpreter window or pane.
vim.g.cmdline_term_width = 80
-- Temporary directory to save files.
vim.g.cmdline_tmp_dir = "/tmp"
-- Syntax highlight the output.
vim.g.cmdline_outhl = 1
-- Override default for Python.
vim.g.cmdline_app = { python = "ipython -i -c 'from rich import print, pretty; pretty.install()'" }

-- if &t_Co == 256
--     let cmdline_color_input = 247
--     let cmdline_color_normal = 39
--     let cmdline_color_number = 51
--     let cmdline_color_integer = 51
--     let cmdline_color_float = 51
--     let cmdline_color_complex = 51
--     let cmdline_color_negnum = 183
--     let cmdline_color_negfloat = 183
--     let cmdline_color_date = 43
--     let cmdline_color_true = 78
--     let cmdline_color_false = 203
--     let cmdline_color_inf = 39
--     let cmdline_color_constant = 75
--     let cmdline_color_string = 79
--     let cmdline_color_stderr = 33
--     let cmdline_color_error = 15
--     let cmdline_color_warn = 1
--     let cmdline_color_index = 186
-- endif

-- Use whatever default color scheme
vim.g.cmdline_follow_colorscheme = 1
