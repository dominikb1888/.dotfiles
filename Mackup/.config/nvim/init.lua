-- Imports
require('plugins')

-- Aliases
local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local o = vim.o
local bo = vim.bo
local wo = vim.wo
-- Note that we are using 'vimp' (not 'vim') below to add the maps
-- vimp is shorthand for vimpeccable
local vimp = require('vimp')

-- Functions
local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Config
--wo.fillchrs = wo.fillchrs + 'vert:\\' -- Removes pipes | that act as seperators on splits
-- o.spelllang= { 'de_de', 'en_us' }   -- Deutsche und englische Rechtschreibung
--bo.iskeyword = bo.iskeyword .. '-'  --dash separated keywords as words
--o.path = o.path .. '**'      -- Damit kann mit :find alles, auch in Subfolder gefunden werden

o.cc = '80'          -- Markierung 80 Zeilen-Rand
o.clipboard= 'unnamed'  	-- Standard-Reuister (yy, dd, etc) IMMER in Zwischenablage kopieren 
o.cmdheight = 2     -- Mehr Platz für Statusmeldungen
o.completeopt = 'menuone,noinsert,noselect'  -- set completeopt to have a better completion experience
o.cursorline = true     -- Aktive Zeile markieren
o.encoding = 'utf-8'   -- Encoding displayed 
o.expandtab = true           -- Tabs in Spaces wandeln
o.fileencoding = 'utf-8' --Encoding saved
o.helplang = 'de'             -- Deutsche Hilfe
o.hidden = true        -- Needed to keep multiple buffers open
o.ignorecase = true    -- Suche nicht Case-Sensentiv
o.incsearch = true      -- incremental search
o.joinspaces = false    -- no double spaces with join
o.laststatus = 2    -- Statuszeile immer anzeigen
o.lazyredraw = true      			-- Weniger Redraws bei Macros und co.
o.linebreak = true		       		-- Ganze Wörter in neue Zeile umbrechen
o.list = true
o.matchtime = 3
o.mouse = 'a'        			-- Scrollen mit der Mouse in Console und tmux
o.pumheight = 8      				-- Smaller Pop-up Menu
o.ruler = true				-- show cursor position all the time
o.scrolloff = 5				-- Cursor bei Scroll weiter oben halten
o.shiftwidth = 2 				-- Nur zwei Tab-Stopp einfügen
o.shortmess = o.shortmess .. 'c' -- avoid showing message extra message when using completion
o.showmatch = true
o.showmode = true			        -- Aktuellen Modus in Statuszeile anzeigen
o.smartcase = true     -- Aber wenn Großbuchstaben verwenden werden dann schon
o.softtabstop = 2
o.splitbelow = true
o.splitright = true
o.tabstop = 2
o.termguicolors = true     -- Wenn Farben nicht passen, dann die Zeile auskommentieren (z.B. macOS Terminal)	
o.updatetime = 300  -- Schellere Darstellung	/ Refresh
o.wildmode = 'list,longest' -- command-line completion mode
o.wildmenu = true
o.wildoptions = 'pum'

wo.number = true         			-- Line Numbers anzeigen
wo.relativenumber = true  			-- Relative Nummerierung anzeigen
wo.signcolumn = 'yes'

-- Text behaviour
-- o.formatoptions = o.formatoptions
--                    + 't'    -- auto-wrap text using textwidth
--                    + 'c'    -- auto-wrap comments using textwidth
--                    - 'r'    -- auto insert comment leader on pressing enter
--                    - 'o'    -- don't insert comment leader on pressing o
--                    + 'q'    -- format comments with gq
--                    - 'a'    -- don't autoformat the paragraphs (use some formatter instead)
--                    + 'n'    -- autoformat numbered list
--                    - '2'    -- I am a programmer and not a writer
--                    + 'j'    -- Join comments smartly
o.formatoptions = o.formatoptions .. 'tcqnj'

-- Spellcheck
cmd('autocmd FileType text setlocal spell')       -- Spell bei allgemeinen Textfiles aktivieren
cmd('autocmd FileType markdown setlocal spell')   -- Spell bei Markdown aktivieren

-- Colors
cmd('colorscheme gruvbox')

