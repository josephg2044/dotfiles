local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

local servers = { "clangd", "bashls", "jdtls", "texlab", "biome", "emmet_language_server", "ts_ls", "pylsp", "cmake"}


for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
end

lspconfig.emmet_language_server.setup {
    filetypes = { "css", "eruby", "html", "htmldjango", "javascriptreact", "less", "pug", "sass", "scss", "typescriptreact", "htmlangular", "javascript", },
}

lspconfig.biome.setup {
    root_dir = function(fname)
        return lspconfig.util.root_pattern("biome.json", "biome.jsonc")(fname)
            or lspconfig.util.find_package_json_ancestor(fname)
            or lspconfig.util.find_node_modules_ancestor(fname)
            or lspconfig.util.find_git_ancestor(fname)
    end,
}

-- lspconfig.pylsp.setup {
--     on_attach = on_attach,
--     capabilities = capabilities,
--     settings = {
--         pylsp = {
--             plugins = {
--                 pylint = { enabled = "false" },
--                 pyflakes = { enabled = "false" },
--                 pycodestyle = { enabled = "false" },
--             }
--         }
--     },
-- }
