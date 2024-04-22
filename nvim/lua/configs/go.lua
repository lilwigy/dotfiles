require("go").setup({
	disables = false,
	go = "go",
	goimports = "goimports",
	fillstruct = "gopls",
	gopls_cmd = {
		require("mason-registry").get_package("gopls"):get_install_path() .. "/gopls",
		"-logfile",
		vim.fn.tempname() .. "-gople.log",
	},
	gopls_remote_auto = true, -- add -remote=auto to gopls
	gofmt = false,
	tag_transform = false,
	tag_options = "",
	icons = false,
	verbose = false,
	lsp_gofumpt = false,
	lsp_keymaps = false,
	lsp_inlay_hints = { enable = false },
	sign_priority = 5,
	textobjects = false,
	trouble = true,
	test_efm = false,
	luasnip = true,
	iferr_vertical_shift = 4,
	dap_debug = true,
	diagnostic = require("utils").diagnostic_conf,
	dap_debug_keymap = false,
	dap_debug_vt = { enabled_commands = true, all_frames = true },
	dap_port = 38697,
	dap_timeout = 15,
	dap_retries = 20,
	dap_debug_gui = {
		floating = { border = "solid" },
		layouts = {
			{
				elements = {
					{ id = "scopes", size = 0.2 },
					{ id = "breakpoints", size = 0.2 },
					{ id = "stacks", size = 0.2 },
					{ id = "watches", size = 0.2 },
					{ id = "console", size = 0.2 },
				},
				position = "right",
				size = 55,
			},
			{
				elements = { { id = "repl", size = 1 } },
				position = "bottom",
				size = 8,
			},
		},
	},
	lsp_on_attach = function(client, bufnr)
        require"utils.lsp.default".on_attach(client,bufnr)
		if not client.server_capabilities.semanticTokensProvider then
			local semantic = client.config.capabilities.textDocument.semanticTokens
			client.server_capabilities.semanticTokensProvider = {
				full = true,
				legend = { tokenTypes = semantic.tokenTypes, tokenModifiers = semantic.tokenModifiers },
				range = true,
			}
		end
	end,
	lsp_cfg = {
		-- capabilities = require("lsp_default").capabilities,
		settings = {
			gopls = {
				gofumpt = false,
				codelenses = {
					gc_details = false,
					generate = true,
					regenerate_cgo = true,
					run_govulncheck = true,
					test = true,
					tidy = true,
					upgrade_dependency = true,
					vendor = true,
				},
				hints = {
					assignVariableTypes = true,
					compositeLiteralFields = true,
					compositeLiteralTypes = true,
					constantValues = true,
					functionTypeParameters = true,
					parameterNames = true,
					rangeVariableTypes = true,
				},
				analyses = {
					fieldalignment = true,
					nilness = true,
					unusedparams = true,
					unusedwrite = true,
					useany = true,
					unreachable = true,
					ST1003 = true,
					undeclaredname = true,
					fillreturns = true,
					nonewvars = true,
					shadow = true,
				},
				usePlaceholders = true,
				completeUnimported = true,
				staticcheck = true,
				directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
				semanticTokens = true,
				matcher = "Fuzzy",
				diagnosticsDelay = "500ms",
				symbolMatcher = "fuzzy",
				buildFlags = { "-tags", "integration" },
			},
		},
	},
})
