if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')


" Fuzzy File Finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'


" " File Commenter
Plug 'tpope/vim-commentary'

" " Python AutoDoc String
Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }

" " Allow change inside () and others
Plug 'wellle/targets.vim'

" " Change surrouding characters easier
Plug 'tpope/vim-surround'

" " Allow repeating after plugin map
Plug 'tpope/vim-repeat'

" " Vim and Tmux navigation
Plug 'christoomey/vim-tmux-navigator'

" " Smoother scrolling
Plug 'psliwka/vim-smoothie'

" " Vim Fugitive
Plug 'tpope/vim-fugitive'

" Status Line
Plug 'itchyny/lightline.vim'

" Theme
Plug 'ayu-theme/ayu-vim' 

"ChadTree
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}


" neovim language things
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neovim/nvim-lspconfig'

" LSP autocomplete
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}

"" Dev icons ALWAYS LOAD LAST
Plug 'ryanoasis/vim-devicons'
call plug#end()


" Set doc string type
let g:doge_doc_standard_python = 'numpy'

" Move around windows
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l

set termguicolors     " enable true colors support
set noshowmode " Don't show mode if using status line
let ayucolor="mirage" " for mirage version of theme
colorscheme ayu

let g:lightline = {
      \ 'colorscheme': 'ayu_mirage',
      \ }

"Clipboard copy and paste
set clipboard=unnamed

"" Map CHARDTree to ctrl-n
nmap <C-n> :CHADopen<CR>
let g:chadtree_settings = {
  \ 'theme.text_colour_set': "nord",
  \ 'keymap.primary': ["o"],
  \ }


"" Remap leader key to space
let mapleader="\<Space>"

"" Remap save current buffer to space-w
nnoremap <leader>w :w<cr>


"" Line numbers
set number

"" Set relative line numbers
set relativenumber

"" pudb keybinding
nnoremap <leader>gp oimport pudb; pu.db<Esc>

"" Remap FZF Files
nnoremap <leader>m :Files /Users/zachbarnes/v/volta/<CR>
nnoremap <C-p> :Files /Users/zachbarnes/v/volta/<CR>

" " Remap Searching for lines in files
nnoremap <leader>h :History<CR>

" " Remap Searching for lines in files
nnoremap <leader>l :BLines<CR>

" " Remap Searching for lines in files
nnoremap <leader>b :Buffers<CR>

" " Remap RipGrep
nnoremap <leader>rg :Rg<CR>

" " Remap Git status
nnoremap <leader>gs :Git<CR>

" Go quickly to init.vim
nnoremap <leader>ee :e! ~/.config/nvim/init.vim<cr> " edit ~/.config/nvim/init.vim

" Autostart COQ
let g:coq_settings = { 'auto_start': v:true }

" Disable ctrl-h
let g:coq_settings = { 'keymap.jump_to_mark' : '' }


" Hightlight on yank
" From https://neovim.io/news/2021/07
au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=true}

" Set up language servers
lua << EOF
require'lspconfig'.pyright.setup{}
EOF

" Configure language server
" https://github.com/neovim/nvim-lspconfig#keybindings-and-completion
lua << EOF
local nvim_lsp = require('lspconfig')


-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "pyright" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF
