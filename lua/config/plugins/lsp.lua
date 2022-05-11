local M = {}

local nvim_lsp = require('lspconfig')
local lsp_status = require('lsp-status')
local capabilities = require('config.plugins.cmp').get_capabilities()

lsp_status.register_progress()
capabilities = vim.tbl_extend('keep', capabilities, lsp_status.capabilities)

function M.setup()
	local servers = {'rust_analyzer', 'pyright', 'gopls'}
	for _, lsp in ipairs(servers) do
		nvim_lsp[lsp].setup {
			capabilities = capabilities,
			on_attach = lsp_status.on_attach,
			flags = {
				debounce_text_changes = 150,
			}
		}
	end
end

return M
