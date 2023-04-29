--[[ plug.lua ]]

return require('packer').startup(function()
    use { 'sainnhe/gruvbox-material' }
    use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
    use 'wbthomason/packer.nvim' -- Packer package manager
    use 'williamboman/mason-lspconfig.nvim' -- closes gaps with mason
    use 'kyazdani42/nvim-tree.lua' -- Filesystem navigation
    use 'nvim-lualine/lualine.nvim' -- Statusline
    use {
        "windwp/nvim-autopairs", -- Autocomplete (), {}, []
        config = function() require("nvim-autopairs").setup {} end
    }
    use 'lewis6991/impatient.nvim' -- Makes neovim faster
    use 'tpope/vim-surround' -- Add "", '', (),
    use { 'phaazon/hop.nvim', branch = 'v2' } -- Navitage to any word in the file
    use 'onsails/lspkind.nvim' -- shows icons in cmp
    use 'j-hui/fidget.nvim' -- sho status of nvim-lsp progress
    use 'RRethy/vim-illuminate' -- Highlight other uses of word under cursor
    use "lukas-reineke/indent-blankline.nvim" -- ident lines
    use 'folke/trouble.nvim' -- Summarizes issues
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' } -- Make telescope faster
    use 'nvim-telescope/telescope.nvim' -- Fuzzy finder
    use {'nvim-telescope/telescope-ui-select.nvim' }
    use {'nvim-telescope/telescope-live-grep-args.nvim' }
    use 'BurntSushi/ripgrep' -- Telescope grep
    use 'sharkdp/fd' -- Finder
    use 'neovim/nvim-lspconfig' -- Collection of common configurations for the Nvim LSP client
    use 'hrsh7th/nvim-cmp' -- Completion framework
    use 'hrsh7th/cmp-nvim-lsp' -- LSP completion source for nvim-cmp
    use 'hrsh7th/cmp-nvim-lsp-signature-help'
    use 'hrsh7th/cmp-vsnip' -- Snippet completion source for nvim-cmp
    use 'hrsh7th/cmp-path' -- Useful completion sources
    use 'hrsh7th/cmp-buffer' -- Useful completion sources
    use 'hrsh7th/vim-vsnip' -- Snippet engine
    use 'nvim-lua/popup.nvim' -- Poup for telescope
    use 'nvim-treesitter/nvim-treesitter' -- better syntax
    use 'nvim-lua/plenary.nvim' -- Collection of Lua functions
    use 'williamboman/mason.nvim' -- Manage LSPs and DAPs
    use 'puremourning/vimspector' -- Debugger
    use 'mfussenegger/nvim-dap' -- Debugger
    use 'ruanyl/vim-gh-line' -- Plugin to copy link to github/gitlab 
end)
