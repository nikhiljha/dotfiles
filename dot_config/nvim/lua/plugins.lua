-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

return require('lazy').setup({
  -- package manager
  'folke/lazy.nvim',

  -- surround (lua rewrite of vim-surround, with dot-repeat built in)
  {
    'kylechui/nvim-surround',
    version = '^4.0.0',
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup()
    end,
  },

  -- git wrapper
  'tpope/vim-fugitive',

  -- language servers
  { -- automatically download lang servers
    'mason-org/mason.nvim',
    config = function()
      require('mason').setup()
    end
  },

  { -- configure lang servers
    'neovim/nvim-lspconfig',
    dependencies = {
      -- automatic language server installation
      { 'mason-org/mason-lspconfig.nvim',
        dependencies = {
          'mason-org/mason.nvim',
        },
      },
      -- autocomplete
      { 'hrsh7th/nvim-cmp',
        dependencies = {
          'hrsh7th/cmp-nvim-lsp',
          'hrsh7th/cmp-buffer',
          'hrsh7th/cmp-path',
          'hrsh7th/cmp-cmdline',
        },
        config = function()
          local cmp = require('cmp')
          cmp.setup({
            snippet = {
              expand = function(args)
                vim.snippet.expand(args.body)
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
      -- apply cmp capabilities to all LSP servers
      vim.lsp.config('*', {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      })

      -- metals (scala) handles its own lifecycle
      do
        local config = vim.tbl_deep_extend('force',
          require('metals').bare_config(),
          { capabilities = require('cmp_nvim_lsp').default_capabilities() }
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

      -- mason-lspconfig auto-enables installed servers via vim.lsp.enable()
      require("mason-lspconfig").setup()
    end,
  },

  -- telescope
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },

  -- sidebar
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      -- 'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },

    config = function()
      require("nvim-tree").setup()
    end
  },

  -- colors
  { 'catppuccin/nvim',
    name = 'catppuccin',
    config = function ()
      require("catppuccin").setup({
        flavour = "macchiato", -- latte, frappe, macchiato, mocha
        transparent_background = true, -- disables setting the background color.
        color_overrides = {},
      })

      vim.cmd.colorscheme "catppuccin"
    end
  },

  -- treesitter (parser installation only; highlighting is built-in as of nvim 0.12)
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          local ts = require('nvim-treesitter')
          local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
          if lang and not vim.list_contains(ts.get_installed(), lang) then
            ts.install(lang)
          end
        end,
      })
    end,
  },

  -- LaTeX
  'lervag/vimtex',

  -- null-ls
  {
    'nvimtools/none-ls.nvim',
    dependencies = { { 'nvim-lua/plenary.nvim' } },
    config = function()
      require("null-ls").setup({
        sources = {
          -- require("null-ls").builtins.diagnostics.vale,
          require("null-ls").builtins.formatting.black,
          require("null-ls").builtins.formatting.isort,
        },
      })
    end,
  },

  -- scala does its own thing for some reason
  {
    'scalameta/nvim-metals',
    dependencies = { "nvim-lua/plenary.nvim" }
  },
})

-- vim: et ts=2 sw=0
