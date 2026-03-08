require("duckdb"):setup({
	mode = "standard",
	row_id = true,
})
require("git"):setup()

require("session"):setup({
	sync_yanked = true,
})
