local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use "folke/twilight.nvim"
  use "folke/zen-mode.nvim"
  use "junegunn/limelight.vim"
  use "wbthomason/packer.nvim" -- Have packer manage itself
  use "ellisonleao/glow.nvim"
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "chrisbra/colorizer"
  use "lukas-reineke/indent-blankline.nvim"
  use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins
  use "hrsh7th/nvim-cmp" -- The completion plugin
  use "hrsh7th/cmp-buffer" -- buffer completions
  use "hrsh7th/cmp-path" -- path completions
  use "hrsh7th/cmp-cmdline" -- cmdline completions
  use "saadparwaiz1/cmp_luasnip" -- snippet completions
  use "L3MON4D3/LuaSnip" --snippet engine
  use "rafamadriz/friendly-snippets" -- a bunch of snippets to use
  use "hrsh7th/cmp-nvim-lsp"
  use "ntbbloodbath/doom-one.nvim"
  use "lunarvim/onedarker"
  use "navarasu/onedark.nvim"
  use "Shatur/neovim-ayu"
  use "rmehri01/onenord.nvim"
  use "neovim/nvim-lspconfig" -- enable LSP
  use "williamboman/nvim-lsp-installer" -- simple to use language server nvim-lsp-installer
  use "nvim-telescope/telescope.nvim"
  use "nvim-telescope/telescope-media-files.nvim"
  use "kyazdani42/nvim-tree.lua"
  use "windwp/nvim-autopairs"
  use "akinsho/toggleterm.nvim"
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  }
  use 'josephg2044/everblushdark.nvim'
  use "akinsho/bufferline.nvim"
  use "moll/vim-bbye"
  use "p00f/nvim-ts-rainbow"
  use "nvim-lualine/lualine.nvim"
  --  use "nvim-treesitter/playground"
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
