local M = {}

local nvim_lsp = require('lspconfig')
local capabilities = require('config.plugins.cmp').get_capabilities()

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
