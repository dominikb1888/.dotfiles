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

-- Package manager
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', install_path})
end

-- Plugins
require 'paq' {
    'savq/paq-nvim';                    -- Let Paq manage itself
    'svermeulen/vimpeccable';            -- Allow usage of vimscript within lua

    -- Syntax
    'neovim/nvim-lspconfig';            -- Standard config for LSP
    'glepnir/lspsaga.nvim';             -- LSP Plugin UI
    'nvim-lua/completion-nvim';               -- Autocompletion
    'anott03/nvim-lspinstall'; 
    'nvim-treesitter/nvim-treesitter';   -- Syntax Highlighting
    'nvim-treesitter/playground';        -- Show AST in split 
    'nvim-treesitter/nvim-treesitter-textobjects'; -- Create ustom text objects

    -- Search
    'nvim-lua/plenary.nvim';
    'nvim-lua/popup.nvim';
  { 'nvim-telescope/telescope.nvim',   
        requires = 'nvim-lua/plenary.nvim'};
    'jremmen/vim-ripgrep';

    -- Statuslines
    'crispgm/nvim-tabline';              -- Tabline
    'hoob3rt/lualine.nvim';              -- Statusline

    -- Colors
    'rktjmp/lush.nvim';                 -- Dependency for gruvbox
    'ellisonleao/gruvbox.nvim';         -- Gruvbox color scheme

    -- Icons
    'kyazdani42/nvim-web-devicons';
  { 'yamatsum/nvim-nonicons', 
        requires = 'kyazdani42/nvim-web-devicons'};

    -- Editing
    'junegunn/limelight.vim';            -- Focus on current paragraph
    'junegunn/goyo.vim';                 -- Remove all clutter
    'junegunn/vim-easy-align';           -- Adds shortcuts for aligning code
    'tpope/vim-surround'; 
    'tpope/vim-repeat';

    -- Programming Languages

    -- GIT
    'lewis6991/gitsigns.nvim';

    -- Terminal & REPLs
    'ivanov/vim-ipython';
    'jalvesaq/Nvim-R';
    'dccsillag/magma-nvim';
    -- Snippets    
    'SirVer/ultisnips';
    'honza/vim-snippets';
    -- Markdown & Latex
    'godlygeek/tabular';
    'elzr/vim-json';
    'plasticboy/vim-markdown';
    'SidOfc/mkdx';                       -- Extensive Markdown Plugin
    'goerz/jupytext.vim';                -- Jupytext integration
    'vim-pandoc/vim-pandoc';
    'vim-pandoc/vim-pandoc-syntax';
    'vim-pandoc/vim-rmarkdown';
  { 'jghauser/auto-pandoc.nvim',       
        requires = 'nvim-lua/plenary.nvim',
        config = function() require('auto-pandoc') end };  
  
  { 'lervag/vimtex',                   -- Use braces when passing options                 
        opt=true };    
}

--         --
-- Configs --
--         --

-- Treesitter
local ts = require('nvim-treesitter.configs')

ts.setup {
  ensure_installed = 'maintained',
  highlight = {
    enable = true,
  }
}

-- LSP

local lsp = require('lspconfig')
local completion = require('completion')

local function custom_on_attach(client)
  print('Attaching to' .. client.name)
  completion.on_attach(client)
end

local default_config = {
  on_attach = custom_on_attach,
}

-- setup language servers here
--lsp.tsserver.setup(default_config)
lsp.pylsp.setup {default_config}

--lspfuzzy.setup {}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = false,
    signs = true,
    update_in_insert = true,
  }
)

-- LSP Saga config & keys https://github.com/glepnir/lspsaga.nvim
local saga = require("lspsaga")
saga.init_lsp_saga({
  code_action_icon = " ",
  definition_preview_icon = "  ",
  dianostic_header_icon = "   ",
  error_sign = " ",
  finder_definition_icon = "  ",
  finder_reference_icon = "  ",
  hint_sign = "⚡",
  infor_sign = "",
  warn_sign = "",
})

-- Statusline
require('lualine').setup()
options = {
  theme = 'gruvbox',
}

-- Gitsigns
require('gitsigns').setup()

-- Markdown & Latex
g.vim_markdown_folding_disabled = 1
g.vim_markdown_conceal = 0
g.tex_conceal = ''
g.vim_markdown_math = 1
g.vim_markdown_frontmatter = 1  -- for YAML format
g.vim_markdown_toml_frontmatter = 1  -- for TOML format
g.vim_markdown_json_frontmatter = 1  -- for JSON format

cmd([[  
  augroup pandoc_syntax
    au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
  augroup END
  ]])

cmd("autocmd! User GoyoEnter Limelight")
cmd("autocmd! User GoyoLeave Limelight!")

--vim_markdown_preview_github = 1   -- Github-Erweiterungen von Markdown auch anzeigen
g['pandoc#syntax#codeblocks#embeds#langs'] = {'python', 'ipython3=python'}
g['sneak#label'] = 1               -- Sneak-Vimi Label zum schnellen springen aktivieren.

g.UltiSnipsExpandTrigger='<tab>'  -- use <Tab> to trigger autocompletion
g.UltiSnipsJumpForwardTrigger='<c-j>'
g.UltiSnipsJumpBackwardTrigger='<c-k>'
