-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
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
    config = function ()
      require('mason').setup()
    end
  }
  use { -- configure lang servers
    'neovim/nvim-lspconfig',
    requires = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      require("mason-lspconfig").setup_handlers {
        function(server_name) -- default handler
          require('lspconfig')[server_name].setup {}
        end,
      }
    end,
  }

  -- terraform
  use 'hashivim/vim-terraform'
  
  -- telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use 'sidebar-nvim/sidebar.nvim'

  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- vim: et ts=2 sw=0
