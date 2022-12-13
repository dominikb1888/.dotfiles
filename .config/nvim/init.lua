vim.cmd [[source /nix/store/4a347d2hxgdgndms62314k3s9jmyxdr0-nvim-init-home-manager.vim]]
-- bufferline.nvim
local load_bufferline_nvim = function()
if vim.g.vscode == nil then
vim.cmd 'packadd bufferline.nvim'
require 'malo.bufferline-nvim'
end
end
load_bufferline_nvim()

-- galaxyline.nvim
local load_galaxyline_nvim = function()
if vim.g.vscode == nil then
vim.cmd 'packadd galaxyline.nvim'
require 'malo.galaxyline-nvim'
end
end
load_galaxyline_nvim()

-- gitsigns.nvim
local load_gitsigns_nvim = function()
if vim.g.vscode == nil then
vim.cmd 'packadd gitsigns.nvim'
require 'malo.gitsigns-nvim'
end
end
load_gitsigns_nvim()

-- goyo.vim
local load_goyo_vim = function()
if vim.g.vscode == nil then
vim.cmd 'packadd goyo.vim'
end
end
load_goyo_vim()

-- indent-blankline.nvim
local load_indent_blankline_nvim = function()
if vim.g.vscode == nil then
vim.cmd 'packadd indent-blankline.nvim'
require 'malo.indent-blankline-nvim'
end
end
load_indent_blankline_nvim()

-- telescope.nvim
local load_telescope_nvim = function()
if vim.g.vscode == nil then
vim.cmd 'packadd telescope.nvim'
require 'malo.telescope-nvim'
end
end
load_telescope_nvim()

-- octo.nvim
local load_octo_nvim = function()
if vim.g.vscode == nil then
vim.cmd 'packadd octo.nvim'
require 'malo.octo-nvim'
end
end
load_octo_nvim()

-- toggleterm.nvim
local load_toggleterm_nvim = function()
if vim.g.vscode == nil then
vim.cmd 'packadd toggleterm.nvim'
require 'malo.toggleterm-nvim'
end
end
load_toggleterm_nvim()

-- copilot.vim
local load_copilot_vim = function()
if vim.g.vscode == nil then
vim.cmd 'packadd copilot.vim'
end
end
load_copilot_vim()

-- coq_nvim
local load_coq_nvim = function()
if vim.g.vscode == nil then
require 'malo.coq_nvim'
end
end
load_coq_nvim()

-- lsp_lines.nvim
local load_lsp_lines_nvim = function()
if vim.g.vscode == nil then
vim.cmd 'packadd lsp_lines.nvim'
require'lsp_lines'.setup()
vim.diagnostic.config({ virtual_lines = { only_current_line = true } })
end
end
load_lsp_lines_nvim()

-- lspsaga.nvim
local load_lspsaga_nvim = function()
if vim.g.vscode == nil then
vim.cmd 'packadd lspsaga.nvim'
require 'malo.lspsaga-nvim'
end
end
load_lspsaga_nvim()

-- null-ls.nvim
local load_null_ls_nvim = function()
if vim.g.vscode == nil then
vim.cmd 'packadd null-ls.nvim'
require 'malo.null-ls-nvim'
end
end
load_null_ls_nvim()

-- nvim-lspconfig
local load_nvim_lspconfig = function()
if vim.g.vscode == nil then
vim.cmd 'packadd nvim-lspconfig'
require 'malo.nvim-lspconfig'
end
end
load_nvim_lspconfig()

-- agda-vim
local load_agda_vim = function()
if vim.g.vscode == nil then
vim.cmd 'packadd agda-vim'
end
end
vim.api.nvim_create_autocmd({'FileType'}, {
  pattern = {'agda'},
  callback = load_agda_vim,
})

-- nvim-treesitter
local load_nvim_treesitter = function()
if vim.g.vscode == nil then
vim.cmd 'packadd nvim-treesitter'
require 'malo.nvim-treesitter'
end
end
load_nvim_treesitter()

-- vim-haskell-module-name
local load_vim_haskell_module_name = function()
vim.cmd 'packadd vim-haskell-module-name'
end
vim.api.nvim_create_autocmd({'FileType'}, {
  pattern = {'haskell'},
  callback = load_vim_haskell_module_name,
})

-- vim-polyglot
local load_vim_polyglot = function()
if vim.g.vscode == nil then
vim.cmd 'packadd vim-polyglot'
require 'malo.vim-polyglot'
end
end
load_vim_polyglot()

-- comment.nvim
local load_comment_nvim = function()
if vim.g.vscode == nil then
vim.cmd 'packadd comment.nvim'
require'comment'.setup()
end
end
load_comment_nvim()

-- editorconfig-vim
vim.g.EditorConfig_exclude_patterns = { 'fugitive://.*' }
local load_editorconfig_vim = function()
if vim.g.vscode == nil then
vim.cmd 'packadd editorconfig-vim'
end
end
load_editorconfig_vim()

-- nvim-lastplace
local load_nvim_lastplace = function()
if vim.g.vscode == nil then
vim.cmd 'packadd nvim-lastplace'
require'nvim-lastplace'.setup()
end
end
load_nvim_lastplace()

-- vim-pencil
vim.g['pencil#wrapModeDefault'] = 'soft'
local load_vim_pencil = function()
if vim.g.vscode == nil then
vim.cmd 'packadd vim-pencil'
vim.fn['pencil#init'](); vim.wo.spell = true
end
end
vim.api.nvim_create_autocmd({'FileType'}, {
  pattern = {'markdown','text'},
  callback = load_vim_pencil,
})

-- direnv.vim
local load_direnv_vim = function()
if vim.g.vscode == nil then
vim.cmd 'packadd direnv.vim'
end
end
load_direnv_vim()

-- vim-fugitive
local load_vim_fugitive = function()
if vim.g.vscode == nil then
vim.cmd 'packadd vim-fugitive'
end
end
load_vim_fugitive()