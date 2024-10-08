local wezterm = require("wezterm")
local act = wezterm.action
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

local theme = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]

theme.background = "#1e1e2e"
theme.tab_bar.background = "#1e1e2e"
theme.tab_bar.inactive_tab.bg_color = "#1e1e2e"
theme.tab_bar.inactive_tab.fg_color = "#545c7e"
theme.tab_bar.active_tab.bg_color = "#24273a"
theme.tab_bar.active_tab.fg_color = "#c0caf5"
theme.tab_bar.new_tab.bg_color = "#1e1e2e"
theme.tab_bar.new_tab.fg_color = "#1e1e2e"

config.color_schemes = {
	["Catppuccin Theme"] = theme,
}

config.color_scheme = "Catppuccin Theme"

-- config.enable_wayland = true
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

config.colors = {
	indexed = { [241] = "#65bcff" },
}

config.underline_thickness = 1
config.cursor_thickness = 1
config.underline_position = -6
config.hide_mouse_cursor_when_typing = true
config.default_cursor_style = "BlinkingBar"
config.force_reverse_video_cursor = true
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
-- window_background_opacity = 0.9,
config.cell_width = 0.8
config.scrollback_lines = 10000
-- config.animation_fps = 30
-- config.max_fps = 60
-- config.font = wezterm.font("Maple Mono", {
--   -- weight = 'Regular',
--   italic = false
-- }
-- )
-- config.allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace" -- "Never", "Always", "WhenFollowedBySpace"
-- config.font_size = 10.5

-- config.font = wezterm.font_with_fallback({
-- "JetBrainsMono Nerd Font",
-- "Maple Mono",
-- "Iosevka Nerd Font",
-- "ComicMonoNF",
-- "FiraMono Nerd Font",
-- })

config.font_size = 10.5
config.font = wezterm.font({ family = "Fira Code", weight = "Regular" })
config.bold_brightens_ansi_colors = true
config.font_rules = {
	{
		intensity = "Bold",
		italic = true,
		font = wezterm.font({ family = "Maple Mono", weight = "Bold", style = "Italic" }),
	},
	{
		italic = true,
		intensity = "Half",
		font = wezterm.font({ family = "Maple Mono", weight = "DemiBold", style = "Italic" }),
	},
	{
		italic = true,
		intensity = "Normal",
		font = wezterm.font({ family = "Maple Mono", style = "Italic" }),
	},
}
-- config.dpi = 192.0
-- config.bold_brightens_ansi_colors = true

-- config.default_prog = { "sesh", "attach", "tab", "--create" }

-- config.line_height = 0.9
config.automatically_reload_config = true

config.window_frame = {
	font = wezterm.font({ family = "Maple Mono", weight = "Bold" }),
	-- font_size = 10.5,
	border_left_width = "0.0cell",
	border_right_width = "0.0cell",
	border_bottom_height = "0.0cell",
	border_top_height = "0.0cell",
	border_bottom_color = "#1e1e2e",
}

config.inactive_pane_hsb = {
	saturation = 1.0,
	brightness = 1.0,
}

config.window_decorations = "RESIZE"

config.window_padding = {
	left = "0cell",
	right = "0cell",
	top = "0cell",
	bottom = "0cell",
}

-- KEYBINDS
config.bypass_mouse_reporting_modifiers = "SHIFT"
config.disable_default_key_bindings = true
config.leader = { key = "Space", mods = "CTRL" }

config.keys = require("keybinds").keys()
config.key_tables = require("keybinds").key_tables()
require("tabs").setup(config)
require("mouse").setup(config)
require("links").setup(config)
-- require("keys").setup(config)
-- TAB BAR
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.show_tabs_in_tab_bar = true
config.tab_max_width = 50
config.show_new_tab_button_in_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.audible_bell = "Disabled"

-- require("tab-bar")

config.launch_menu = {
	{
		args = { "top" },
	},
	{
		-- Optional label to show in the launcher. If omitted, a label
		-- is derived from the `args`
		label = "Bash",
		-- The argument array to spawn.  If omitted the default program
		-- will be used as described in the documentation above
		args = { "bash", "-l" },

		-- You can specify an alternative current working directory;
		-- if you don't specify one then a default based on the OSC 7
		-- escape sequence will be used (see the Shell Integration
		-- docs), falling back to the home directory.
		-- cwd = "/some/path"

		-- You can override environment variables just for this command
		-- by setting this here.  It has the same semantics as the main
		-- set_environment_variables configuration option described above
		-- set_environment_variables = { FOO = "bar" },
	},
}

return config
