local plugins = {
    -- overrides
    {
        "rafamadriz/friendly-snippets",
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load {
                exclude = { "tex" },
            }
        end
    },
    {
        "nvim-tree/nvim-tree.lua",
        opts = function()
            local conf = require "plugins.configs.nvimtree"
            conf.view.side = "right"
        end
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        opts = function()
            local conf = require("plugins.configs.others").blankline
            conf.show_first_indent_level = true
            conf.show_trailing_blankline_indent = true
        end,
    },

    {
        "hrsh7th/nvim-cmp",
        opts = function()
            local conf = require "plugins.configs.cmp"
            local cmp = require "cmp"
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
        end
    },

    {
        "nvim-telescope/telescope.nvim",
        opts = function()
            local conf = require "plugins.configs.telescope"
            conf.defaults.layout_config.height = 0.99
            conf.defaults.layout_config.width = 0.99
        end
    },

    {
        "folke/which-key.nvim",
        enabled = false,
    },

    {
        "mfussenegger/nvim-jdtls",
        root_dir = function()
            return vim.fs.dirname(vim.fs.find({ '.gradlew', '.gitignore', 'mvnw', 'build.grade.kts' },
                { upward = true })[1]) .. "\\"
        end,
        settings = {
            java = {
                signatureHelp = { enabled = true },
                import = { enabled = true },
                rename = { enabled = true }
            }
        },
        init_options = {
            bundles = {}
        }
    },

    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                -- defaults
                "lua",
                "vimdoc",
                "luadoc",
                "vim",
                "markdown",

                "html",
                "css",
                "javascript",
                "typescript",
                "json",

                "c",
                "cpp",
                "java",
                "python",
            },
            disable = { "latex" }
        },
    },

    {
        "williamboman/mason.nvim",
        override_options = {
            ensure_installed = {
                "pyright",
                "clangd",
                "cpp-tools",
                "java-debug-adapter",
                "google-java-format",
                "jdtls",
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
            require "plugins.configs.lspconfig"
            require "custom.configs.lspconfig"
        end,
    },

    -- new plugins
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    },

    {
        "jose-elias-alvarez/null-ls.nvim",
        event = "VeryLazy",
        opts = function()
            return require "custom.configs.null-ls"
        end,
    },

    {
        "mfussenegger/nvim-dap",
        config = function(_, _)
            require("core.utils").load_mappings("dap")
        end
    },

    {
        "jay-babu/mason-nvim-dap.nvim",
        event = "VeryLazy",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
        },
        opts = {
            handlers = {},
            ensure_installed = {
                "codelldb",
            }
        },
    },

    {
        "rcarriga/nvim-dap-ui",
        event = "VeryLazy",
        dependencies = "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end
    },
    { "nvim-neotest/nvim-nio" },
    {
        "lervag/vimtex",
        lazy = false,
        init = function()
            -- vim.g.vimtex_compiler_latexmk = { outdir = "./build" }
            -- vim.g.tex_flavor = "latex"
            -- vim.opt.conceallevel = 0
        end
    }
}
return plugins