-- Mappings
g['mapleader'] = ',' 		-- Komma-Taste als Leader
g['maplocalleader'] = ',,' 	-- Leertaste als Local Leader

-- Insert Mode
map('', '<up>', '<nop>')                        -- Make me stop using arrow keys
map('', '<down>', '<nop>')
map('', '<left>', '<nop>')
map('', '<right>', '<nop>')
map('i', 'jk', '<ESC>')                         -- exit insert mode with j and k
map('i', 'JK', '<ESC>')
map('i', 'jK', '<ESC>')
map('v', 'jk', '<ESC>')
map('v', 'JK', '<ESC>')
map('v', 'jK', '<ESC>')

-- Yank Highlight
cmd('au TextYankPost * lua vim.highlight.on_yank {on_visual = false}')

-- Files
map('n', '<leader>S', ':LoadLastSession<CR>')     -- Lade letzte Session

-- Splits - deactivated overrules digraph mapping <c-k>
map('', '<silent> <C-Left>', ':vertical resize +3<CR>')  -- Make adjusing split sizes a bit more friendly
map('', '<silent> <C-Right>', ':vertical resize -3<CR>')
map('n', '<silent> <C-Up>', ':resize +3<CR>')
map('n', '<silent> <C-Down>', ':resize -3<CR>')
map('n', '<Leader>th', '<C-w>t<C-w>H') -- Change 2 split windows from vert to horiz or horiz to vert
map('n', '<Leader>tk', '<C-w>t<C-w>K')

-- Terminals and REPLs
map('n', '<Leader>tr', ':new term://zsh<CR>iR<CR><C-\\><C-n><C-w>k')
map('n', '<Leader>tp', ':new term://zsh<CR>ipython3<CR><C-\\><C-n><C-w>k')
map('n', '<Leader>td', ':new term://zsh<CR>isqlite3<CR><C-\\><C-n><C-w>k')


-- Tabs
map('n', 'th',  ':tabfirst<CR>')
map('n', 'tk',  ':tabnext<CR>')
map('n', 'tj',  ':tabprev<CR>')
map('n', 'tl',  ':tablast<CR>')
map('n', 'tt',  ':tabedit<Space>')
map('n', 'tn',  ':tabnext<Space>')
map('n', 'tm',  ':tabm<Space>')
map('n', 'td',  ':tabclose<CR>')

-- Buffer
map('n', '<silent> <localleader>k', ':bp!<CR>')
map('n', '<silent> <localleader>j', ':bn!<CR>')

-- Bei Wrap-Zeilen in den Zeilen blättern und nicht in Blöcken
map('n', '<silent> <A-Down>', 'gj')
map('n', '<silent> <A-Up>', 'gk')

-- Wrap an-/ausschalten
map('n', '<silent> <leader>w', ':set wrap!<CR>')

-- copy, cut and paste direkt in Zwischenablage
map('v', '<C-c>', '"+y')
map('v', '<C-x>', '"+c')
map('v', '<C-v>', 'c<ESC>"+p')
map('i', '<C-v>', '<ESC>"+pa')

-- Sonstiges -> vimp is from vimpeccable
vimp.nnoremap('<leader>c', ':vsplit ~/.config/nvim/init.lua<CR>') -- Config direkt öffnen
-- r = reload vimrc
vimp.nnoremap('<leader>r', function()
  -- Remove all previously added vimpeccable maps
  vimp.unmap_all()
  -- Unload the lua namespace so that the next time require('config.X') is called
  -- it will reload the file
  require("config.util").unload_lua_namespace('config')
  -- Make sure all open buffers are saved
  vim.cmd('silent wa')
  -- Execute our vimrc lua file again to add back our maps
  dofile(vim.fn.stdpath('config') .. '/init.lua')

  print("Reloaded vimrc!")
end)


cmd('command! W w') -- Weil ich Depp mich ständig vertippe
cmd('command! Q q') -- Weil ich Depp mich ständig vertippe

-- 5 Best remappings
-- Keep search results centered
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')
map('n', 'J', 'mzJ`z')

-- Undo break points
map('i', ',', ',<c-g>u')
map('i', '.', '.<c-g>u')
map('i', '!', '!<c-g>u')
map('i', '?', '?<c-g>u')

