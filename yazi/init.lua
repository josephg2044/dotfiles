require("duckdb"):setup({
	mode = "standard",
	row_id = true,
})
require("git"):setup()

require("whoosh"):setup({
	-- Configuration bookmarks (cannot be deleted through plugin)
	bookmarks = {},

	-- Notification settings
	jump_notify = false,

	-- Key generation for auto-assigning bookmark keys
	keys = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",

	-- File path for storing user bookmarks
	path = (os.getenv("HOME") .. "/.config/yazi/bookmark"),

	-- Path truncation in navigation menu
	path_truncate_enabled = false, -- Enable/disable path truncation
	path_max_depth = 3, -- Maximum path depth before truncation

	-- Path truncation in fuzzy search (fzf)
	fzf_path_truncate_enabled = false, -- Enable/disable path truncation in fzf
	fzf_path_max_depth = 5, -- Maximum path depth before truncation in fzf

	-- Long folder name truncation
	path_truncate_long_names_enabled = false, -- Enable in navigation menu
	fzf_path_truncate_long_names_enabled = false, -- Enable in fzf
	path_max_folder_name_length = 20, -- Max length in navigation menu
	fzf_path_max_folder_name_length = 20, -- Max length in fzf

	-- History directory settings
	history_size = 10, -- Number of directories in history (default 10)
	history_fzf_path_truncate_enabled = false, -- Enable/disable path truncation by depth for history
	history_fzf_path_max_depth = 5, -- Maximum path depth before truncation for history (default 5)
	history_fzf_path_truncate_long_names_enabled = false, -- Enable/disable long folder name truncation for history
	history_fzf_path_max_folder_name_length = 30, -- Maximum length for folder names in history (default 30)
})

require("simple-tag"):setup({
	-- UI display mode (icon, text, hidden)
	ui_mode = "icon", -- (Optional)

	-- Disable tag key hints (popup in bottom right corner)
	hints_disabled = true, -- (Optional)

	-- linemode order: adjusts icon/text position. Fo example, if you want icon to be on the mose left of linemode then set linemode_order larger than 1000.
	-- More info: https://github.com/sxyazi/yazi/blob/077faacc9a84bb5a06c5a8185a71405b0cb3dc8a/yazi-plugin/preset/components/linemode.lua#L4-L5
	linemode_order = 500, -- (Optional)

	-- You can backup/restore this folder within the same OS (Linux, windows, or MacOS).
	-- But you can't restore backed up folder in the different OS because they use difference absolute path.
	-- save_path =  -- full path to save tags folder (Optional)
	--       - Linux/MacOS: os.getenv("HOME") .. "/.config/yazi/tags"
	--       - Windows: os.getenv("APPDATA") .. "\\yazi\\config\\tags"

	-- Set tag colors
	colors = { -- (Optional)
		-- Set this same value with `theme.toml` > [mgr] > hovered > reversed
		-- Default theme use "reversed = true".
		-- More info: https://github.com/sxyazi/yazi/blob/077faacc9a84bb5a06c5a8185a71405b0cb3dc8a/yazi-config/preset/theme-dark.toml#L25
		reversed = true, -- (Optional)

		-- More colors: https://yazi-rs.github.io/docs/configuration/theme#types.color
		-- format: [tag key] = "color"
		["*"] = "#bf68d9", -- (Optional)
		["$"] = "green",
		["!"] = "#cc9057",
		["1"] = "cyan",
		["p"] = "red",
	},

	-- Set tag icons. Only show when ui_mode = "icon".
	-- Any text or nerdfont icons should work as long as you use nerdfont to render yazi.
	-- Default icon from mactag.yazi: ●; Some generic icons: , , 󱈤
	-- More icon from nerd fonts: https://www.nerdfonts.com/cheat-sheet
	icons = { -- (Optional)
		-- default icon
		default = "󰚋",

		-- format: [tag key] = "tag icon"
		["*"] = "*",
		["$"] = "",
		["!"] = "",
		["p"] = "",
	},
})

require("session"):setup({
	sync_yanked = true,
})
