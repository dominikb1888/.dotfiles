--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT
require('impatient')

-- general
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "onedarker"
vim.opt.relativenumber = true -- set relative numbered lines
vim.opt.foldenable = false -- disable folding on startup
vim.opt.keywordprg = "google"

-- function Pypoprepl()
--         require('telegraph').telegraph({cmd='python3 -c "import time\n{cline}\ntime.sleep(2)"', how='tmux_popup'})
-- end

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode = {
        ["<C-s>"] = ":w<cr>",
        ['th'] =   ':tabfirst<cr>',
        ['tk'] =   ':tabnext<cr>',
        ['tj'] =   ':tabprev<cr>',
        ['tl'] =   ':tablast<cr>',
        ['tt'] =   ':tabedit<space>',
        ['tn'] =   ':tabnext<space>',
        ['tm'] =   ':tabm<space>',
        ['td'] =   ':tabclose<cr>',
        ['<silent> <a-down>'] =  'gj',
        ['<silent> <a-up>'] =  'gk',
        ['n'] =  'nzzzv',
        ['j'] =  'mzj`z',
        ['<leader>dv'] = ':lua require("dapui").toggle()<cr>',
        ['<leader>r'] = ':lua Pypoprepl()<cr>',
        ['<leader>sl'] = ':lua require("telescope.builtin").current_buffer_fuzzy_find()<cr>',
        ['<leader>E'] = ':TREPLSendLine<cr>'
}

lvim.keys.visual_mode = {
        ['<leader>E'] = ":TREPLSendSelection<cr>",
        ['.'] = ':norm.<cr>',
        }

-- unmap a default keymapping
lvim.keys.normal_mode["<C-Up>"] = ""
-- edit a default keymapping
lvim.keys.normal_mode["<C-q>"] = ":q<cr>"

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
  -- for input mode
  i = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
    ["<C-n>"] = actions.cycle_history_next,
    ["<C-p>"] = actions.cycle_history_prev,
  },
  -- for normal mode
  n = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
  },
}

-- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["t"] = {
  name = "+Trouble",
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  d = { "<cmd>Trouble lsp_document_diagnostics<cr>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble lsp_workspace_diagnostics<cr>", "Diagnostics" },
}

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.dashboard.active = true
lvim.builtin.terminal.active = true
lvim.builtin.dap.active = true
lvim.builtin.lualine.active = true
lvim.builtin.bufferline.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.show_icons.git = 0


-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "css",
  "rust",
  "java",
  "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- generic LSP settings

---@usage disable automatic installation of servers
lvim.lsp.automatic_servers_installation = false

---@usage Select which servers should be configured manually. Requires `:LvimCacheRest` to take effect.
-- See the full default list `:lua print(vim.inspect(lvim.lsp.override))`
vim.list_extend(lvim.lsp.override, { "pyright" })

---@usage setup a server -- see: https://www.lunarvim.org/languages/#overriding-the-default-configuration
local opts = {} -- check the lspconfig documentation for a list of all possible options
require("lvim.lsp.manager").setup("pylsp", opts)

-- you can set a custom on_attach function that will be used for all the language servers
-- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
lvim.lsp.on_attach_callback = function(client, bufnr)
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end
  --Enable completion triggered by <c-x><c-o>
  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
end
-- you can overwrite the null_ls setup table (useful for setting the root_dir function)
lvim.lsp.null_ls.setup = {
  root_dir = require("lspconfig").util.root_pattern("Makefile", ".git", "node_modules"),
}
-- or if you need something more advanced
lvim.lsp.null_ls.setup.root_dir = function(fname)
  if vim.bo.filetype == "javascript" then
    return require("lspconfig/util").root_pattern("Makefile", ".git", "node_modules")(fname)
      or require("lspconfig/util").path.dirname(fname)
  elseif vim.bo.filetype == "php" then
    return require("lspconfig/util").root_pattern("Makefile", ".git", "composer.json")(fname) or vim.fn.getcwd()
  else
    return require("lspconfig/util").root_pattern("Makefile", ".git")(fname) or require("lspconfig/util").path.dirname(fname)
  end
end

-- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { exe = "black", filetypes = { "python" } },
  -- { exe = "isort", filetypes = { "python" } },
  {
    exe = "prettier",
    ---@usage arguments to pass to the formatter
    -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
    args = { "--print-with", "100" },
    ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
    filetypes = { "typescript", "typescriptreact" },
  },
}

