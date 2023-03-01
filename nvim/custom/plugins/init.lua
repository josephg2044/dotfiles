return {
    ["mfussenegger/nvim-jdtls"] = {
        cmd = {
        --
        "java", -- Or the absolute path '/path/to/java11_or_newer/bin/java'
        "~/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_VERSION_NUMBER.jar",
        "-configuration", "/path/to/jdtls_install_location/config_SYSTEM",
        "-data", "/home/joseph/.local/share/nvim/java"
        },
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
    ["folke/which-key.nvim"] = false,
    ["goolord/alpha.nvim"] = false,
    -- ["NvChad/ui"] = {
        -- overrides_options = overrides.ui,
    -- },
    ["NvChad/ui"] = {
        override_options = {
            statusline = {
                separator_style = "block",
            },
        },
    },
    ["williamboman/mason.nvim"] = {
        override_options = {
            ensure_installed = {
            "pyright",
            "clangd",
            "jdtls"
            },
        },
    },
    ["neovim/nvim-lspconfig"] = {
        config = function()
            require "plugins.configs.lspconfig"
            require "custom.plugins.lspconfig"
        end,
    },
}
