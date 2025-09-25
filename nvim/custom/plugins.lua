local plugins = {
	-- overrides
	{
		"rafamadriz/friendly-snippets",
		enabled = false,
		-- config = function()
		--     require("luasnip.loaders.from_vscode").load {
		--         exclude = { "ltex" },
		--     }
		-- end
	},

	{
		"numToStr/Comment.nvim",
		enabled = false,
	},

	{
		"windwp/nvim-autopairs",
		enabled = false,
	},

	{
		"nvim-tree/nvim-tree.lua",
		opts = function()
			local conf = require("plugins.configs.nvimtree")
			conf.view.side = "right"
		end,
	},

	{
		"ggandor/leap.nvim",
		lazy = false,
		config = function()
			require("leap").set_default_mappings()
		end,
	},

	{
		"nvim-mini/mini.pick",
		lazy = false,
		opts = {
			options = {
				content_from_bottom = true,
				use_cache = true,
			},
			window = {
				config = nil,
				prompt_caret = " ",
				prompt_prefix = " ",
			},
		},
	},

	{
		"nvim-mini/mini.surround",
		version = false,
		lazy = false,
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
		"nvim-mini/mini.splitjoin",
		version = false,
		lazy = false,
		config = function()
			require("mini.splitjoin").setup()
		end,
	},

	{
		"nvim-mini/mini.pairs",
		version = false,
		lazy = false,
		opts = {
			modes = { insert = true, command = true, terminal = false },
			skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
			skip_ts = { "string" },
			skip_unbalanced = true,
			markdown = true,
		},
		config = function(_, opts)
			require("mini.pairs").setup(opts)
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		lazy = false,
	},

	{
		"nvim-mini/mini.ai",
		lazy = false,
		opts = function()
			local ai = require("mini.ai")
			return {
				n_lines = 500,
				custom_textobjects = {
					b = ai.gen_spec.treesitter({
						a = { "@block.outer", "@conditional.outer", "@loop.outer" },
						i = { "@block.inner", "@conditional.inner", "@loop.inner" },
					}),
					f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
					c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
					a = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
					t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
					d = { "%f[%d]%d+" },
					e = {
						{
							"%u[%l%d]+%f[^%l%d]",
							"%f[%S][%l%d]+%f[^%l%d]",
							"%f[%P][%l%d]+%f[^%l%d]",
							"^[%l%d]+%f[^%l%d]",
						},
						"^().*()$",
					},
				},
			}
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		opts = function()
			local conf = require("plugins.configs.others").blankline
			conf.show_first_indent_level = true
			conf.show_trailing_blankline_indent = false
		end,
	},

	{
		"hrsh7th/nvim-cmp",
		enabled = false,
		opts = function()
			local conf = require("plugins.configs.cmp")
			local cmp = require("cmp")
			conf.view = { docs = { auto_open = false } }
			conf.performance = { max_view_entries = 10 }
			conf.mapping["<Tab>"] = nil
			conf.mapping["<S-Tab>"] = nil
			conf.mapping["<CR>"] = nil
			conf.mapping["<C-Space>"] = cmp.mapping.confirm({ select = "true" })
			conf.mapping["<C-j>"] = cmp.mapping.select_next_item()
			conf.mapping["<C-k>"] = cmp.mapping.select_prev_item()
			conf.mapping["<C-y>"] = function()
				if cmp.visible_docs() then
					cmp.close_docs()
				else
					cmp.open_docs()
				end
			end
		end,
	},

	{
		"L3MON4D3/LuaSnip",
		opts = { history = true, updateevents = "TextChanged,TextChangedI" },
		config = function(_, opts)
			require("plugins.configs.others").luasnip(opts)
		end,
	},

	{
		"rebelot/colorful-menu.nvim",
		lazy = false,
		config = function()
			require("colorful-menu").setup()
		end,
	},

	{
		"saghen/blink.cmp",
		version = "1.*",
		lazy = false,
		opts = {
			snippets = {
				preset = "luasnip",
			},

			appearance = {
				nerd_font_variant = "normal",
				use_nvim_cmp_as_default = true,
			},

			completion = {
				keyword = {
					range = "full",
				},
				accept = {
					auto_brackets = {
						enabled = true,
					},
				},
				menu = {
					draw = {
						-- We don't need label_description now because label and label_description are already
						-- combined together in label by colorful-menu.nvim.
						columns = { { "kind_icon" }, { "label", gap = 1 } },
						components = {
							label = {
								text = function(ctx)
									return require("colorful-menu").blink_components_text(ctx)
								end,
								highlight = function(ctx)
									return require("colorful-menu").blink_components_highlight(ctx)
								end,
							},
						},
					},
				},
				documentation = {
					auto_show = false,
					auto_show_delay_ms = 100,
				},
				ghost_text = {
					enabled = false,
				},
			},

			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},

			cmdline = {
				enabled = true,
				keymap = { preset = "cmdline" },
				completion = {
					list = { selection = { preselect = false } },
					menu = {
						auto_show = function(ctx)
							return vim.fn.getcmdtype() == ":"
						end,
					},
					ghost_text = { enabled = true },
				},
			},

			keymap = {
				preset = "enter",
				["<C-k>"] = { "select_prev" },
				["<C-j>"] = { "select_next" },
				["<C-e>"] = { "hide" },
				["<C-y>"] = { "show_documentation" },
				["<A-k>"] = { "scroll_documentation_down" },
				["<A-j>"] = { "scroll_documentation_up" },
			},
		},
		config = function(_, opts)
			require("blink.cmp").setup(opts)
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		enabled = false,
	},

	{
		"folke/which-key.nvim",
		enabled = false,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			indent = { enable = true },
			highlight = { enable = true },
			folds = { enable = true },
			ensure_installed = {
				-- defaults
				"lua",
				"vim",
				"markdown",

				"html",
				"css",
				"javascript",
				"typescript",
				"json",

				"c",
				"cpp",
				"python",
			},
			disable = { "latex" },
		},
	},

	{
		"williamboman/mason.nvim",
		override_options = {
			ensure_installed = {
				"pyright",
				"clangd",
				"cpp-tools",
				"texlab",
				"biome",
				"emmet-language-server",
				"typescript-lanugage-server",
				"ruff",
			},
		},
	},

	{
		"neovim/nvim-lspconfig",
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end,
	},

	-- new plugins

	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		lazy = false,
		opts = {},
	},

	{
		"lervag/vimtex",
		lazy = false,
	},

	{
		"nvim-orgmode/orgmode",
		event = "VeryLazy",
		ft = { "org" },
		config = function()
			require("orgmode").setup({
				org_agenda_files = "~/orgfiles/**/*",
				org_default_notes_file = "~/orgfiles/refile.org",
			})
		end,
	},

	{
		"let-def/texpresso.vim",
		event = "VeryLazy",
		config = function()
			require("texpresso").attach()
		end,
	},

	{
		"stevearc/conform.nvim",
		event = "VeryLazy",
		lazy = false,
		config = function()
			require("conform").setup({
				log_level = vim.log.levels.DEBUG,
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "ruff_format" },
					cpp = { "clang-format" },
					c = { "clang-format" },
					js = { "prettier" },
					html = { "prettier" },
					css = { "prettier" },
					tex = { "tex-fmt" },
				},
				default_format_opts = {
					lsp_format = "fallback",
				},
			})
		end,
	},

	{
		"hat0uma/csvview.nvim",
		opts = {
			parser = { comments = { "#", "//" } },
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
}
return plugins
