-- Only required if you have packer configured as `opt`
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
    install_path })
end
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- package manager
  use 'wbthomason/packer.nvim'

  -- sensible defaults
  use 'tpope/vim-sensible'
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'

  -- quotes as a textobj
  use 'preservim/vim-textobj-quote'

  -- git wrapper
  use 'tpope/vim-fugitive'

  -- language servers
  use { -- automatically download lang servers
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end
  }
  use { -- configure lang servers
    'neovim/nvim-lspconfig',
    requires = {
      -- automatic language server installation
      { 'williamboman/mason-lspconfig.nvim',
        requires = {
          -- packer won't install dependencies of this for some reason
          'williamboman/mason.nvim',
        },
      },
      -- autocomplete
      { 'hrsh7th/nvim-cmp',
        requires = {
          'hrsh7th/cmp-nvim-lsp',
          'hrsh7th/cmp-buffer',
          'hrsh7th/cmp-path',
          'hrsh7th/cmp-cmdline',
          'hrsh7th/vim-vsnip',
        },
        config = function()
          local cmp = require('cmp')
          cmp.setup({
            snippet = {
              -- REQUIRED - you must specify a snippet engine
              expand = function(args)
                vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
              end,
            },
            window = {
              -- completion = cmp.config.window.bordered(),
              -- documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.abort(),
              ['<Tab>'] = cmp.mapping.select_next_item(),
              ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            }),
            sources = cmp.config.sources({
              { name = 'nvim_lsp' },
            }, {
              { name = 'buffer' },
            })
          })

          -- Set configuration for specific filetype.
          cmp.setup.filetype('gitcommit', {
            sources = cmp.config.sources({
              -- { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
            }, {
              { name = 'buffer' },
            })
          })

          -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
          cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
              { name = 'buffer' }
            }
          })

          -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
          cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
              { name = 'path' }
            }, {
              { name = 'cmdline' }
            })
          })
        end,
      },
    },

    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
      do
        local config = vim.tbl_deep_extend('force',
          require('metals').bare_config(),
          { capabilities = capabilities }
        )
        local augrp = vim.api.nvim_create_augroup('cfg-lsp-metals', { clear = true })
        vim.api.nvim_create_autocmd('FileType', {
          pattern = { 'scala', 'sbt' },
          callback = function()
            vim.opt_local.shortmess:remove('F')
            require('metals').initialize_or_attach(config)
          end,
          group = augrp,
        })
      end
      require("mason-lspconfig").setup_handlers {
        function(server_name) -- default handler
          require('lspconfig')[server_name].setup {
            capabilities = capabilities
          }
        end,
      }
    end,
  }

  -- terraform
  use 'hashivim/vim-terraform'

  -- telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  -- sidebar
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly', -- optional, updated every week. (see issue #1193)
    config = function()
      require("nvim-tree").setup()
    end
  }

  -- colors
  use { 'folke/tokyonight.nvim',
    config = function()
      vim.cmd [[colorscheme tokyonight]]
    end
  }

  -- fix cursor hold
  use {
    'antoinemadec/FixCursorHold.nvim',
    config = function()
      vim.g.cursorhold_updatetime = 500
      vim.api.nvim_create_autocmd({ 'CursorHold' }, {
        group = vim.api.nvim_create_augroup('lsphold', {}),
        callback = function()
          vim.diagnostic.open_float({ focus = false })
        end
      })
    end,
  }

  -- telescope wants this
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
    config = function()
      require 'nvim-treesitter.configs'.setup {
        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        auto_install = true,

        highlight = {
          -- `false` will disable the whole extension
          enable = false,

          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
      }
    end
  }

  -- LaTeX
  use 'lervag/vimtex'

  -- null-ls
  use {
    'jose-elias-alvarez/null-ls.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } },
    config = function()
      require("null-ls").setup({
        sources = {
          -- require("null-ls").builtins.diagnostics.vale,
          require("null-ls").builtins.formatting.black,
          require("null-ls").builtins.formatting.isort,
        },
      })
    end,
  }

  -- scala does its own thing for some reason
  use {
    'scalameta/nvim-metals',
    requires = { "nvim-lua/plenary.nvim" }
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- vim: et ts=2 sw=0
