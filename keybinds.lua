local wezterm = require 'wezterm'
local act = wezterm.action
local config = {}

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
    key = "n",
    mods = "SUPER",
    action = act.SpawnTab("CurrentPaneDomain"),
  },
  -- {
  --   key = "`",
  --   mods = "SUPER",
  --   action = sesh.attach.action,
  -- },
  {
    key = "p",
    mods = "CTRL|SHIFT",
    action = act.ActivateCommandPalette,
  },
  {
    key = "LeftArrow",
    mods = "CTRL|SHIFT",
    action = act.DisableDefaultAssignment,
  },
  {
    key = "RightArrow",
    mods = "CTRL|SHIFT",
    action = act.DisableDefaultAssignment,
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
    mods = 'ALT|SHIFT',
    action = act.ActivatePaneDirection 'Left',
  },
  {
    key = 'l',
    mods = 'ALT|SHIFT',
    action = act.ActivatePaneDirection 'Right',
  },
  {
    key = 'UpArrow',
    mods = 'CTRL|SHIFT',
    action = act.ActivatePaneDirection 'Up',
  },
  {
    key = 'DownArrow',
    mods = 'CTRL|SHIFT',
    action = act.ActivatePaneDirection 'Down',
  },
}
return config
