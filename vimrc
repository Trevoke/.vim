" Confused? Remember that you can use :help <something>

" Vundle apparently requires this stuff, so we're going to
" set them here and then unset them later

filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rake'
Plugin 'tpope/vim-rvm'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-surround'
Plugin 'tpope/gem-browse'
Plugin 'tpope/vim-bundler'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-haml'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-markdown'
Plugin 'tpope/vim-dispatch'

Plugin 'pangloss/vim-javascript'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'vim-scripts/c.vim'
Plugin 'kchmck/vim-coffee-script'
Plugin 'vim-ruby/vim-ruby'
Plugin 'groenewege/vim-less'
Plugin 'lukerandall/haskellmode-vim'
Plugin 'vim-scripts/tintin.vim'
Plugin 'klen/python-mode'
Plugin 'elixir-lang/vim-elixir'

Plugin 'sandeepravi/refactor-rails.vim'
Plugin 'ecomba/vim-ruby-refactoring'
Plugin 'scrooloose/syntastic'
Plugin 'vitaly/vim-syntastic-coffee'
Plugin 'vim-scripts/UltiSnips'
Plugin 'Trevoke/ultisnips-rspec'
Plugin 'vim-scripts/matchit.zip'
Plugin 'vim-scripts/ruby-matchit'

Plugin 'vim-scripts/ag.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'bling/vim-airline'
Plugin 'vim-scripts/golden-ratio'
Plugin 'jgdavey/tslime.vim'
Plugin 'jgdavey/vim-turbux'
Plugin 'majutsushi/tagbar'
Plugin 'fweep/vim-tabber'
Plugin 'vim-scripts/Gundo'
Plugin 'ervandew/supertab'

Plugin 'altercation/vim-colors-solarized'
Plugin 'nanotech/jellybeans.vim'
Plugin 'briancarper/gentooish.vim'
Plugin 'tpope/vim-vividchalk'
Plugin 'Pychimp/vim-luna'

call vundle#end()

" Now the actual configuration begins
syntax on
filetype plugin indent on

set ttimeoutlen=50

set t_Co=256
colorscheme jellybeans

" Life's about choices
set mouse=a
set mousemodel=extend

set autoindent
set expandtab

" I like line numbers, relative to the cursor.
:set rnu
" Insert mode: absolute line numbers
au InsertEnter * :set nu
" Other modes: relative line numbers
au InsertLeave * :set rnu

set ruler " Where the cursor is, in the linebuffer
set scrolloff=3  " Always show 3 lines around cursor

set hls " Highlight searches
set incsearch " Highlight search as you type
set ignorecase " Searches ignore case
set smartcase " Searching for 'a/Bc'  matches 'aBc' not 'abc'

" I'm not super-intelligent and I like being able to delete further than I
" typed.
set backspace=indent,eol,start

" I do not want a buffer to open pre-folded
set nofoldenable

" set title on window if possible
set title

" file/command completion, like a shell
set wildmenu
set wildmode=list:longest:full

" KEYMAPPINGS
"
" Define "," as the "Leader" character (:help leader)
let mapleader = ","
let g:mapleader = ","

" Fast saving with Leader "w"
map <leader>w :w!<CR>

" use Leader "space" to clear out the search results highlighting
nnoremap <leader><space> :noh<CR>

" The Esc key just gets smaller and smaller...
nnoremap <F1> <Esc>
inoremap <F1> <Esc>
vnoremap <F1> <Esc>

" And maybe I don't want to hit it at all.
imap jk <Esc>
imap kj <Esc>

" Re-indent the entire file
nnoremap <Leader>= magg=G`a

" Fancy pane switching detecting tmux
if exists('$TMUX')
  function! TmuxOrSplitSwitch(wincmd, tmuxdir)
    let previous_winnr = winnr()
    execute "wincmd " . a:wincmd
    if previous_winnr == winnr()
      " The sleep and & gives time to get back to vim so tmux's focus tracking
      " can kick in and send us our ^[[O
      execute "silent !sh -c 'sleep 0.01; tmux select-pane -" . a:tmuxdir . "' &"
      redraw!
    endif
  endfunction
  let previous_title = substitute(system("tmux display-message -p '#{pane_title}'"), '\n', '', '')
  let &t_ti = "\<Esc>]2;vim\<Esc>\\" . &t_ti
  let &t_te = "\<Esc>]2;". previous_title . "\<Esc>\\" . &t_te
  nnoremap <silent> <C-h> :call TmuxOrSplitSwitch('h', 'L')<cr>
  nnoremap <silent> <C-j> :call TmuxOrSplitSwitch('j', 'D')<cr>
  nnoremap <silent> <C-k> :call TmuxOrSplitSwitch('k', 'U')<cr>
  nnoremap <silent> <C-l> :call TmuxOrSplitSwitch('l', 'R')<cr>
else
  map <C-h> <C-w>h
  map <C-j> <C-w>j
  map <C-k> <C-w>k
  map <C-l> <C-w>l
endif
" END KEYMAPPINGS

"gundo.vim
nnoremap <Leader>u :GundoToggle<CR>

"vim-dispatch
nnoremap <Leader>t :Dispatch<CR>

set encoding=utf-8
set laststatus=2

" tab bar - fweep's plugin
set showtabline=2
let g:tabber_divider_style='compatible'
set tabline=%!tabber#TabLine()

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" tagbar
let g:tagbar_left = 1
let g:tagbar_width = 30
let g:tagbar_show_visibility = 1
let g:tagbar_iconchars = ['▾', '▸'] 
"toggle ctags window with "F4"
map <F4> :TagbarToggle<CR> 
"build ctags with "F8"
map <F8> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

" "zz" now puts the line 10% above the middle of the screen instead of dead center
if has('float')
  nnoremap <silent> zz :exec "normal! zz" . float2nr(winheight(0)*0.1) . "\<Lt>C-E>"<CR>
endif

" Ruby
autocmd FileType ruby let g:SuperTabDefaultCompletionType = "context"
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby,eruby let ruby_minlines = 300
autocmd FileType ruby,eruby let ruby_operators = 1
autocmd FileType ruby,eruby let ruby_space_errors = 1
autocmd FileType ruby,eruby let ruby_fold = 1

autocmd FileType ruby setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType eruby setlocal tabstop=2 shiftwidth=2 softtabstop=2

" improve autocomplete menu color
highlight Pmenu ctermbg=238 gui=bold

" Stylesheets
autocmd FileType css setlocal tabstop=2 shiftwidth=2 softtabstop=2  foldmethod=indent
autocmd FileType scss setlocal tabstop=2 shiftwidth=2 softtabstop=2 foldmethod=indent

" Javascript
autocmd BufNewFile,BufRead *.json set ft=javascript
autocmd FileType javascript setlocal tabstop=4 shiftwidth=4 softtabstop=4

" Make
autocmd FileType make setlocal noexpandtab

" Coffeescript
autocmd FileType coffee setlocal shiftwidth=2 tabstop=2 softtabstop=2

" Tintin++
autocmd BufNewFile,BufRead *.tin set filetype=tintin
autocmd FileType tintin setlocal shiftwidth=2 tabstop=2 softtabstop=2

" Toggle column to check 80-char limit
nnoremap <F2> :call ToggleColorColumn()<CR>

func! ToggleColorColumn()
    if exists("b:colorcolumnon") && b:colorcolumnon
        let b:colorcolumnon = 0
        exec ':set colorcolumn=0'
        echo '80 column marker off'
    else
        let b:colorcolumnon = 1
        exec ':set colorcolumn=80'
        echo '80 column marker on'
    endif    
endfunc

