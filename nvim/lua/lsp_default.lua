local methods = vim.lsp.protocol.Methods

local function lsp_custom_code_action(bufnr)
	local code_action = {}
	local cfg = {
		code_action_icon = "💡",
		delay = 15, -- second
		sign = true,
		sign_priority = 40,
		virtual_text = true,
	}

	local sign_name = "MyCustomLightBulb"
	local sign_group = "MyCodeAction"

	local need_check_diagnostic = { ["go"] = true, ["python"] = true }

	local function code_action_update_virtual_text(line, actions)
		local namespace = vim.api.nvim_create_namespace(sign_group)
		pcall(vim.api.nvim_buf_clear_namespace, 0, namespace, 0, -1)
		vim.api.nvim_buf_del_extmark(bufnr, namespace, 1)
		if line then
			pcall(vim.api.nvim_buf_set_extmark, 0, namespace, line, -1, {
				virt_text = {
					{ " " .. cfg.code_action_icon .. string.rep(" ", 2) .. actions[1].title, "CodeActionVirtulText" },
				},
				hl_mode = "combine",
			})
		end
	end

	local function code_action_update_sign(line)
		if vim.tbl_isempty(vim.fn.sign_getdefined(sign_name)) then
			vim.fn.sign_define(sign_name, { text = cfg.code_action_icon, texthl = "CodeActionVirtulText" })
		end
		local winid = vim.api.nvim_get_current_win()
		if code_action[winid] == nil then
			code_action[winid] = {}
		end
		-- only show code action on the current line, remove all others
		if code_action[winid].lightbulb_line and code_action[winid].lightbulb_line > 0 then
			vim.fn.sign_unplace(sign_group, { id = code_action[winid].lightbulb_line, buffer = "%" })
		end

		if line then
			local id =
				vim.fn.sign_place(line, sign_group, sign_name, "%", { lnum = line + 1, priority = cfg.sign_priority })
			code_action[winid].lightbulb_line = id
		end
	end

	local function code_action_render_virtual_text(line, diagnostics)
		return function(_, actions, _)
			if actions == nil or type(actions) ~= "table" or vim.tbl_isempty(actions) then
				-- no actions cleanup
				if cfg.virtual_text then
					code_action_update_virtual_text(nil)
				end
				if cfg.sign then
					code_action_update_sign(nil)
				end
			else
				if cfg.sign then
					if need_check_diagnostic[vim.bo.filetype] then
						if next(diagnostics) == nil then
							-- no diagnostic, no code action sign..
							code_action_update_sign(nil)
						else
							code_action_update_sign(line)
						end
					else
						code_action_update_sign(line)
					end
				end

				if not cfg.virtual_text then
					return
				end
				if need_check_diagnostic[vim.bo.filetype] and not next(diagnostics) then
					code_action_update_virtual_text()
				else
					code_action_update_virtual_text(line, actions)
				end
			end

			vim.defer_fn(function()
				if cfg.virtual_text then
					code_action_update_virtual_text(nil)
				end
				if cfg.sign then
					code_action_update_sign(nil)
				end
			end, cfg.delay * 1000)
		end
	end

	local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
	local diagnostics = vim.diagnostic.get(bufnr, { lnum = lnum })
	local winid = vim.api.nvim_get_current_win()

	code_action[winid] = code_action[winid] or {}
	code_action[winid].lightbulb_line = code_action[winid].lightbulb_line or 0

	local params = vim.lsp.util.make_range_params()
	params.context = { diagnostics = diagnostics }
	local line = params.range.start.line
	local callback = code_action_render_virtual_text(line, diagnostics)
	vim.lsp.buf_request(bufnr, methods.textDocument_codeAction, params, callback)
end

