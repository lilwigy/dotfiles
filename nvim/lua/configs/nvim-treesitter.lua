return vim.schedule(function()
	require("nvim-treesitter.configs").setup({
		highlight = { enable = true },
		indent = { enable = true },
		sync_install = false,
		ensure_installed = "all",
		endwise = { enable = true },
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<leader><space>",
				node_incremental = "<leader><space>",
				scope_incremental = false,
				node_decremental = "<bs>",
			},
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["af"] = { query = "@function.outer", desc = "Around Func" },
					["if"] = { query = "@function.inner", desc = "Inside Func" },
					["al"] = { query = "@loop.outer", desc = "Around Loop" },
					["il"] = { query = "@loop.inner", desc = "Inside Loop" },
					["ak"] = { query = "@class.outer", desc = "Around Class" },
					["ik"] = { query = "@class.inner", desc = "Inside Class" },
					["ap"] = { query = "@parameter.outer", desc = "Around Param" },
					["ip"] = { query = "@parameter.inner", desc = "Inside Param" },
					["a/"] = { query = "@comment.outer", desc = "Around Comment" },
					["ab"] = { query = "@block.outer", desc = "Around Block" },
					["ib"] = { query = "@block.inner", desc = "Inside Block" },
					["ac"] = { query = "@conditional.outer", desc = "Around Cond" },
					["ic"] = { query = "@conditional.inner", desc = "Inside Cond" },
				},
			},
			move = {
				enable = true,
				goto_next_start = {
					["]f"] = { query = "@function.outer", desc = "Func Next Start" },
					["]c"] = { query = "@class.outer", desc = "Class Next Start" },
					["]a"] = { query = "@parameter.inner", desc = "Param Next Start" },
					["]b"] = { query = "@block.outer", desc = "Block Next Start" },
					["]l"] = { query = "@loop.outer", desc = "Loop Next Start" },
					["]k"] = { query = "@conditional.outer", desc = "Cond Next Start" },
				},
				goto_next_end = {
					["]F"] = { query = "@function.outer", desc = "Func Next End" },
					["]C"] = { query = "@class.outer", desc = "Class Next End" },
					["]A"] = { query = "@parameter.inner", desc = "Param Next End" },
					["]B"] = { query = "@block.outer", desc = "Block Next End" },
					["]L"] = { query = "@loop.outer", desc = "Loop Next End" },
					["]K"] = { query = "@conditional.outer", desc = "Cond Next End" },
				},
				goto_previous_start = {
					["[f"] = { query = "@function.outer", desc = "Func Prev Start" },
					["[c"] = { query = "@class.outer", desc = "Class Prev Start" },
					["[a"] = { query = "@parameter.inner", desc = "Param Prev Start" },
					["[b"] = { query = "@block.outer", desc = "Blokc Prev Start" },
					["[l"] = { query = "@loop.outer", desc = "Loop Prev Start" },
					["[k"] = { query = "@conditional.outer", desc = "Cond Prev Start" },
				},
				goto_previous_end = {
					["[F"] = { query = "@function.outer", desc = "Func Prev End" },
					["[C"] = { query = "@class.outer", desc = "Prev Prev End" },
					["[A"] = { query = "@parameter.inner", desc = "Param Prev End" },
					["[B"] = { query = "@block.outer", desc = "Blokc Prev End" },
					["[L"] = { query = "@loop.outer", desc = "Loop Prev End" },
					["[K"] = { query = "@conditional.outer", desc = "Cond Prev End" },
				},
			},
		},
	})
end)
