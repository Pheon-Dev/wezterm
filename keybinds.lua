local wezterm = require 'wezterm'
local act = wezterm.action
local M = {}
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

M.key_tables = function()
  return {
    resize_pane = {
      { key = 'h',      action = act.AdjustPaneSize { 'Left', 1 } },
      { key = 'l',      action = act.AdjustPaneSize { 'Right', 1 } },
      { key = 'k',      action = act.AdjustPaneSize { 'Up', 1 } },
      { key = 'j',      action = act.AdjustPaneSize { 'Down', 1 } },

      { key = 'Escape', action = 'PopKeyTable' },

    },
    -- move_pane = {
    --   { key = 'h',      action = act.AcitvatePaneDirection { 'Left' } },
    --   { key = 'l',      action = act.AcitvatePaneDirection { 'Right' } },
    --   { key = 'k',      action = act.AcitvatePaneDirection { 'Up' } },
    --   { key = 'j',      action = act.AcitvatePaneDirection { 'Down' } },
    --
    --   { key = 'Escape', action = 'PopKeyTable' },
    --
    -- },
  }
end

M.keys = function()
  return {
    {
      key = 'r',
      mods = 'LEADER',
      action = act.ActivateKeyTable {
        name = 'resize_pane',
        one_shot = false,
      },
    },
    -- {
    --   key = 'm',
    --   mods = 'LEADER',
    --   action = act.ActivateKeyTable {
    --     name = 'move_pane',
    --     one_shot = false,
    --   },
    -- },
    {
      key = 'q',
      mods = 'ALT',
      action = wezterm.action.CloseCurrentPane { confirm = true },
    },

    {
      key = "n",
      mods = "ALT",
      action = act.ActivateTabRelative(-1),
    },
    {
      key = "m",
      mods = "ALT",
      action = act.ActivateTabRelative(1),
    },
    {
      key = "Q",
      mods = "ALT|SHIFT",
      action = act.CloseCurrentTab({ confirm = true }),
    },
    {
      key = 'z',
      mods = 'ALT',
      action = wezterm.action.ToggleFullScreen,
    },
    -- { key = 'p', mods = 'ALT', action = wezterm.action.ShowTabNavigator },
    { key = 'p', mods = 'ALT', action = wezterm.action.ShowLauncher },
    { key = 'w', mods = 'ALT', action = wezterm.action.SpawnWindow },
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
    -- Switch to the default workspace
    {
      key = 'y',
      mods = 'CTRL|SHIFT',
      action = act.SwitchToWorkspace {
        name = 'default',
      },
    },
    -- {
    --   key = 'u',
    --   mods = 'CTRL|SHIFT',
    --   action = act.SwitchToWorkspace {
    --     name = 'monitoring',
    --     spawn = {
    --       args = { 'top' },
    --     },
    --   },
    -- },
    -- Create a new workspace with a random name and switch to it
    { key = 'o', mods = 'ALT', action = act.SwitchToWorkspace },
    { key = ']', mods = 'ALT', action = act.SwitchToWorkspace },
    -- Show the launcher in fuzzy selection mode and have it list all workspaces
    -- and allow activating one.
    {
      key = 'f',
      mods = 'ALT',
      action = act.ShowLauncherArgs {
        flags = 'FUZZY|WORKSPACES',
      },
    },
    {
      key = 's',
      mods = 'ALT',
      action = act.PromptInputLine {
        description = wezterm.format {
          { Attribute = { Intensity = 'Bold' } },
          { Foreground = { AnsiColor = 'Fuchsia' } },
          { Text = 'Enter name for new workspace' },
        },
        action = wezterm.action_callback(function(window, pane, line)
          -- line will be `nil` if they hit escape without entering anything
          -- An empty string if they just hit enter
          -- Or the actual line of text they wrote
          if line then
            window:perform_action(
              act.SwitchToWorkspace {
                name = line,
              },
              pane
            )
          end
        end),
      },
    },

  }
end

return M
