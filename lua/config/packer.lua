return require('packer').startup(function()
	use 'wbthomason/packer.nvim'

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require'nvim-treesitter.configs'.setup {
                -- One of "all", "maintained" (parsers with maintainers), or a list of languages
                ensure_installed = "maintained",

                -- Install languages synchronously (only applied to `ensure_installed`)
                sync_install = false,

                indent = {
                    enabled = true,
                },

                highlight = {
                    -- `false` will disable the whole extension
                    enable = true,

                    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                    -- Using this option may slow down your editor, and you may see some duplicate highlights.
                    -- Instead of true it can also be a list of languages
                    additional_vim_regex_highlighting = false,
                },
            }
        end
    }

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
