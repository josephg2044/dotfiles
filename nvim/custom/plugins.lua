local plugins = {
    {
        "mfussenegger/nvim-jdtls",
        root_dir = function() return vim.fs.dirname(vim.fs.find({ '.gradlew', '.gitignore', 'mvnw', 'build.grade.kts' }, { upward = true })[1]) .. "\\" end,
        settings = {
            java = {
                signatureHelp = {enabled = true},
                import = {enabled = true},
                rename = {enabled = true}
            }
        },
        init_options = {
            bundles = {}
        }
    },
    -- ["NvChad/ui"] = {
        -- overrides_options = overrides.ui,
    -- },
    {
        "williamboman/mason.nvim",
        override_options = {
            ensure_installed = {
            "pyright",
            "clangd",
            "clang-format",
            "cpp-tools",
            "java-debug-adapter",
            "google-java-format",
            "jdtls"
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
                "cpp-tools",
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
    }
}
return plugins
