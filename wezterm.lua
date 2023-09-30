local wezterm = require 'wezterm'
local act = wezterm.action
local nf = wezterm.nerdfonts
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
-- config.tab_max_width = 11
config.automatically_reload_config = true
config.hide_tab_bar_if_only_one_tab = true

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

-- if wezterm.config_builder then
--   config = wezterm.config_builder()
--   config:set_strict_mode(false)
-- end

local process_icons = {
  ["docker"] = {
    Text = nf.linux_docker,
  },
  ["docker-compose"] = {
    Text = nf.linux_docker,
  },
  ["kuberlr"] = {
    Text = nf.linux_docker,
  },
  ["kubectl"] = {
    Text = nf.linux_docker,
  },
  ["nvim"] = {
    Text = nf.custom_vim,
  },
  ["vim"] = {
    Text = nf.custom_vim, --nf.dev_vim,
  },
  ["node"] = {
    Text = nf.md_hexagon,
  },
  ["zsh"] = {
    Text = nf.md_lambda,
    -- Text = nf.dev_terminal_badge,
    -- Text = nf.mdi_apple_keyboard_command,
  },
  ["bash"] = {
    Text = nf.cod_terminal_bash,
  },
  ["btm"] = {
    Text = nf.md_chart_donut_variant,
  },
  ["htop"] = {
    Text = nf.md_chart_donut_variant,
  },
  ["cargo"] = {
    Text = nf.dev_rust,
  },
  ["rust"] = {
    Text = nf.dev_rust,
  },
  ["go"] = {
    Text = nf.md_language_go,
  },
  ["lazydocker"] = {
    Text = nf.linux_docker,
  },
  ["git"] = {
    Text = nf.dev_git,
  },
  ["lua"] = {
    Text = nf.seti_lua,
  },
  ["wget"] = {
    Text = nf.md_arrow_down_box,
  },
  ["curl"] = {
    Text = nf.md_flattr,
  },
  ["gh"] = {
    Text = nf.dev_github_badge,
  },
}

local function basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local function is_vim(pane)
  -- local vim = {
  -- 	vim = true,
  -- 	nvim = true,
  -- }
  -- this is set by the plugin, and unset on ExitPre in Neovim
  return (pane:get_user_vars().IS_NVIM == "true") -- or vim[get_proc_title(pane)] == true
end

local direction_keys = {
  -- reverse lookup
  Up = "Up",
  Down = "Down",
  Left = "Left",
  Right = "Right",
  h = "Left",
  j = "Down",
  k = "Up",
  l = "Right",
  UpArrow = "Up",
  DownArrow = "Down",
  LeftArrow = "Left",
  RightArrow = "Right",
}
local function split_nav(resize_or_move, key)
  local mods = resize_or_move == "resize" and "ALT" or "CTRL"
  return {
    key = key,
    mods = mods,
    action = wezterm.action_callback(function(win, pane)
      local vim = is_vim(pane)

      local matches = {
        zellij = true,
        rx = true,
      }

      local exe = basename(pane:get_foreground_process_info().executable)
      if vim or matches[exe] then
        win:perform_action({
          SendKey = { key = key, mods = mods },
        }, pane)
        return
      end

      if resize_or_move == "resize" then
        win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
      else
        win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
      end
    end),
  }
end
config.bypass_mouse_reporting_modifiers = "SHIFT"
config.disable_default_key_bindings = false

-- config.leader = { key = "w", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
  -- split_nav("move", "h"),
  -- split_nav("move", "j"),
  -- split_nav("move", "k"),
  -- split_nav("move", "l"),
  -- split_nav("resize", "h"),
  -- -- split_nav("resize", "j"),
  -- -- split_nav("resize", "k"),
  -- split_nav("resize", "l"),
  split_nav("move", "LeftArrow"),
  split_nav("move", "DownArrow"),
  split_nav("move", "UpArrow"),
  split_nav("move", "RightArrow"),
  split_nav("resize", "LeftArrow"),
  split_nav("resize", "RightArrow"),
  split_nav("resize", "DownArrow"),
  split_nav("resize", "UpArrow"),
  -- {
  -- 	key = "\\",
  -- 	mods = "CTRL",
  -- 	action = act.DisableDefaultAssignment,
  -- },
  -- { key = '1', mods = 'CTRL', action = act.ActivatePaneByIndex(1) },
  -- { key = '2', mods = 'CTRL', action = act.ActivatePaneByIndex(2) },
  -- { key = '3', mods = 'CTRL', action = act.ActivatePaneByIndex(3) },
  -- { key = '4', mods = 'CTRL', action = act.ActivatePaneByIndex(4) },
  {
    key = "[",
    mods = "SUPER",
    action = act.ActivateTabRelative(-1),
  },
  {
    key = "]",
    mods = "SUPER",
    action = act.ActivateTabRelative(1),
  },
  {
    key = "x",
    mods = "SUPER",
    action = act.CloseCurrentTab({ confirm = true }),
  },
  {
    key = ",",
    mods = "ALT",
    action = act.SpawnTab("CurrentPaneDomain"),
  },
  {
    key = "b",
    mods = "ALT",
    action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "v",
    mods = "ALT",
    action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = 'h',
    mods = 'ALT',
    action = act.ActivatePaneDirection 'Left',
  },
  {
    key = 'l',
    mods = 'ALT',
    action = act.ActivatePaneDirection 'Right',
  },
  {
    key = 'k',
    mods = 'ALT',
    action = act.ActivatePaneDirection 'Up',
  },
  {
    key = 'j',
    mods = 'ALT',
    action = act.ActivatePaneDirection 'Down',
  },
}

return config
