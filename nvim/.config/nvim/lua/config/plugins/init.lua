local execute = vim.api.nvim_command
local packer = nil
-- check if packer is installed (~/.local/share/nvim/site/pack)
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local compile_path = install_path .. "/plugin/packer_compiled.lua"
local is_installed = vim.fn.empty(vim.fn.glob(install_path)) == 0


local function init()
    if not is_installed then
        if vim.fn.input("Install packer.nvim? (y for yes) ") == "y" then
            execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
            execute("packadd packer.nvim")
            print("Installed packer.nvim.")
            is_installed = 1
        end
    end

    if not is_installed then return end
    if packer == nil then
        packer = require('packer')
        packer.init({
            -- we don't want the compilation file in '~/.config/nvim'
	    disable_commands = true,
            compile_path = compile_path,
        })
    end

    local use = packer.use
    packer.reset()

    use 'wbthomason/packer.nvim'
    use {'lewis6991/impatient.nvim'}
    use 'neovim/nvim-lspconfig'
    use {
        'nvim-telescope/telescope.nvim',
        requires = {'nvim-lua/plenary.nvim'}
    }
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

    use 'elkowar/yuck.vim'

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

    -- Allows for nicely-defined keymappings.
    use {
        'LionC/nest.nvim',
        config = function()
            require('config.plugins.keymaps').setup()
        end
    }

    use {
        'tami5/lspsaga.nvim',
        config = function()
            require('lspsaga').setup()
        end
    }

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

    -- Git signs
    use {
        'lewis6991/gitsigns.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('gitsigns').setup()
        end
    }

    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }
end

local plugins = setmetatable({}, {
    __index = function(_, key)
        init()
        return packer[key]
    end,
})

return plugins
