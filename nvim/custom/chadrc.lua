-- First read our docs (completely) then check the example_config repo

local M = {}

M.options = {
    nvChad = {
        update_url = "https://github.com/NvChad/NvChad",
        update_branch = "main",
    },
}

M.ui = {
  -- hl = highlights
    hl_add = {},
    hl_override = {},
    changed_themes = {
        yoru = {
            base_16 = {
                base08 = "#e05f65",
                base09 = "#7199ee",
                base0B = "#98bb6c",
                base0D = "#31afef",
                base0A = "#FFC552",
                base0E = "#c68aee",
            },
            base_30 = {
                green = "#78DBA9",
                pink = "#ff75a0",
                purple = "#c68aee",
                dark_purple = "#b77bdf",
                yellow = "#f1cf8a",
                sun = "#e7c580",
                red = "#e05f65",
                blue = "#569CD6",
                teal = "#519ABA",
                baby_pink = "#ea696f",
                pmenu_bg = "#61afef",
                folder_bg = "#61afef",

            }
        }
    },
    theme_toggle = { "yoru", "one_light" },
    theme = "yoru", -- default theme
    transparency = false,
}

-- chadrc
M.plugins = require "custom.plugins"

-- check core.mappings for table structure
M.mappings = require "custom.mappings"

return M
