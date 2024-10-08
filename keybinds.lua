local wezterm = require("wezterm")
local act = wezterm.action
local w = require("wezterm")
local a = w.action

local function is_inside_vim(pane)
	local tty = pane:get_tty_name()
	if tty == nil then
		return false
	end

	local success, stdout, stderr = w.run_child_process({
		"sh",
		"-c",
		"ps -o state= -o comm= -t"
			.. w.shell_quote_arg(tty)
			.. " | "
			.. "grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?)(diff)?$'",
	})

	return success
end

local function is_outside_vim(pane)
	return not is_inside_vim(pane)
end

local function bind_if(cond, key, mods, action)
	local function callback(win, pane)
		if cond(pane) then
			win:perform_action(action, pane)
		else
			win:perform_action(a.SendKey({ key = key, mods = mods }), pane)
		end
	end

	return { key = key, mods = mods, action = w.action_callback(callback) }
end

local M = {}

M.mod = "SHIFT|SUPER"

M.smart_split = wezterm.action_callback(function(window, pane)
	local dim = pane:get_dimensions()
	if dim.pixel_height > dim.pixel_width then
		window:perform_action(act.SplitVertical({ domain = "CurrentPaneDomain" }), pane)
	else
		window:perform_action(act.SplitHorizontal({ domain = "CurrentPaneDomain" }), pane)
	end
end)

M.key_tables = function()
	return {
		resize_pane = {
			{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
			{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
			{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
			{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },

			{ key = "Escape", action = "PopKeyTable" },
		},
		switch_tabs = {
			{ key = "h", action = act.ActivateTabRelative(-1) },
			{ key = "l", action = act.ActivateTabRelative(1) },

			{ key = "Escape", action = "PopKeyTable" },
		},
		switch_panes = {
			{ key = "h", action = act.ActivatePaneDirection("Left") },
			{ key = "j", action = act.ActivatePaneDirection("Down") },
			{ key = "k", action = act.ActivatePaneDirection("Up") },
			{ key = "l", action = act.ActivatePaneDirection("Right") },

			{ key = "Escape", action = "PopKeyTable" },
		},
	}
end

M.keys = function()
	return {
		{
			key = "r",
			mods = "ALT",
			action = act.ActivateKeyTable({
				name = "resize_pane",
				one_shot = false,
			}),
		},
		{
			key = "p",
			mods = "LEADER",
			action = act.ActivateKeyTable({
				name = "switch_panes",
				one_shot = false,
			}),
		},
		{
			key = "t",
			mods = "LEADER",
			action = act.ActivateKeyTable({
				name = "switch_tabs",
				one_shot = false,
			}),
		},
		{ key = "Tab", mods = "ALT", action = act.ActivateTabRelative(1) },
		{ key = "Tab", mods = "ALT|SHIFT", action = act.ActivateTabRelative(-1) },
		{ mods = M.mod, key = "Enter", action = M.smart_split },
		{
			key = "q",
			mods = "ALT",
			action = act.CloseCurrentPane({ confirm = true }),
		},
		{
			key = "Q",
			mods = "ALT|SHIFT",
			action = act.CloseCurrentTab({ confirm = true }),
		},
		{
			key = "z",
			mods = "ALT",
			-- action = act.ToggleFullScreen,
			action = act.TogglePaneZoomState,
		},
		{ key = "-", mods = "CTRL", action = act.DecreaseFontSize },
		{ key = "=", mods = "CTRL", action = act.IncreaseFontSize },
		-- { key = "t", mods = "ALT", action = act.ShowTabNavigator },
		-- { key = "p", mods = "ALT", action = act.ShowLauncher },
		-- { key = 'w', mods = 'ALT', action = act.SpawnWindow },
		{
			key = "n",
			mods = "ALT|SHIFT",
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
		bind_if(is_outside_vim, "h", "ALT", a.ActivatePaneDirection("Left")),
		bind_if(is_outside_vim, "l", "ALT", a.ActivatePaneDirection("Right")),
		bind_if(is_outside_vim, "j", "ALT", a.ActivatePaneDirection("Down")),
		bind_if(is_outside_vim, "k", "ALT", a.ActivatePaneDirection("Up")),
		{
			key = "c",
			mods = "CTRL|SHIFT",
			action = act.CopyTo("ClipboardAndPrimarySelection"),
		},
		{ key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },
		-- { key = 'V', mods = 'CTRL', action = act.PasteFrom 'PrimarySelection' },
		{
			key = "y",
			mods = "CTRL|SHIFT",
			action = act.SwitchToWorkspace({
				name = "default",
			}),
		},
		{ key = "w", mods = "CTRL", action = act.SwitchToWorkspace },
		{ key = "w", mods = "ALT", action = act.SwitchWorkspaceRelative(1) },
		{ key = "w", mods = "ALT|SHIFT", action = act.SwitchWorkspaceRelative(-1) },
		{
			key = "f",
			mods = "ALT",
			action = act.ShowLauncherArgs({
				flags = "FUZZY|WORKSPACES",
			}),
		},
		{ key = ",", mods = "ALT", action = act.ActivateTabRelative(-1) },
		{ key = ".", mods = "ALT", action = act.ActivateTabRelative(1) },
		{
			key = "j",
			mods = "ALT|SHIFT",
			action = act.RotatePanes("CounterClockwise"),
		},
		{ key = "k", mods = "ALT|SHIFT", action = act.RotatePanes("Clockwise") },
		{
			key = "h",
			mods = "ALT|SHIFT",
			action = act.PaneSelect({
				mode = "SwapWithActive",
			}),
		},
		-- {
		--   key = 's',
		--   mods = 'ALT',
		--   action = act.PromptInputLine {
		--     description = wezterm.format {
		--       { Attribute = { Intensity = 'Bold' } },
		--       { Foreground = { AnsiColor = 'Fuchsia' } },
		--       { Text = 'Enter name for new workspace' },
		--     },
		--     action = act_callback(function(window, pane, line)
		--       -- line will be `nil` if they hit escape without entering anything
		--       -- An empty string if they just hit enter
		--       -- Or the actual line of text they wrote
		--       if line then
		--         window:perform_action(
		--           act.SwitchToWorkspace {
		--             name = line,
		--           },
		--           pane
		--         )
		--       end
		--     end),
		--   },
		-- },
	}
end

-- wezterm.on('gui-startup', function(cmd)
--    local mode = os.getenv("MY_STARTUP_MODE")
--    if mode == "foo" then
--       -- do something
--    end
-- end)
-- https://github.com/wez/wezterm/discussions/3236

for i = 1, 8 do
	table.insert(M.keys(), {
		key = tostring(i),
		mods = "ALT",
		action = act.ActivateTab(i - 1),
	})
end

return M