local function lsp_custom_rename()
	local renameHandler = vim.lsp.handlers[methods.textDocument_rename]
	vim.lsp.handlers[methods.textDocument_rename] = function(err, result, ctx, config)
		renameHandler(err, result, ctx, config)
		if err or not result then
			return
		end
		local changes = result.changes or result.documentChanges or {}
		local changedFiles = vim.tbl_keys(changes)
		changedFiles = vim.tbl_filter(function(file)
			return #changes[file] > 0
		end, changedFiles)
		changedFiles = vim.tbl_map(function(file)
			return "- " .. vim.fs.basename(file)
		end, changedFiles)
		local changeCount = 0
		for _, change in pairs(changes) do
			changeCount = changeCount + #(change.edits or change)
		end
		local msg = string.format("%s instance%s", changeCount, (changeCount > 1 and "s" or ""))
		if #changedFiles > 1 then
			msg = msg .. (" in %s files:\n"):format(#changedFiles) .. table.concat(changedFiles, "\n")
		end
		return vim.notify_once(string.format("Renamed with LSP %s", msg), 2)
	end
end

local function lsp_custom_utils(client, bufnr)
	local enabled = true
	if client.supports_method(methods.textDocument_inlayHint) then
		vim.keymap.set("n", "<leader>uh", function()
			enabled = not enabled
			if enabled then
				vim.notify("Disabled Inlay Hint", vim.diagnostic.severity.WARN, { title = "Inlay Hint" })
				vim.lsp.inlay_hint.enable(bufnr, false)
			else
				vim.notify("Enabled Inlay Hint", vim.diagnostic.severity.WARN, { title = "Inlay Hint" })
				vim.lsp.inlay_hint.enable(bufnr, true)
			end
		end, { desc = "Toggle inlay hint" })
	else
		return vim.notify_once("Method [textDocument/inlayHint] not supported!", 2)
	end

	if client.server_capabilities.codeActionProvider then
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			group = vim.api.nvim_create_augroup("MyCodeAction", { clear = false }),
			buffer = bufnr,
			callback = function()
				lsp_custom_code_action(bufnr)
			end,
		})
	else
		return vim.notify_once("Method [textDocument/codeAction] not supported!", 2)
	end

	if client.server_capabilities.documentSymbolProvider then
		vim.g.navic_silence = true
		require("nvim-navic").attach(client, bufnr)
	else
		return vim.notify_once("Document symbol provider not supported winbar will be disabled!", 2)
	end

	if client.supports_method(methods.textDocument_codeLens) then
		vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
			buffer = bufnr,
			group = vim.api.nvim_create_augroup("CodeLensRefersh", { clear = true }),
			callback = vim.lsp.codelens.refresh,
		})
	else
		return vim.notify_once("Method [textDocument/codeLens] not supported!", 2)
	end

	if client.supports_method(methods.textDocument_documentHighlight) then
		local cursor_hl_group = vim.api.nvim_create_augroup("cursor_highlights", { clear = true })
		vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave", "BufEnter" }, {
			group = cursor_hl_group,
			desc = "Highlight references under the cursor",
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
		})

		vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
			group = cursor_hl_group,
			desc = "Clear highlight references",
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
		})
	else
		vim.notify_once("Method [textDocument/documentHighlight] not supported!", 2)
		return
	end
end

local capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), {
	textDocument = {
		foldingRange = { dynamicRegistration = false, lineFoldingOnly = true },
		semanticTokens = { augmentsSyntaxTokens = false },
		formatting = { dynamicRegistration = false },
		completion = {
			dynamicRegistration = false,
			completionItem = {
				snippetSupport = true,
				commitCharactersSupport = true,
				deprecatedSupport = true,
				preselectSupport = true,
				tagSupport = { valueSet = { 1 } },
				insertReplaceSupport = true,
				resolveSupport = {
					properties = {
						"documentation",
						"detail",
						"additionalTextEdits",
						"sortText",
						"filterText",
						"insertText",
						"textEdit",
						"insertTextFormat",
						"insertTextMode",
					},
				},
				insertTextModeSupport = { valueSet = { 1, 2 } },
				labelDetailsSupport = true,
			},
			contextSupport = true,
			insertTextMode = 1,
			completionList = {
				itemDefaults = { "commitCharacters", "editRange", "insertTextFormat", "insertTextMode", "data" },
			},
		},
	},
	general = { positionEncodings = { "utf-8" } },
	experimental = {
		hoverActions = true,
		hoverRange = true,
		serverStatusNotification = true,
		snippetTextEdit = true,
		codeActionGroup = true,
		ssr = true,
	},
})

local function fzflsp(builtin, opts)
	local params = { builtin = builtin, opts = opts }
	return function()
		builtin = params.builtin
		opts = params.opts
		opts = vim.tbl_deep_extend("force", {
			fzf_opts = {
				["--info"] = "right",
				["--no-preview"] = true,
				["--preview-window"] = "hidden",
				["--ansi"] = true,
			},
		}, opts or {})
		require("fzf-lua")[builtin](opts)
	end
end