-- set additional linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { exe = "pylint", filetypes = { "python" } },
  {
    exe = "shellcheck",
    ---@usage arguments to pass to the formatter
    -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
    args = { "--severity", "warning" },
  },
  {
    exe = "codespell",
    ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
    filetypes = { "javascript", "python" },
  },
}
-- additional plugins
lvim.plugins = {
        -- color schemes
        { "folke/tokyonight.nvim" },
        -- debugging
        { "rcarriga/nvim-dap-ui",
                requires = { "mfussenegger/nvim-dap" },
                config = function()
                        require("dapui").setup()
                end
        },
        { "thehamsta/nvim-dap-virtual-text" },
        { "mfussenegger/nvim-dap-python"},
        { "rcarriga/vim-ultest", requires = {"vim-test/vim-test"}, run = ":UpdateRemotePlugins" },
        -- Telescope
        { 'nvim-telescope/telescope-bibtex.nvim' },
        { "nvim-telescope/telescope-dap.nvim",
                config = function()
                        require("telescope").load_extension("dap")
                end
        },
        { "nvim-telescope/telescope-symbols.nvim" },
        { "nvim-telescope/telescope-media-files.nvim" },
        { "dominikb1888/telescope-github.nvim"},
        { "crispgm/telescope-heading.nvim" },
        { "cljoly/telescope-repo.nvim" },
        { "airblade/vim-rooter" },
        { "jbyuki/one-small-step-for-vimkind" },
        -- editing
        -- { "folke/trouble.nvim", cmd = "troubletoggle", },
        { "metakirby5/codi.vim", cmd = "codi", },
        { "tpope/vim-repeat" },
        { "tpope/vim-surround", keys = {"c", "d", "y"} },
        { "turbio/bracey.vim",
                cmd = {"bracey", "bracystop", "braceyreload", "braceyeval"},
                run = "npm install --prefix server",
        },
        { "felipec/vim-sanegx", event = "bufread", },
        { "folke/todo-comments.nvim", event = "bufread", },
        { "ellisonleao/glow.nvim", ft = {"markdown"} },
        { "windwp/nvim-ts-autotag",
                event = "insertenter",
                config = function()
                        require("nvim-ts-autotag").setup()
                end,
        },
        { "phaazon/hop.nvim",
                event = "bufread",
                config = function()
                        require("hop").setup()
                        vim.api.nvim_set_keymap("n", "s", ":hopchar2<cr>", { silent = true })
                        vim.api.nvim_set_keymap("n", "s", ":hopword<cr>", { silent = true })
                end,
        },
        -- git and github
        { "tpope/vim-fugitive",
                cmd = {
                        "g",
                        "git",
                        "gdiffsplit",
                        "gread",
                        "gwrite",
                        "ggrep",
                        "gmove",
                        "gdelete",
                        "gbrowse",
                        "gremove",
                        "grename",
                        "glgrep",
                        "gedit"
                },
                ft = {"fugitive"}
        },
        { "AndrewRadev/diffurcate.vim"},
        {'pwntester/octo.nvim',
              config=function()
                require"octo".setup()
              end
        },
        -- Writing
        -- { "brymer-meneses/grammar-guard.nvim", requires = "neovim/nvim-lspconfig" },
        { "junegunn/limelight.vim" },            -- focus on current paragraph
        { "junegunn/goyo.vim" },                 -- remove all clutter
        { "junegunn/vim-easy-align" },           -- adds shortcuts for aligning code

        -- markdown & latex
        { 'godlygeek/tabular' },
        { 'elzr/vim-json' },
        { 'plasticboy/vim-markdown' },
        { 'sidofc/mkdx' },                      -- extensive markdown plugin
        { 'goerz/jupytext.vim' },                -- jupytext integration
        { 'vim-pandoc/vim-pandoc' },
        { 'vim-pandoc/vim-pandoc-syntax' },
        -- {'vim-pandoc/vim-rmarkdown'},
        -- { 'jalvesaq/nvim-r' },
        -- {'gpanders/vim-medieval'},
        { 'kassio/neoterm' },
        { 'jghauser/auto-pandoc.nvim',
                requires = 'nvim-lua/plenary.nvim',
                config = function() require('auto-pandoc') end },
        {'lervag/vimtex',                   -- use braces when passing options
                opt = true,
                config = function() vim.g.vimtex_view_method = 'zathura' end },
        { 'vim-test/vim-test' },
        { 'tpope/vim-projectionist' },
        { 'tpope/vim-dispatch' },
        { 'tpope/vim-rhubarb' },
        { 'jalvesaq/zotcite' },
        -- { 'waylonwalker/telegraph.nvim' },
        -- { 'preservim/vimux' },
        { 'triglav/vim-visual-increment' },
        -- { 'julienr/vimux-pyutils' },
        { 'vimwiki/vimwiki',
                path = '~/Notes/',
                syntax = 'markdown',
                ext = '.md' },
        { 'mattn/calendar-vim' },
        { 'tools-life/taskwiki' },
        { 'michal-h21/vimwiki-sync' },
        { 'lewis6991/impatient.nvim' },
        -- { 'soywod/himalaya', rtp = 'vim'},
        -- {'ellisonleao/carbon-now.nvim'},
        -- { 'mrjones2014/legendary.nvim'},
        -- { 'michaelb/sniprun', run = 'bash ./install.sh 1'},
        { 'simrat39/symbols-outline.nvim', cmd = "SymbolsOutline" },
}

