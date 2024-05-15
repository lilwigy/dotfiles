local ensure_installed = {
	"ada",
	"agda",
	"angular",
	"apex",
	"arduino",
	"astro",
	"authzed",
	"awk",
	"bash",
	"bass",
	"beancount",
	"bibtex",
	"bicep",
	"bitbake",
	"blueprint",
	"c",
	"c_sharp",
	"cairo",
	"capnp",
	"chatito",
	"clojure",
	"cmake",
	"comment",
	"commonlisp",
	"cooklang",
	"corn",
	"cpon",
	"cpp",
	"css",
	"csv",
	"cuda",
	"cue",
	"d",
	"dart",
	"devicetree",
	"dhall",
	"diff",
	"dockerfile",
	"dot",
	"doxygen",
	"dtd",
	"ebnf",
	"eds",
	"eex",
	"elixir",
	"elm",
	"elsa",
	"elvish",
	"embedded_template",
	"erlang",
	"facility",
	"fennel",
	"firrtl",
	"fish",
	"foam",
	"forth",
	"fortran",
	"fsh",
	"func",
	"fusion",
	"gdscript",
	"git_config",
	"git_rebase",
	"gitattributes",
	"gitcommit",
	"gitignore",
	"gleam",
	"glimmer",
	"glsl",
	"gn",
	"go",
	"godot_resource",
	"gomod",
	"gosum",
	"gowork",
	"gpg",
	"graphql",
	"groovy",
	"gstlaunch",
	"hack",
	"hare",
	"haskell",
	"haskell_persistent",
	"hcl",
	"heex",
	"hjson",
	"hlsl",
	"hocon",
	"hoon",
	"html",
	"htmldjango",
	"http",
	"hurl",
	"ini",
	"ispc",
	"janet_simple",
	"java",
	"javascript",
	"jq",
	"jsdoc",
	"json",
	"json5",
	"jsonc",
	"jsonnet",
	"julia",
	"kconfig",
	"kdl",
	"kotlin",
	"kusto",
	"lalrpop",
	"latex",
	"ledger",
	"leo",
	"linkerscript",
	"liquidsoap",
	"llvm",
	"lua",
	"luadoc",
	"luap",
	"luau",
	"m68k",
	"make",
	"markdown",
	"markdown_inline",
	"matlab",
	"menhir",
	"mermaid",
	"meson",
	"mlir",
	"nasm",
	"nickel",
	"nim",
	"nim_format_string",
	"ninja",
	"nix",
	"norg",
	"nqc",
	"objc",
	"objdump",
	"ocaml",
	"ocaml_interface",
	"ocamllex",
	"odin",
	"org",
	"pascal",
	"passwd",
	"pem",
	"perl",
	"php",
	"phpdoc",
	"pioasm",
	"po",
	"pod",
	"poe_filter",
	"pony",
	"prisma",
	"promql",
	"properties",
	"proto",
	"prql",
	"psv",
	"pug",
	"puppet",
	"purescript",
	"pymanifest",
	"python",
	"ql",
	"qmldir",
	"qmljs",
	"query",
	"r",
	"racket",
	"rasi",
	"rbs",
	"re2c",
	"regex",
	"rego",
	"requirements",
	"rnoweb",
	"robot",
	"ron",
	"rst",
	"ruby",
	"rust",
	"scala",
	"scfg",
	"scheme",
	"scss",
	"slang",
	"slint",
	"smali",
	"smithy",
	"snakemake",
	"solidity",
	"soql",
	"sosl",
	"sparql",
	"sql",
	"squirrel",
	"ssh_config",
	"starlark",
	"strace",
	"styled",
	"supercollider",
	"surface",
	"svelte",
	"swift",
	"sxhkdrc",
	"systemtap",
	"t32",
	"tablegen",
	"teal",
	"templ",
	"terraform",
	"textproto",
	"thrift",
	"tiger",
	"tlaplus",
	"todotxt",
	"toml",
	"tsv",
	"tsx",
	"turtle",
	"twig",
	"typescript",
	"typoscript",
	"udev",
	"ungrammar",
	"unison",
	"usd",
	"uxntal",
	"v",
	"vala",
	"verilog",
	"vhs",
	"vim",
	"vimdoc",
	"vue",
	"wgsl",
	"wgsl_bevy",
	"xcompose",
	"xml",
	"yaml",
	"yang",
	"yuck",
	"zig",
}

vim.schedule(function()
	require("nvim-treesitter.configs").setup({
		highlight = { enable = true },
		indent = { enable = true },
		sync_install = true,
		ensure_installed = ensure_installed,
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
			-- select = {
			-- 	enable = true,
			-- 	lookahead = true,
			-- 	keymaps = {
			-- 		["af"] = { query = "@function.outer", desc = "Around Func" },
			-- 		["if"] = { query = "@function.inner", desc = "Inside Func" },
			-- 		["al"] = { query = "@loop.outer", desc = "Around Loop" },
			-- 		["il"] = { query = "@loop.inner", desc = "Inside Loop" },
			-- 		["ak"] = { query = "@class.outer", desc = "Around Class" },
			-- 		["ik"] = { query = "@class.inner", desc = "Inside Class" },
			-- 		["ap"] = { query = "@parameter.outer", desc = "Around Param" },
			-- 		["ip"] = { query = "@parameter.inner", desc = "Inside Param" },
			-- 		["a/"] = { query = "@comment.outer", desc = "Around Comment" },
			-- 		["ab"] = { query = "@block.outer", desc = "Around Block" },
			-- 		["ib"] = { query = "@block.inner", desc = "Inside Block" },
			-- 		["ac"] = { query = "@conditional.outer", desc = "Around Cond" },
			-- 		["ic"] = { query = "@conditional.inner", desc = "Inside Cond" },
			-- 	},
			-- },
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
