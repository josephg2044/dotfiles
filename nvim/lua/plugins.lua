return {
	"nvim-lua/plenary.nvim",
	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle", "NvimTreeFocus" },
		opts = function()
			dofile(vim.g.base46_cache .. "nvimtree")

			return {
				filters = { dotfiles = false },
				disable_netrw = true,
				hijack_cursor = true,
				sync_root_with_cwd = true,
				update_focused_file = {
					enable = true,
					update_root = false,
				},
				view = {
					side = "right",
					width = 30,
					preserve_window_proportions = true,
				},
				renderer = {
					root_folder_label = false,
					highlight_git = true,
					indent_markers = { enable = true },
					icons = {
						glyphs = {
							default = "󰈚",
							folder = {
								default = "",
								empty = "",
								empty_open = "",
								open = "",
								symlink = "",
							},
							git = {
								unstaged = "U",
								staged = "S",
								untracked = "?",
								deleted = "D",
								renamed = "R",
							},
						},
					},
				},
			}
		end,
	},

	-- git stuff
	{
		"lewis6991/gitsigns.nvim",
		event = "User FilePost",
		opts = function()
			dofile(vim.g.base46_cache .. "git")
			return {
				signs = {
					delete = { text = "󰍵" },
					changedelete = { text = "󱕖" },
				},
			}
		end,
	},

	-- lsp stuff
	{
		"mason-org/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUpdate" },
		opts = function()
			dofile(vim.g.base46_cache .. "mason")

			return {
				PATH = "skip",

				ui = {
					icons = {
						package_pending = " ",
						package_installed = " ",
						package_uninstalled = " ",
					},
				},
				ensure_installed = {
					"bash-language-server",
					"clang-format",
					"cmake-language-server",
					"lua-language-server",
					"prettier",
					"tex-fmt",
					"ty",
					"clangd",
					"texlab",
					"biome",
					"typescript-language-server",
					"ruff",
					"stylua",
				},

				max_concurrent_installers = 10,
			}
		end,
	},

	{
		"neovim/nvim-lspconfig",
		event = "User FilePost",
		config = function()
			local M = {}
			local map = vim.keymap.set

			-- export on_attach & capabilities
			M.on_attach = function(_, bufnr)
				local function opts(desc)
					return { buffer = bufnr, desc = "LSP " .. desc }
				end

				map("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
				map("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
				map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts("Add workspace folder"))
				map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts("Remove workspace folder"))

				map("n", "<leader>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, opts("List workspace folders"))

				map("n", "<leader>D", vim.lsp.buf.type_definition, opts("Go to type definition"))
				map("n", "<leader>ra", require("core.renamer.init"), opts("NvRenamer"))
			end

			-- disable semanticTokens
			M.on_init = function(client, _)
				if vim.fn.has("nvim-0.11") ~= 1 then
					if client.supports_method("textDocument/semanticTokens") then
						client.server_capabilities.semanticTokensProvider = nil
					end
				else
					if client:supports_method("textDocument/semanticTokens") then
						client.server_capabilities.semanticTokensProvider = nil
					end
				end
			end

			M.capabilities = vim.lsp.protocol.make_client_capabilities()

			M.capabilities.textDocument.completion.completionItem = {
				documentationFormat = { "markdown", "plaintext" },
				snippetSupport = true,
				preselectSupport = true,
				insertReplaceSupport = true,
				labelDetailsSupport = true,
				deprecatedSupport = true,
				commitCharactersSupport = true,
				tagSupport = { valueSet = { 1 } },
				resolveSupport = {
					properties = {
						"documentation",
						"detail",
						"additionalTextEdits",
					},
				},
			}

			M.defaults = function()
				dofile(vim.g.base46_cache .. "lsp")
				local x = vim.diagnostic.severity

				vim.diagnostic.config({
					virtual_text = { prefix = "" },
					signs = { text = { [x.ERROR] = "E", [x.WARN] = "W", [x.INFO] = "I", [x.HINT] = "H" } },
					underline = true,
					float = { border = "none" },
				})

				vim.api.nvim_create_autocmd("LspAttach", {
					callback = function(args)
						M.on_attach(_, args.buf)
					end,
				})

				local lua_lsp_settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						workspace = {
							library = {
								vim.fn.expand("$VIMRUNTIME/lua"),
							},
						},
					},
				}

				-- Use new vim.lsp.config API for Neovim 0.11+
				vim.lsp.config("*", { capabilities = M.capabilities, on_init = M.on_init })
				vim.lsp.config("lua_ls", { settings = lua_lsp_settings })

				local servers = {
					"lua_ls",
					"clangd",
					"bashls",
					"jdtls",
					"biome",
					"ty",
					"cmake",
					"texlab",
				}

				vim.lsp.enable(servers)
			end

			return M.defaults()
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
		build = ":TSUpdate | TSInstallAll",
		opts = function()
			pcall(function()
				dofile(vim.g.base46_cache .. "syntax")
				dofile(vim.g.base46_cache .. "treesitter")
			end)

			return {
				indent = { enable = true },
				highlight = { enable = true },
				folds = { enable = true },
				ensure_installed = {
					"vim",
					"lua",
					"vimdoc",
					"html",
					"css",
					"markdown",
					"javascript",
					"typescript",
					"json",
					"c",
					"cpp",
					"python",
					"rust",
				},
				disable = { "latex" },
			}
		end,
	},

	{
		"nvim-tree/nvim-web-devicons",
		opts = function()
			dofile(vim.g.base46_cache .. "devicons")
			return {
				override = {
					default_icon = { icon = "󰈚", name = "Default" },
					js = { icon = "󰌞", name = "js" },
					ts = { icon = "󰛦", name = "ts" },
					lock = { icon = "󰌾", name = "lock" },
					["robots.txt"] = { icon = "󰚩", name = "robots" },
				},
			}
		end,
	},

	{
		"nvchad/base46",
		build = function()
			require("base46").load_all_highlights()
			dofile(vim.g.base46_cache .. "defaults")
			dofile(vim.g.base46_cache .. "statusline")
		end,
	},

	-- {
	-- 	"nvchad/ui",
	-- 	lazy = false,
	-- 	config = function()
	-- 		require("nvchad")
	-- 	end,
	-- },
	--
	{
		"saghen/blink.cmp",
		version = "1.*",
		event = { "InsertEnter", "CmdLineEnter" },
		opts_extend = { "sources.default" },
		opts = function()
			dofile(vim.g.base46_cache .. "blink")
			return {
				cmdline = { enabled = true },
				appearance = { nerd_font_variant = "normal" },
				fuzzy = { implementation = "prefer_rust" },
				sources = { default = { "lsp", "buffer", "path" } },

				keymap = {
					preset = "default",
					["<CR>"] = { "accept", "fallback" },
					["<C-j>"] = { "select_next", "snippet_forward", "fallback" },
					["<C-k>"] = { "select_prev", "snippet_backward", "fallback" },
				},

				signature = { enabled = true },

				completion = {
					ghost_text = { enabled = true },
					documentation = {
						auto_show = true,
						auto_show_delay_ms = 200,
						window = { border = "double" },
					},

					menu = {
						scrollbar = false,
						border = "none",
						draw = {
							padding = { 0, 1 },
							columns = { { "kind_icon" }, { "label" }, { "kind" } },
							components = {
								kind_icon = {
									text = function(ctx)
										local icons = {
											Namespace = "󰌗",
											Text = "󰉿",
											Method = "󰆧",
											Function = "󰆧",
											Constructor = "",
											Field = "󰜢",
											Variable = "󰀫",
											Class = "󰠱",
											Interface = "",
											Module = "",
											Property = "󰜢",
											Unit = "󰑭",
											Value = "󰎠",
											Enum = "",
											Keyword = "󰌋",
											Snippet = "",
											Color = "󱓻",
											File = "󰈚",
											Reference = "󰈇",
											Folder = "󰉋",
											EnumMember = "",
											Constant = "󰏿",
											Struct = "󰙅",
											Event = "",
											Operator = "󰆕",
											TypeParameter = "󰊄",
											Table = "",
											Object = "󰅩",
											Tag = "",
											Array = "[]",
											Boolean = "",
											Number = "",
											Null = "󰟢",
											Supermaven = "",
											String = "󰉿",
											Calendar = "",
											Watch = "󰥔",
											Package = "",
											Copilot = "",
											Codeium = "",
											TabNine = "",
											BladeNav = "",
										}

										return " " .. (icons[ctx.kind] or "󰈚") .. " "
									end,
								},

								kind = {
									highlight = "comment",
								},
							},
						},
					},
				},
			}
		end,
	},

	{
		"stevearc/conform.nvim",
		opts = {
			log_level = vim.log.levels.WARN,
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_format" },
				cpp = { "clang-format" },
				c = { "clang-format" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				tex = { "tex-fmt" },
			},
			default_format_opts = {
				lsp_format = "fallback",
			},
		},
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		event = "User FilePost",
		opts = {
			indent = { char = "│", highlight = "IblChar" },
			scope = { char = "│", highlight = "IblScopeChar" },
		},
		config = function(_, opts)
			dofile(vim.g.base46_cache .. "blankline")

			local hooks = require("ibl.hooks")
			hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
			require("ibl").setup(opts)

			dofile(vim.g.base46_cache .. "blankline")
		end,
	},

	{
		"windwp/nvim-autopairs",
		event = { "InsertEnter", "CmdLineEnter" },
		opts = {
			fast_wrap = {},
		},
	},

	{
		url = "https://codeberg.org/andyg/leap.nvim",
		event = "VeryLazy",
		config = function()
			vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
		end,
	},

	{
		"nvim-mini/mini.surround",
		event = "VeryLazy",
		opts = {
			mappings = {
				add = "gsa",
				delete = "gsd",
				find = "gsf",
				find_left = "gsF",
				highlight = "gsh",
				replace = "gsr",
				update_n_lines = "gsn",
			},
		},
		config = function(_, opts)
			require("mini.surround").setup(opts)
		end,
	},

	{
		"L3MON4D3/LuaSnip",
		ft = "tex",
		opts = {
			history = true,
			updateevents = "TextChanged,TextChangedI",
			enable_autosnippets = true,
			store_selection_keys = "<Tab>",
		},
		config = function(_, opts)
			require("luasnip").config.set_config(opts)
			require("luasnip.loaders.from_lua").load()
			require("luasnip.loaders.from_lua").lazy_load({ paths = vim.g.lua_snippets_path or "" })

			local map = vim.keymap.set
			map("i", "<Tab>", function()
				local luasnip = require("luasnip")
				if luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				else
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
				end
			end, { desc = "LuaSnip: expand/jump", silent = true })

			map("i", "<S-Tab>", function()
				local luasnip = require("luasnip")
				if luasnip.locally_jumpable(-1) then
					luasnip.jump(-1)
				end
			end, { desc = "LuaSnip: jump back", silent = true })

			map("i", "<C-h>", function()
				local luasnip = require("luasnip")
				if luasnip.choice_active() then
					luasnip.change_choice(1)
				end
			end, { desc = "LuaSnip: next choice", silent = true })

			map("i", "<C-l>", function()
				local luasnip = require("luasnip")
				if luasnip.choice_active() then
					luasnip.change_choice(-1) -- fixed from -11
				end
			end, { desc = "LuaSnip: prev choice", silent = true })
		end,
	},

	{
		"lervag/vimtex",
		ft = { "tex" },
		init = function()
			vim.g.vimtex_quickfix_open_on_warning = 0
			vim.g.vimtex_quickfix_ignore_filters = {
				[[Underfull \\hbox]],
				[[Overfull \\hbox]],
				[[LaTeX Warning: .\+ float specifier changed to]],
				[[LaTeX hooks Warning]],
				[[Package siunitx Warning: Detected the "physics" package:]],
				[[Package hyperref Warning: Token not allowed in a PDF string]],
			}
			vim.g.vimtex_view_method = "zathura"
			vim.g.latex_view_general_viewer = "zathura"
			vim.g.vimtex_compiler_progname = "nvr"
			vim.g.smartindent = false
			vim.g.autoindent = false
			vim.g.vimtex_toc_config = {
				split_pos = ":vert :botright",
				split_width = 30,
				show_help = 1,
			}
			vim.g.vimtex_delim_toggle_mod_list = {
				{ "\\left", "\\right" },
				{ "\\big", "\\big" },
			}
		end,
	},

	{
		"hat0uma/csvview.nvim",
		ft = "csv",
		opts = {
			parseroverview = { comments = { "#", "//" } },
			keymaps = {
				textobject_field_inner = { "if", mode = { "o", "x" } },
				textobject_field_outer = { "af", mode = { "o", "x" } },
				jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
				jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
				jump_next_row = { "<Enter>", mode = { "n", "v" } },
				jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
			},
		},
		cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
	},

	{
		"hedyhli/outline.nvim",
		lazy = true,
		cmd = { "Outline", "OutlineOpen" },
		keys = {
			{ "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
		},
		dependencies = {
			"epheien/outline-treesitter-provider.nvim",
		},
		opts = {
			preview_window = {
				live = true,
			},

			providers = {
				priority = { "lsp", "markdown", "man" },
			},

			symbols = {
				icon_fetcher = function(kind, bufnr, symbol)
					return kind:sub(1, 1)
				end,
			},
		},
	},

	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = "FzfLua",
		opts = {
			winopts = {
				height = 1.00, -- window height
				width = 1.00, -- window width
				row = 0.35, -- window row position (0=top, 1=bottom)
				col = 0.50, -- window col position (0=left, 1=right)
				border = "none",
				fullscreen = true, -- start fullscreen?
				preview = {
					border = "none", -- preview border: accepts both `nvim_open_win`
					vertical = "down:45%", -- up|down:size
					horizontal = "right:65%", -- right|left:size
				},
			},
			keymap = {
				builtin = {
					["<F2>"] = "toggle-fullscreen",
					["<F3>"] = "toggle-preview-wrap",
					["<F4>"] = "toggle-preview",
					["<M-h>"] = "preview-reset",
					["<M-j>"] = "preview-page-down",
					["<M-k>"] = "preview-page-up",
				},
			},
		},
	},
	{
		"dimtion/guttermarks.nvim",
		event = { "BufReadPost", "BufNewFile", "BufWritePre", "FileType" },
	},
}
