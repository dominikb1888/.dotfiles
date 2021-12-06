source $HOME/.config/nvim/plugins.vim
source $HOME/.config/nvim/config.vim



"""""""""""""""""""""""""""""""""""""""""
" ### config
"""""""""""""""""""""""""""""""""""""""""

syntax on           " Syntax Highlighting aktiveren
set number          " Line Numbers anzeigen
set relativenumber  " Relative Nummerierung anzeigen
set linebreak       " Ganze Wörter in neue Zeile umbrechen
set showmode        " Aktuellen Modus in Statuszeile anzeigen
set scrolloff=5     " Cursor bei Scroll weiter oben halten
set mouse=a          " Scrollen mit der Mouse in Console und tmux
set lazyredraw      " Weniger Redraws bei Macros und co.
set cursorline      " Aktive Zeile markieren
set updatetime=300  " Schellere Darstellung	/ Refresh
set cc=80          " Markierung 80 Zeilen-Rand
set laststatus=2    " Statuszeile immer anzeigen
set cmdheight=2     " Mehr Platz für Statusmeldungen
set shortmess+=c    " Don't pass messages to |ins-completion-menu|
set nowrap          " Wrap standardmäßig abschalten. Mit Leader w an-/abschalten
set nobackup        " No auto backups
set hidden          " Needed to keep multiple buffers open
set incsearch       " incremental search
set encoding=utf-8   " Encoding displayed 
set fileencoding=utf-8 "Encoding saved
set pumheight=8      "Smaller Pop-up Menu
set ruler     " show cursor position all the time
set iskeyword+=-  "dash separated keywords as words

" ##  Optik und Farben
if has('termguicolors')
  set termguicolors     " Wenn Farben nicht passen, dann die Zeile auskommentieren (z.B. macOS Terminal)	
endif

colorscheme gruvbox       " Farbschema aktivieren

" ### Suche
set path+=**      " Damit kann mit :find alles, auch in Subfolder gefunden werden
set ignorecase    " Suche nicht Case-Sensentiv
set smartcase     " Aber wenn Großbuchstaben verwenden werden dann schon

" ### Sprache und Rechtschreibkorrektur
set helplang=de             " Deutsche Hilfe
set spelllang=de_de,en_us   " Deutsche und englische Rechtschreibung
"set spell                  " Rechtschreibkorrektur immer aktivieren
autocmd FileType markdown setlocal spell   " Spell bei Markdown aktivieren
autocmd FileType text setlocal spell       " Spell bei allgemeinen Textfiles aktivieren

" ### Verhalten für Backup, Swap und co.
if !isdirectory($HOME."/.local/share/nvim/undodir")
  call mkdir($HOME."/.local/share/nvim/undodir", "p", 0700)
endif
set undodir=~/.local/share/nvim/undodir     " Alle Veränderungen werden hier aufgezeichnet
set undofile		                            " Alle Änderungen werden endlos in oberen undodir protokolliert
if !isdirectory($HOME."/.local/share/nvim/swap")
  call mkdir($HOME."/.local/share/nvim/swap", "p", 0700)
endif
set directory=~/.local/share/nvim/swap      " Zentrale Ablage der Swap-Files
"set noswapfile     " Falls kein Swap-Files erstellen werden soll
set nobackup        " Backfile wird sofort wirder gelöscht, da Restores über Undofiles möglich
set hidden          " Wechsel von Buffern auch, wenn File nicht gespeichert

" ### Verhalten von TABs und Einrücken bei Code 
set tabstop=2 softtabstop=2	shiftwidth=2    " Nur zwei Tab-Stopp einfügen
set expandtab           " Tabs in Spaces wandeln
set formatoptions+=j    " Immer Spaces anstatt Tabs
"set clipboard=unnamed  " Standard-Register (yy, dd, etc) IMMER in Zwischenablage kopieren 

" neomake config
let g:neomake_python_enabled_makers = ['pylint']