local function lsp_keymaps(client, bufnr)
	local handler_keys = require("lazy.core.handler.keys")
	if not handler_keys.resolve then
		return {}
	end

	local skip = { mode = true, id = true, ft = true, rhs = true, lhs = true }
	local keymaps = handler_keys.resolve({
        -- stylua: ignore start
		{ "gd", "<cmd>Trouble lsp_definitions<cr>", desc = "Definition", has = methods.textDocument_definition },
		{ "gD", "<cmd>Trouble lsp_type_definitions<cr>", desc = "Type Definitions", has = methods.textDocument_typeDefinition },
		{ "<leader>gr", "<cmd>Trouble lsp_references<cr>", desc = "References", has = methods.textDocument_references },
		{ "<leader>gy", "<cmd>Trouble lsp_implementations<cr>", desc = "Implementation", has = methods.textDocument_implementation },
		{ "<leader>gl", vim.lsp.codelens.run, desc = "Run Codelens", has = methods.textDocument_codeLens },
		{ "<leader>gd", fzflsp("lsp_declarations"), desc = "Declaration", has = methods.textDocument_declaration },
		{ "<leader>gs", fzflsp("lsp_document_symbols"), desc = "Document Symbols", has = methods.textDocument_documentSymbol },
		{ "<leader>gS", fzflsp("lsp_live_workspace_symbols"), desc = "Workspace Symbols", has = methods.workspace_symbol },
		{ "<leader>gi", fzflsp("lsp_incoming_calls"), desc = "Incoming Calls", has = methods.callHierarchy_incomingCalls },
		{ "<leader>go", fzflsp("lsp_outgoing_calls"), desc = "Outgoing Calls", has = methods.callHierarchy_outgoingCalls },
		{ "<leader>gn", vim.lsp.buf.rename, desc = "Rename Symbol", has = methods.textDocument_rename },
		{ "K", vim.lsp.buf.hover, desc = "Hover Document", has = methods.textDocument_hover },
		{ "<C-k>", vim.lsp.buf.signature_help, desc = "Signature Help", mode = { "i" }, has = methods.textDocument_signatureHelp },
		{ "<leader>gx", fzflsp("diagnostics_document"), desc = "Buffer Diagnostics", has = methods.workspace_diagnostic },
		{ "<leader>gX", fzflsp("diagnostics_workspace"), desc = "Workspace Diagnostics", has = methods.workspace_diagnostic },
		{ "<leader>ga", function() vim.lsp.buf.add_workspace_folder() vim.notify("Added to Workspace") end, desc = "Add Workspace", has = methods.workspace_workspaceFolders },
		{ "<leader>gq", function() vim.lsp.buf.remove_workspace_folder() vim.notify("Folder has been Removed") end, desc = "Remove Workspace", has = methods.workspace_workspaceFolders },
		{ "<leader>gw", function() for _, list in pairs(vim.lsp.buf.list_workspace_folders()) do vim.notify(tostring(list), 2, { title = "List Workspace" }) end end, desc = "List Workspace", has = methods.workspace_workspaceFolders },
		-- stylua: ignore end
		{ "<leader>gc", vim.lsp.buf.code_action, desc = "Code Action", has = methods.textDocument_codeAction },
		{
			"<leader>gC",
			function()
				vim.lsp.buf.code_action({
					context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() },
					range = {
						start = vim.api.nvim_buf_get_mark(bufnr, "<"),
						["end"] = vim.api.nvim_buf_get_mark(bufnr, ">"),
					},
				})
			end,
			desc = "Range Code Action",
			has = methods.textDocument_codeAction,
			mode = { "v" },
		},
	})
	for _, keys in pairs(keymaps) do
		if not keys.has or client.supports_method(keys.has) then
			local opts = {}
			for k, v in pairs(keys) do
				if type(k) ~= "number" and not skip[k] then
					opts[k] = v
				end
			end
			opts.has = nil
			opts.silent = opts.silent ~= false
			opts.buffer = bufnr
			vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
		end
	end
end

return {
	default = {
		on_attach = function(client, bufnr)
			if vim.b.bigfile or vim.b.midfile then
				return vim.lsp.buf_detach_client(bufnr, client.id)
			else
				lsp_custom_rename()
				lsp_custom_utils(client, bufnr)
				lsp_keymaps(client, bufnr)
			end
		end,
		capabilities = capabilities,
	},
	lsp_keymaps = lsp_keymaps,
}