-- Moving Text
map('v', '<A-j>', ':m ">+1<CR>gv=gv')
map('v', '<A-k>', ':m ">-2<CR>gv=gv')
map('i', '<A-j>', '<esc>:m .+1<CR>==')
map('i', '<A-k>', '<esc>:m .-2<CR>==')
map('n', '<A-k>', ':m .-2<CR>==')
map('n', '<A-j>', ':m .+1<CR>==')

-- Auto indent whole file
map('n', '<Leader><tab>', '<esc>gg=G<C-o><C-o>zz')
map('x', '>', '>gv')  -- keep selection when indenting in visual mode
map('x', '<', '<gv')

-- Python
g['python3_host_skip_check'] = 1
map('n', '<buffer> H', ':<C-u>execute "!pydoc3 " . expand("<cword>")<CR>')

-- LSP
map('n', 'gd', ':lua vim.lsp.buf.definition()<CR>')
map('n', 'gD', ':lua vim.lsp.buf.declaration()<CR>')
map('n', 'gi', ':lua vim.lsp.buf.implementation()<CR>')
map('n', 'gw', ':lua vim.lsp.buf.document_symbol()<CR>')
map('n', 'gW', ':lua vim.lsp.buf.workspace_symbol()<CR>')
map('n', 'gr', ':lua vim.lsp.buf.references()<CR>')
map('n', 'gt', ':lua vim.lsp.buf.type_definition()<CR>')
map('n', 'K', ':lua vim.lsp.buf.hover()<CR>')
map('n', '<c-k>', ':lua vim.lsp.buf.signature_help()<CR>')
map('n', '<leader>af', ':lua vim.lsp.buf.code_action()<CR>')
map('n', '<leader>rn', ':lua vim.lsp.buf.rename()<CR>')

map("n", "<Leader>cf", ":Lspsaga lsp_finder<CR>", { silent = true })
map("n", "<leader>ca", ":Lspsaga code_action<CR>", { silent = true })
map("v", "<leader>ca", ":<C-U>Lspsaga range_code_action<CR>", { silent = true })
map("n", "<leader>ch", ":Lspsaga hover_doc<CR>", { silent = true })
map("n", "<leader>ck", '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(-1)<CR>', { silent = true })
map("n", "<leader>cj", '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(1)<CR>', { silent = true })
map("n", "<leader>cs", ":Lspsaga signature_help<CR>", { silent = true })
map("n", "<leader>ci", ":Lspsaga show_line_diagnostics<CR>", { silent = true })
map("n", "<leader>cn", ":Lspsaga diagnostic_jump_next<CR>", { silent = true })
map("n", "<leader>cp", ":Lspsaga diagnostic_jump_prev<CR>", { silent = true })
map("n", "<leader>cr", ":Lspsaga rename<CR>", { silent = true })
map("n", "<leader>cd", ":Lspsaga preview_definition<CR>", { silent = true })

-- Fuzzy Finding
map('n', '<leader>ff', ':lua require"telescope.builtin".find_files({find_command = { "rg", "--files", "--hidden", "--follow"}})<CR>')
map('n', '<leader>fs', ':lua require"telescope.builtin".live_grep({find_command = { "rg", "--files", "--hidden", "--follow"}})<CR>')
map('n', '<leader>fg', ':lua require"telescope.builtin".git_files()<CR>')
map('n', '<leader>fh', ':lua require"telescope.builtin".help_tags()<CR>')
map('n', '<leader>fb', ':lua require"telescope.builtin".buffers()<CR>')
map('n', '<leader>ft', ':lua require"telescope.builtin".file_browser()<CR>')

-- Code Completion
-- Use <Tab> and <S-Tab> to navigate through popup menu
map('i', '<tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})
map('i', '<s-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})

-- chain completion list
g.completion_enable_snippet = 'UltiSnips'
g.completion_chain_complete_list = {
            default = {
              default = {
                  { complete_items = { 'lsp', 'snippet' }},
                  { mode = '<c-p>'},
                  { mode = '<c-n>'}},
              comment = {},
              string = { { complete_items = { 'path' }} }}}


-- Yank
map('n', 'Y', 'y$') -- Yank complete Line

vim.api.nvim_exec( -- Highlight on yank
  [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]],
  false
)