" Mit :Format wird der Code automatisch formatiert
command! -nargs=0 Format :call CocAction('format')

"""""""""""""""""""""""""""""""""""
" ### Meine Keyboard-Settings
"""""""""""""""""""""""""""""""""""
let mapleader = ","		" Komma-Taste als Leader
let maplocalleader = ",," "Leertaste als Local Leader

imap jk <ESC>

" Dateihistorie verwalten
nnoremap <leader>u :UndotreeToggle<CR>      " Tracking der Veränderungen anzeigen/ausblenden

" Öffnen von Dateien und Sessions
map <silent> <leader>o :call NERDTreeToggle()<CR>
nnoremap <leader>S :LoadLastSession<CR>     " Lade letzte Session

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ### Splits and Tabbed Files
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set splitbelow splitright

" Remap splits navigation to just CTRL + hjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Make adjusing split sizes a bit more friendly
noremap <silent> <C-Left> :vertical resize +3<CR>
noremap <silent> <C-Right> :vertical resize -3<CR>
noremap <silent> <C-Up> :resize +3<CR>
noremap <silent> <C-Down> :resize -3<CR>

" Change 2 split windows from vert to horiz or horiz to vert
map <Leader>th <C-w>t<C-w>H
map <Leader>tk <C-w>t<C-w>K

" Open REPLs
map <Leader>tr :new term://zsh<CR>iR<CR><C-\><C-n><C-w>k
map <Leader>tp :new term://zsh<CR>ipython3<CR><C-\><C-n><C-w>k
map <Leader>td :new term://zsh<CR>isqlite3<CR><C-\><C-n><C-w>k

" Removes pipes | that act as seperators on splits
set fillchars+=vert:\ 

" Control Tabs
nnoremap th  :tabfirst<CR>
nnoremap tk  :tabnext<CR>
nnoremap tj  :tabprev<CR>
nnoremap tl  :tablast<CR>
nnoremap tt  :tabedit<Space>
nnoremap tn  :tabnext<Space>
nnoremap tm  :tabm<Space>
nnoremap td  :tabclose<CR>

" Durch Buffer steuern
nnoremap <silent> <localleader>k :bp!<CR>
nnoremap <silent> <localleader>j :bn!<CR>

" Bei Wrap-Zeilen in den Zeilen blättern und nicht in Blöcken
nnoremap <silent> <A-Down> gj
nnoremap <silent> <A-Up> gk

" Wrap an-/ausschalten
nnoremap <silent> <leader>w :set wrap!<CR>

" copy, cut and paste direkt in Zwischenablage
vmap <C-c> "+y
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <ESC>"+pa

" Sonstiges
nnoremap <silent> <leader>s :nohlsearch<CR>
nnoremap <silent> <leader>v :Vista!!<CR>
nnoremap <silent> <leader>c :e ~/.config/nvim/init.vim<CR>
nnoremap <silent> <leader>r :source ~/.config/nvim/init.vim<CR>  " Config neu laden
command! WriteUnix w ++ff=unix    " Wenn Du eine Dos-Datei in Unix speichern willst
command! WriteDos w ++ff=dos      " Und anders rum
command! W w " Weil ich Depp mich ständig vertippe
command! Q q " Weil ich Depp mich ständig vertippe
nnoremap Q !!$SHELL <CR>

" 5 Best remappings
" Keep search results centered
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" Undo break points
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u

" Jumplist mutations
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

" Moving Text
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '>-2<CR>gv=gv
inoremap <C-j> <esc>:m .+1<CR>==
inoremap <C-k> <esc>:m .-2<CR>==
nnoremap <leader>k :m .-2<CR>==
nnoremap <leader>j :m .+1<CR>==

" Auto indent whole file
nnoremap <Leader><tab> <esc>gg=G<C-o><C-o>zz

" Python
let g:python3_host_skip_check = 1
nnoremap <buffer> H :<C-u>execute "!pydoc3 " . expand("<cword>")<CR>

