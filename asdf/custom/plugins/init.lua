return {
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
