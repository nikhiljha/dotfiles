-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
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

  -- code completion
  use 'dense-analysis/ale'

  -- terraform
  use 'hashivim/vim-terraform'
  
  -- telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use 'sidebar-nvim/sidebar.nvim'

end)

-- vim: et ts=2 sw=0
