local wezterm = require 'wezterm'
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

config.animation_fps = 30
config.max_fps = 60
config.font = wezterm.font_with_fallback({
  -- "ComicMonoNF",
  -- "FiraMono Nerd Font",
  -- "JetBrainsMono Nerd Font",
  "Iosevka Nerd Font",
  -- "Bruh-Font",
})
config.underline_thickness = 1
config.underline_position = -2.0

-- config.allow_square_glyphs_to_overflow_width = "Always"
config.allow_square_glyphs_to_overflow_width = "Never"

-- config.default_prog = { "sesh", "attach", "tab", "--create" }

config.font_size = 11.0

config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 50
config.automatically_reload_config = true
config.hide_tab_bar_if_only_one_tab = false

config.window_frame = {
  font = wezterm.font({ family = "Iosevka Nerd Font", weight = "Bold" }),
  font_size = 12.0,
  border_left_width = "0.0cell",
  border_right_width = "0.0cell",
  border_bottom_height = "0.10cell",
  border_bottom_color = "#1e1e2e",
  border_top_height = "0.0cell",
}

config.inactive_pane_hsb = {
  saturation = 1.0,
  brightness = 1.0,
}

config.window_decorations = "RESIZE"

config.window_padding = {
  top = 1,
  bottom = 1,
  left = 1,
  right = 1,
}

config.bypass_mouse_reporting_modifiers = "SHIFT"
config.disable_default_key_bindings = false
config.leader = { key = "w", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = require("keybinds").keys()

require("tab-bar")

return config
