source $HOME/.config/nvim/vim-plug/plugins.vim

set number
set relativenumber
set autoindent
set tabstop=4
set shiftwidth=4
set smarttab
set softtabstop=4
set mouse=a
set softtabstop=4
set mouse=a
set noswapfile
set encoding=utf8

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" for tabulation
set smartindent
set tabstop=2
set expandtab
set shiftwidth=2
set guifont=DroidSansMono\ Nerd\ Font

autocmd BufWritePre <buffer> CocCommand editor.action.formatDocument

nnoremap <C-f> :NERDTreeFind<cr>
nnoremap <C-t> :NERDTreeToggle<cr>

nmap <F8> :TagbarToggle<cr>
colorscheme PaperColor

let g:airline_powerline_fonts = 1

"let g:NERDTreeDirArrowExpandable="+"
"let g:NERDTreeDirArrowCollapsible="~"

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

lua << EOF
local nvim_lsp = require 'lspconfig'
local async = require "plenary.async"
local cmp = require "cmp"
local lspkind = require 'lspkind'

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<cr>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true
    }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  }),
  formatting = {
    format = lspkind.cmp_format({ with_text = false, maxwidth = 50 })
  }
})

local on_attach = function(client, bufnr)
  -- format on save
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("Format", { clear = true }),
      buffer = bufnr,
      callback = function() vim.lsp.buf.formatting_seq_sync() end
    })
  end
end

--terminal
require("toggleterm").setup({
 open_mapping = [[<c-\>]],
 auto_scroll = true,
 shade_filetypes = { "none", "fzf" },
 winbar = {
    enabled = false,
    name_formatter = function(term) --  term: Terminal
      return term.name
    end
  }
})

-- TypeScript
nvim_lsp.tsserver.setup {
  on_attach = on_attach,
  filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
  cmd = { "typescript-language-server", "--stdio" }
}

-- Formaters settings
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.code_actions.eslint,
        null_ls.builtins.formatting.prettier
    },
    on_attach = on_attach
})
EOF

" Lspsaga keys
nnoremap gr <cmd>Lspsaga rename<cr>
nnoremap gR <cmd>Lspsaga rename ++project<cr>

" Telescope keys
nnoremap gh <cmd>Telescope lsp_references<cr>
nnoremap tw <cmd>Telescope diagnostics<cr>
nnoremap gd <cmd>Telescope lsp_definitions<cr>
nnoremap ,b <cmd>Telescope buffers<cr>
nnoremap ,p <cmd>Telescope oldfiles<cr>
nnoremap ,ff <cmd>Telescope find_files<cr>
nnoremap ff <cmd>Telescope git_files<cr>
nnoremap ,g <cmd>Telescope live_grep<cr>
nnoremap ,v <cmd>Telescope neoclip<cr>
nnoremap gb <cmd>Telescope git_branches<cr>
nnoremap gs <cmd>Telescope git_status<cr>

lua << EOF
require('telescope').setup {
  pickers = {
    find_files = {
      theme = 'dropdown'
    },
    live_grep = {
      theme = 'dropdown'
    },
    git_branches = {
      theme = 'dropdown'
    },
    git_files = {
      theme = 'dropdown'
    },
    diagnostics = {
      theme = 'dropdown'
    },
    lsp_references = {
      --theme = 'default'
    },
    git_status= {
      theme = 'dropdown'
    },
    buffers = {
      theme = 'dropdown'
    },
    oldfiles = {
     theme = 'dropdown'
    },
    neoclip = {
      theme = 'dropdown'
    }
  }
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')
require('telescope').load_extension('neoclip')
require('telescope').load_extension('media_files')
require('neoclip').setup({
  history = 50,
  preview = true,
})


require("chafa").setup({
  render = {
    min_padding = 5,
    show_label = true,
  },
  events = {
    update_on_nvim_resize = true,
  },
})

EOF

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

lua << EOF
local lspkind = require 'lspkind'

lspkind.init({
    -- DEPRECATED (use mode instead): enables text annotations
    --
    -- default: true
    -- with_text = true,

    -- defines how annotations are shown
    -- default: symbol
    -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
    mode = 'symbol_text',

    -- default symbol map
    -- can be either 'default' (requires nerd-fonts font) or
    -- 'codicons' for codicon preset (requires vscode-codicons font)
    --
    -- default: 'default'
    preset = 'codicons',

    -- override preset symbols
    --
    -- default: {}
    symbol_map = {
      Text = "",
      Method = "",
      Function = "",
      Constructor = "",
      Field = "ﰠ",
      Variable = "",
      Class = "ﴯ",
      Interface = "",
      Module = "",
      Property = "ﰠ",
      Unit = "塞",
      Value = "",
      Enum = "",
      Keyword = "",
      Snippet = "",
      Color = "",
      File = "",
      Reference = "",
      Folder = "",
      EnumMember = "",
      Constant = "",
      Struct = "פּ",
      Event = "",
      Operator = "",
      TypeParameter = ""
    },
})

require("lspsaga").setup({
  server_filetype_map = {
    typescript = 'typescript'
  }
})

--[[require("lazy").setup({
{"neovim/nvim-lspconfig"},
{"nvim-tree/nvim-web-devicons"}, 
{"nvim-treesitter/nvim-treesitter"},
{"L3MON4D3/LuaSnip"},
{'hrsh7th/nvim-cmp'},
{'hrsh7th/cmp-nvim-lsp'},
{'hrsh7th/cmp-buffer'},
{'hrsh7th/cmp-path'},
{'saadparwaiz1/cmp_luasnip'},
{'hrsh7th/cmp-nvim-lua'}, 
{"VonHeikemen/lsp-zero.nvim"},
{'https://github.com/preservim/nerdtree', dependencies = { {"nvim-tree/nvim-web-devicons"} }},
{
  "glepnir/lspsaga.nvim",
    event = "LspAttach",
    config = function()
        require("lspsaga").setup({})
    end,
    dependencies = {
      {"nvim-tree/nvim-web-devicons"},
      --Please make sure you install markdown and markdown_inline parser
      {"nvim-treesitter/nvim-treesitter"},
      {'hrsh7th/cmp-nvim-lsp'},
      {"VonHeikemen/lsp-zero.nvim"}
    }
},
})--]]
EOF
