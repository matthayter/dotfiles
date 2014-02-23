" Modeline and Notes {{
" vim: set foldmarker={{,}} foldlevel=0 foldmethod=marker spell:
"
"  You can find me at http://spf13.com
"}}

"general {{
    set nocompatible               " be iMproved
    syntax on
    " Allow buffers to be hidden, which keeps unsaved modifications in the
    " background
    set hidden
    set expandtab
    set backspace=2 
    set comments=sr:/*,mb:*,el:*/,://,b:#,:%,:XCOMM,n:>,:--,sr:{-,mb:-,el:-}
    set formatoptions=tcrq2l
    set incsearch
    " set hlsearch
    " set ruler
    "set textwidth=79
    "set columns=83
    set tabstop=2 softtabstop=2 shiftwidth=2
    set tildeop
    set ic
    " set si
    set nu
    set path+=/usr/local/include
    set ttimeoutlen=0
    "set foldmethod=indent
    "set foldnestmax=1
    "set foldcolumn=0
    set showcmd
    " Indent to the opening paren if inside parens
    set cino=(0

    " Column 80 highlight
    set cc=80

    " Tab filename completion: completes as much as possible, then lists all
    " matches, then starts cycling completion through matches
    set wildmode=longest,list,full
    " see :help wildmenu
    "set wildmenu

    set mouse=a

    set autoindent
    " Set a current spec file with R, execute it via tmux with r.
    "map <leader>R :let g:specFile = @% \| echo "RSpec file: " . g:specFile<CR>
    "map <leader>r :wall \| :call Send_to_Tmux("rspec -f d " . g:specFile . "\n")<CR>

    " Swap files go into their own directory, to prevent polluting directories
    " and in particular git status
    set dir=~/.vim/swps
"}}

"vundle {{
    filetype off                   " required!

    set rtp+=~/.vim/bundle/vundle/
    call vundle#rc()

    " let Vundle manage Vundle
    " required! 
    Bundle 'gmarik/vundle'

    " My Bundles here:
    "
    " original repos on github
    Bundle 'tpope/vim-fugitive'
    "Bundle 'Lokaltog/vim-easymotion'
    Bundle 'Lokaltog/vim-powerline'
    Bundle 'railscasts'
    "Bundle 'neocomplcache'
    " Ctrl-P
    Bundle 'git://github.com/kien/ctrlp.vim.git'
    " Markdown syntax
    Bundle 'git://github.com/plasticboy/vim-markdown.git'
    " Mustache html templates syntax
    Bundle 'git://github.com/juvenn/mustache.vim.git'
    " Buffer killing without closing window
    Bundle 'bufkill.vim'
    " Ruby code browsing
    Bundle 'git://github.com/vim-ruby/vim-ruby.git'
    " Tmux integration
    Bundle 'git://github.com/ervandew/screen.git'
    " Stylus syntax
    Bundle 'git://github.com/wavded/vim-stylus.git'

    Bundle 'vim-coffee-script'
    Bundle 'tslime.vim'
    Bundle 'jellybeans.vim'


    filetype plugin indent on     " required!
    "
    " Brief help
    " :BundleList          - list configured bundles
    " :BundleInstall(!)    - install(update) bundles
    " :BundleSearch(!) foo - search(or refresh cache first) for foo
    " :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
    "
    " see :h vundle for more details or wiki for FAQ
    " NOTE: comments after Bundle command are not allowed..
" }}

" Vim UI {{
    colorscheme jellybeans_pda
    highlight colorcolumn guibg=darkGrey ctermbg=darkGrey
    set cursorline                  " highlight current line
    if has('cmdline_info')
        set ruler                   " show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " a ruler on steroids
        set showcmd                 " show partial commands in status line and
                                    " selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2

        " Broken down into easily includeable segments
        set statusline=%<%f\    " Filename
        set statusline+=%w%h%m%r " Options
        set statusline+=%{fugitive#statusline()} "  Git Hotness
        set statusline+=\ [%{&ff}/%Y]            " filetype
        set statusline+=\ [%{getcwd()}]          " current dir
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif
    set scrolloff=3      " minimum lines to keep above and below cursor
    set splitright
    set splitbelow
" }}

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif


au BufEnter Makefile set noexpandtab sts=0
au BufEnter makefile set noexpandtab sts=0


" Key (re)Mappings {{
    "The default leader is '\', but many people prefer ',' as it's in a
    "standard location
    let mapleader = ';'

    " Commands
    "Delete all buffers
    command Bda bufdo bd

    " Copy/paste
    " nmap <C-V> :set paste<CR>:r !pbpaste<CR>:set nopaste<CR>
    " inoremap <C-V> <ESC><C-V>i
    nnoremap <C-C> :.w !pbcopy<CR><CR>
    vnoremap <C-C> :w !pbcopy<CR><CR>
    
    " Easier moving in tabs and windows
    noremap <C-J> <C-W>j
    noremap <C-K> <C-W>k
    noremap <C-L> <C-W>l
    noremap <C-H> <C-W>h

    " Cross-pane commands
    noremap <Leader>th :call ScreenShellSend("c \"" . @% . ":" . line('.') . "\"")<CR>
    " noremap <Leader>tt :call ScreenShellSend("c")<CR>
    noremap <Leader>tl :call ScreenShellSend("reload_files")<CR>
    noremap <Leader>ta :call ScreenShellSend("c \"" . @% . ":0\"")<CR>

    " Cross-pane rspec
    noremap <Leader>tt :call ScreenShellSend("rspec")<CR>

    " Some helpers to edit mode
    " http://vimcasts.org/e/14
    cnoremap %% <C-R>=expand('%:h').'/'<cr>
    nnoremap <leader>ew :e <C-R>=expand('%:h').'/'<cr>
    nnoremap <leader>es :sp <C-R>=expand('%:h').'/'<cr>
    nnoremap <leader>ev :vsp <C-R>=expand('%:h').'/'<cr>
    nnoremap <leader>et :tabe <C-R>=expand('%:h').'/'<cr>

    " Quick edit VIMRC
    nnoremap <leader>er :e $MYVIMRC<cr>

    " Quick open screen shell
    nnoremap <leader>s :ScreenShell!<CR>

    " Find/replace word under cursor
    nnoremap ;r yiw:%s/\<<C-R>0\>/

    " For editing C files
    "noremap ;s o<ESC>cc/*<ESC>75a-<ESC>a*/<ESC>^15lR<Space>
    "noremap ;i o<ESC>cc#include <.h><ESC>hhi
    "noremap ;m o<ESC>ccint main(int argc, char **argv){<CR>return 0;<ESC>kO
    " imap {<CR> {<CR>}<ESC>ko

"}}

" Filetype recognition {{
    autocmd BufNewFile,BufRead Gemfile set filetype=ruby
    autocmd BufNewFile,BufRead Guardfile set filetype=ruby
    autocmd BufNewFile,BufRead *.styl set filetype=stylus
"}}

" Convenience functions {{
    " Submit control char like this: This sends (Ctrl-C, Up) to other screen:
    " :call MapScreenSend('r', '<C-V><C-C><C-V>^[OA')
    function MapScreenSend(mapping, send_cmd)
      execute "noremap <Leader>" . a:mapping . " :call ScreenShellSend('" . a:send_cmd . "')<CR>"
    endfunction
" }}

" GUI Settings {{
    if has('gui_running')
        set guioptions-=T           " remove the toolbar
        set lines=40                " 40 lines of text instead of 24,
        set columns=84
        set guifont=Monospace\ 11
        ""set guifont=Andale\ Mono\ Regular:h16,Menlo\ Regular:h15,Consolas\ Regular:h16,Courier\ New\ Regular:h18
    else
        "set term=builtin_ansi       " Make arrow and other keys work
    endif
" }}

" CtrlP options {{
    let g:ctrlp_custom_ignore = 'tmp\|vendor\|doc\|node_modules\|DS_Store\|git'
    let g:ctrlp_max_files = 0
    let g:ctrlp_working_path_mode = 0
" }}

" screen.vim options {{
    let g:ScreenShellQuitOnVimExit = 0
" }}