-- Wimiwiki
vim.g.vimwiki_list = {
  {
    path = '~/Notes/',
    index = "index",
    sytax = "markdown",
    ext = "md",
    auto_diary_index = 1,
    auto_toc = 1,
    auto_generte_links = 1,
    foldmethod = "expr",
  }
}

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
 lvim.autocommands.custom_groups = {
    { "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
    { "BufReadPost", "*.md", "call <SID>WikiBufReadPostOverrides()"},
    { "BufRead,BufNewFile", "*.md", ":Goyo 75%x75%" },
 }

-- change telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
lvim.builtin.telescope.on_config_done = function()
  local actions = require "telescope.actions"
  -- for input mode
  lvim.builtin.telescope.defaults.mappings.i["<c-j>"] = actions.move_selection_next
  lvim.builtin.telescope.defaults.mappings.i["<c-k>"] = actions.move_selection_previous
  lvim.builtin.telescope.defaults.mappings.i["<c-n>"] = actions.cycle_history_next
  lvim.builtin.telescope.defaults.mappings.i["<c-p>"] = actions.cycle_history_prev
  -- for normal mode
  lvim.builtin.telescope.defaults.mappings.n["<c-j>"] = actions.move_selection_next
  lvim.builtin.telescope.defaults.mappings.n["<c-k>"] = actions.move_selection_previous
 end

lvim.builtin.telescope.extensions = {
    bibtex = {
      depth = 1,
      custom_formats = {
        { id = 'harvard', cite_marker = '#%s#' }
      },
      format = 'harvard',
      global_files = { '/users/dboehler/zotero/', },
      search_keys = { 'label', 'author', 'publisher' },
    },
}

-- use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["p"] = { "<cmd>telescope projects<cr>", "projects" }
lvim.builtin.which_key.mappings["t"] = {
   name = "+trouble",
   r = { "<cmd>trouble lsp_references<cr>", "references" },
   f = { "<cmd>trouble lsp_definitions<cr>", "definitions" },
   d = { "<cmd>trouble lsp_document_diagnostics<cr>", "diagnostics" },
   q = { "<cmd>trouble quickfix<cr>", "quickfix" },
   l = { "<cmd>trouble loclist<cr>", "locationlist" },
   w = { "<cmd>trouble lsp_workspace_diagnostics<cr>", "diagnostics" },
 }

-- todo: user config for predefined plugins
-- after changing plugin config exit and reopen lunarvim, run :packerinstall :packercompile
lvim.builtin.bufferline.active = true
lvim.builtin.dap.active = true
lvim.builtin.dashboard.active = true
lvim.builtin.lualine.active = true
lvim.builtin.terminal.active = true
lvim.builtin.terminal.direction = "horizontal"
lvim.builtin.terminal.size = 10

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = "maintained"
lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- generic lsp settings
-- you can set a custom on_attach function that will be used for all the language servers
-- see <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end
-- you can overwrite the null_ls setup table (useful for setting the root_dir function)
-- lvim.lsp.null_ls.setup = {
--   root_dir = require("lspconfig").util.root_pattern("makefile", ".git", "node_modules"),
-- }
-- or if you need something more advanced
-- lvim.lsp.null_ls.setup.root_dir = function(fname)
--   if vim.bo.filetype == "javascript" then
--     return require("lspconfig/util").root_pattern("makefile", ".git", "node_modules")(fname)
--       or require("lspconfig/util").path.dirname(fname)
--   elseif vim.bo.filetype == "php" then
--     return require("lspconfig/util").root_pattern("makefile", ".git", "composer.json")(fname) or vim.fn.getcwd()
--   else
--     return require("lspconfig/util").root_pattern("makefile", ".git")(fname) or require("lspconfig/util").path.dirname(fname)
--   end
-- end

-- set a formatter if you want to override the default lsp one (if it exists)

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { exe = "autopep8" },
  { exe = "prettier" },
}

-- set an additional linter

local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { exe = "flake8" },
}

-- autocommands (https://neovim.io/doc/user/autocmd.html)
lvim.autocommands.custom_groups = {
        { "bufwinenter", "*.lua", "setlocal ts=8 sw=8" },
}


-- keymappings for inkscape picture embed within markdown (via latex)
-- inoremap <c-f> <esc>: silent exec '.!inkscape-figures create "'.getline('.').'" "'.b:vimtex.root.'/figures/"'<cr><cr>:w<cr>
-- nnoremap <c-f> : silent exec '!inkscape-figures edit "'.b:vimtex.root.'/figures/" > /dev/null 2>&1 &'<cr><cr>:redraw!<cr>


-- hook to nvim-lspconfig
-- require("grammar-guard").init()

-- -- setup lsp config
-- require("lspconfig").grammar_guard.setup({
-- 	settings = {
-- 		ltex = {
-- 			enabled = { "latex", "tex", "bib", "markdown" },
-- 			language = "en",
-- 			diagnosticseverity = "information",
-- 			setencecachesize = 2000,
-- 			additionalrules = {
-- 				enablepickyrules = true,
-- 				mothertongue = "en",
-- 			},
-- 			trace = { server = "verbose" },
-- 			dictionary = {},
-- 			disabledrules = {},
-- 			hiddenfalsepositives = {},
-- 		},
-- 	},
-- })


-- Debuggers

 require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')

vim.g.neoterm_default_mod = ':vertical'
vim.g.medieval_langs = { 'python=python3', 'ruby', 'sh', 'console=bash' }
