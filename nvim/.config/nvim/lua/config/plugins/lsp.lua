local M = {}

local nvim_lsp = require('lspconfig')
local lsp_status = require('lsp-status')
local capabilities = require('config.plugins.cmp').get_capabilities()

lsp_status.register_progress()
capabilities = vim.tbl_extend('keep', capabilities, lsp_status.capabilities)

local on_attach = function(client, bufnr)
    require'nest'.applyKeymaps {
        { mode = 'n', {
                { 'gr', '<cmd>lua require"lspsaga.provider".lsp_finder()<CR>' },
                { 'gD', '<cmd>lua require"lspsaga.provider".preview_definition()<CR>' },
                { 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>' },
                { 'ca', '<cmd>lua require"lspsaga.codeaction".code_action()<CR>' },
                { 'K', '<cmd>lua require"lspsaga.hover".render_hover_doc()<CR>' },
                { '<C-k>', '<cmd>lua require"lspsaga.signaturehelp".signature_help()<CR>' },
                { 'rn', '<cmd>lua require"lspsaga.rename".rename()<CR>' },
                { '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>' },
                { ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>' },
            },
        },
        { mode = 'v', {
                { 'ca', ':<C-U>lua require"lspsaga.codeaction".range_code_action()<CR>' },
            },
        }
    }

    lsp_status.on_attach(client, bufnr)
end

function M.setup()
	local servers = {'rust_analyzer', 'pyright', 'gopls'}
	for _, lsp in ipairs(servers) do
		nvim_lsp[lsp].setup {
			capabilities = capabilities,
			on_attach = on_attach,
			flags = {
				debounce_text_changes = 150,
			}
		}
	end
end

return M
