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
    switch_tabs = {
      { key = 'h',      action = act.ActivateTabRelative(-1) },
      { key = 'l',      action = act.ActivateTabRelative(1) },

      { key = 'Escape', action = 'PopKeyTable' },

    },
    switch_panes = {
      { key = 'h',      action = act.ActivatePaneDirection "Left" },
      { key = 'j',      action = act.ActivatePaneDirection "Down" },
      { key = 'k',      action = act.ActivatePaneDirection "Up" },
      { key = 'l',      action = act.ActivatePaneDirection "Right" },

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
    {
      key = 'p',
      mods = 'LEADER',
      action = act.ActivateKeyTable {
        name = 'switch_panes',
        one_shot = false,
      },
    },
    {
      key = 't',
      mods = 'LEADER',
      action = act.ActivateKeyTable {
        name = 'switch_tabs',
        one_shot = false,
      },
    },
    { key = 'Tab', mods = 'ALT',       action = act.ActivateTabRelative(1) },
    { key = 'Tab', mods = 'ALT|SHIFT', action = act.ActivateTabRelative(-1) },
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
      key = "Q",
      mods = "ALT|SHIFT",
      action = act.CloseCurrentTab({ confirm = true }),
    },
    {
      key = 'z',
      mods = 'ALT',
      -- action = wezterm.action.ToggleFullScreen,
      action = wezterm.action.TogglePaneZoomState,
    },
    { key = '-', mods = 'CTRL', action = wezterm.action.DecreaseFontSize },
    { key = '=', mods = 'CTRL', action = wezterm.action.IncreaseFontSize },
    { key = 't', mods = 'ALT',  action = wezterm.action.ShowTabNavigator },
    { key = 'p', mods = 'ALT',  action = wezterm.action.ShowLauncher },
    -- { key = 'w', mods = 'ALT', action = wezterm.action.SpawnWindow },
    {
      key = "n",
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
    {
      key = 'c',
      mods = 'CTRL|SHIFT',
      action = wezterm.action.CopyTo 'ClipboardAndPrimarySelection',
    },
    { key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom 'Clipboard' },
    -- { key = 'V', mods = 'CTRL', action = act.PasteFrom 'PrimarySelection' },
    {
      key = 'y',
      mods = 'CTRL|SHIFT',
      action = act.SwitchToWorkspace {
        name = 'default',
      },
    },
    {
      key = 'g',
      mods = 'ALT',
      action = act.SpawnCommandInNewWindow {
        label = 'btop',
        args = { 'btop' },
        cwd = ".",
        -- Sets addditional environment variables in the environment for
        -- this command invocation.
        set_environment_variables = {
          SOMETHING = 'a value',
        },

        -- Specifiy that the multiplexer domain of the currently active pane
        -- should be used to start this process.  This is usually what you
        -- want to happen and this is the default behavior if you omit
        -- the domain.
        domain = 'CurrentPaneDomain',

        -- Specify that the default multiplexer domain be used for this
        -- command invocation.  The default domain is typically the "local"
        -- domain, which spawns processes locally.  However, if you started
        -- wezterm using `wezterm connect` or `wezterm serial` then the default
        -- domain will not be "local".
        -- domain = 'DefaultDomain',

        -- Since: 20230320-124340-559cb7b0
        -- Specify the initial position for a GUI window when this command
        -- is used in a context that will create a new window, such as with
        -- wezterm.mux.spawn_window, SpawnCommandInNewWindow
        position = {
          x = 10,
          y = 300,
          -- Optional origin to use for x and y.
          -- Possible values:
          -- * "ScreenCoordinateSystem" (this is the default)
          -- * "MainScreen" (the primary or main screen)
          -- * "ActiveScreen" (whichever screen hosts the active/focused window)
          -- * {Named="HDMI-1"} - uses a screen by name. See wezterm.gui.screens()
          -- origin = "ScreenCoordinateSystem"
        },
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
    { key = 'w', mods = 'CTRL',       action = act.SwitchToWorkspace },
    { key = 'w', mods = 'ALT',        action = act.SwitchWorkspaceRelative(1) },
    { key = 'w', mods = 'ALT|SHIFT',  action = act.SwitchWorkspaceRelative(-1) },
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


for i = 1, 8 do
  table.insert(M.keys(), {
    key = tostring(i),
    mods = 'ALT',
    action = act.ActivateTab(i - 1),
  })
  -- table.insert(M.keys(), {
  --   key = tostring(i),
  --   mods = 'CTRL|ALT',
  --   action = act.ActivateWindow(i - 1),
  -- })
  -- -- F1 through F8 to activate that tab
  -- table.insert(config.keys, {
  --   key = 'F' .. tostring(i),
  --   action = act.ActivateTab(i - 1),
  -- })
end
return M
