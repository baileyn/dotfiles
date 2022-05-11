return require('packer').startup(function()
	use 'wbthomason/packer.nvim'

	-- Use the Github Neovim Theme
	use {
		'projekt0n/github-nvim-theme',
		config = function()
			require('github-theme').setup({
				theme_style = 'dark',
				function_style = 'italic',
				sidebars = {'qf', 'vista_kind', 'terminal', 'packer'},
				colors = {
					hint = 'orange',
					error = '#FF0000',
				},
				overrides = function(c)
					return {
						DiagnosticHint = { link = 'LspDiagnosticsDefaultHint' },
					}
				end
			})
		end
	}

	use 'neovim/nvim-lspconfig'

	use {
		'hrsh7th/nvim-cmp',
		requires = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',

			'hrsh7th/cmp-vsnip',
			'hrsh7th/vim-vsnip',
		},
		config = function()
			require('config.plugins.cmp').setup()
			require('config.plugins.lsp').setup()
		end
	}

	use 'tpope/vim-fugitive'

	-- Add components to show LSP Status in Status Line
	use 'nvim-lua/lsp-status.nvim'

	-- Status Line for Neovim
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true },
		config = function()
			require('config.plugins.statusline').setup()
		end
	}
end)
