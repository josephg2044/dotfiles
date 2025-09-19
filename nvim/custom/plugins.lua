local plugins = {
    -- overrides
    {
        "rafamadriz/friendly-snippets",
        enabled = false
        -- config = function()
        --     require("luasnip.loaders.from_vscode").load {
        --         exclude = { "latex" },
        --     }
        -- end
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
            conf.defaults.layout_config.height = 1.0
            conf.defaults.layout_config.width = 1.0
        end
    },

    {
        "folke/which-key.nvim",
        enabled = false,
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
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
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
    },
    {
        "kevinhwang91/nvim-ufo",
        event = "VeryLazy",
        dependencies = "kevinhwang91/promise-async",
        config = function()
            vim.o.foldcolumn = '0'
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
            vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
            vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

            local handler = function(virtText, lnum, endLnum, width, truncate)
                local newVirtText = {}
                local suffix = (' 󰅀 %d '):format(endLnum - lnum)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0
                for _, chunk in ipairs(virtText) do
                    local chunkText = chunk[1]
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if targetWidth > curWidth + chunkWidth then
                        table.insert(newVirtText, chunk)
                    else
                        chunkText = truncate(chunkText, targetWidth - curWidth)
                        local hlGroup = chunk[2]
                        table.insert(newVirtText, { chunkText, hlGroup })
                        chunkWidth = vim.fn.strdisplaywidth(chunkTzxt)
                        if curWidth + chunkWidth < targetWidth then
                            suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                        end
                        break
                    end
                    curWidth = curWidth + chunkWidth
                end
                table.insert(newVirtText, { suffix, 'MoreMsg' })
                return newVirtText
            end

            require('ufo').setup({
                provider_selector = function(bufnr, filetype, buftype)
                    return { 'treesitter', 'indent' }
                end,
                fold_virt_text_handler = handler
            })
        end
    },
    {
        'nvim-orgmode/orgmode',
        event = 'VeryLazy',
        ft = { 'org' },
        config = function()
            require('orgmode').setup({
                org_agenda_files = '~/orgfiles/**/*',
                org_default_notes_file = '~/orgfiles/refile.org',
            })
        end,
    },
    {
        "let-def/texpresso.vim",
        event = 'VeryLazy',
        config = function()
            require('texpresso').attach()
        end
    }
}
return plugins
