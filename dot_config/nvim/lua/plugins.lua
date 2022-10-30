-- This file can be loaded by calling `lua require('plugins')` from your init.vim

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
              ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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
  use 'sidebar-nvim/sidebar.nvim'

  -- colors
  use { 'folke/tokyonight.nvim',
    config = function()
      vim.cmd[[colorscheme tokyonight]]
    end
  }

  -- fix cursor hold
  use {
      'antoinemadec/FixCursorHold.nvim',
      config = function()
          vim.g.cursorhold_updatetime = 500
      end,
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- vim: et ts=2 sw=0
