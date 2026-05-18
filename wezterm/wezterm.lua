local wezterm = require("wezterm")

------------------------------------------------------------------------------------------------------------------------
-- Constants and helpers
------------------------------------------------------------------------------------------------------------------------

local FONT_FAMILY = wezterm.font("Spleen 32x64")
local FONT_SIZE = 16
local CHAR_SOLID_LEFT = wezterm.nerdfonts.pl_right_hard_divider
local COLOR_BACKGROUND = "#2e3440"

local function basename(path) return string.gsub(path, "(.*[/\\])(.*)", "%2") end

local function process_name(pane)
	local info = pane:get_foreground_process_info()
	if info then
		return basename(info.executable)
	else
		return ""
	end
end

local function lookup(table, executable)
	if executable then
		local name = basename(executable)

		local candidates = {
			name,
			string.gsub(name, "^(.-)(%d+%.?%d*)", "%1"),
			string.gsub(name, "^(.-)([.-].*)", "%1"),
		}

		for _, candidate in ipairs(candidates) do
			print(candidate)
			if candidate then
				if table[candidate] then return table[candidate] end
			end
		end
	end

	return table["unknown"]
end

local icons = {
	["bash"] = wezterm.nerdfonts.md_pound_box,
	["btm"] = wezterm.nerdfonts.md_chart_donut_variant,
	["bundle"] = wezterm.nerdfonts.cod_ruby,
	["bun"] = wezterm.nerdfonts.md_hexagon,
	["cargo"] = wezterm.nerdfonts.dev_rust,
	["curl"] = wezterm.nerdfonts.md_flattr,
	["docker"] = wezterm.nerdfonts.linux_docker,
	["fish"] = wezterm.nerdfonts.dev_terminal,
	["gem"] = wezterm.nerdfonts.cod_ruby,
	["gh"] = wezterm.nerdfonts.dev_github_badge,
	["git"] = wezterm.nerdfonts.dev_git,
	["go"] = wezterm.nerdfonts.seti_go,
	["htop"] = wezterm.nerdfonts.md_chart_donut_variant,
	["idle"] = wezterm.nerdfonts.dev_python,
	["irb"] = wezterm.nerdfonts.cod_ruby,
	["lazydocker"] = wezterm.nerdfonts.linux_docker,
	["lua"] = wezterm.nerdfonts.seti_lua,
	["lxc"] = wezterm.nerdfonts.linux_docker,
	["lxd"] = wezterm.nerdfonts.linux_docker,
	["make"] = wezterm.nerdfonts.seti_makefile,
	["mc"] = wezterm.nerdfonts.md_alpha_m_circle,
	["node"] = wezterm.nerdfonts.md_hexagon,
	["nvim"] = wezterm.nerdfonts.custom_vim,
	["pip"] = wezterm.nerdfonts.dev_python,
	["python"] = wezterm.nerdfonts.dev_python,
	["ruby"] = wezterm.nerdfonts.cod_ruby,
	["sudo"] = wezterm.nerdfonts.fa_hashtag,
	["unknown"] = wezterm.nerdfonts.oct_gear,
	["vagrant"] = wezterm.nerdfonts.cod_vm_connect,
	["vim"] = wezterm.nerdfonts.dev_vim,
	["wget"] = wezterm.nerdfonts.md_arrow_down_box,
	["zsh"] = wezterm.nerdfonts.dev_terminal,
}

local function lookup_icon(executable)
	return lookup(icons, executable)
end

local colors = {
	["docker"] = "#bf616a",
	["lazydocker"] = "#bf616a",
	["lxc"] = "#bf616a",
	["lxd"] = "#bf616a",
	["vagrant"] = "#bf616a",
}

local function lookup_color(executable)
	return lookup(colors, executable)
end

------------------------------------------------------------------------------------------------------------------------
-- Settings
------------------------------------------------------------------------------------------------------------------------

local config = {
	color_scheme = "nordfox",
	font = FONT_FAMILY,
	font_size = FONT_SIZE,
	window_padding = { bottom = 0 },
	use_fancy_tab_bar = false,
	scrollback_lines = 10000,
}

------------------------------------------------------------------------------------------------------------------------
-- Colors
------------------------------------------------------------------------------------------------------------------------

config.colors = {
	tab_bar = {
		background = COLOR_BACKGROUND,
		active_tab = { intensity = "Bold", fg_color = "white", bg_color = "#5e81ac" },
	},
}

------------------------------------------------------------------------------------------------------------------------
-- Keys
------------------------------------------------------------------------------------------------------------------------

config.keys = {
	{
		key = "\"",
		mods = "ALT",
		action = wezterm.action.ActivateLastTab
	},
	{
		key = "a",
		mods = "ALT",
		action = wezterm.action.SpawnTab("CurrentPaneDomain")
	},
	{
		key = "b",
		mods = "ALT",
		action = wezterm.action.SpawnCommandInNewTab { args = { "/bin/bash" } }
	},
	{
		key = "m",
		mods = "ALT",
		action = wezterm.action.SpawnCommandInNewTab {
			set_environment_variables = { SHELL = "/bin/bash" }, args = { "/usr/bin/mc" }
		}
	},
	{
		key = "q",
		mods = "ALT",
		action = wezterm.action.CloseCurrentTab { confirm = false }
	},
	{
		key = "w",
		mods = "ALT",
		action = wezterm.action.SpawnWindow
	},
	{
		key = "LeftArrow",
		mods = "ALT",
		action = wezterm.action.ActivateTabRelative(-1)
	},
	{
		key = "LeftArrow",
		mods = "ALT|SHIFT",
		action = wezterm.action.MoveTabRelative(-1)
	},
	{
		key = "RightArrow",
		mods = "ALT",
		action = wezterm.action.ActivateTabRelative(1)
	},
	{
		key = "RightArrow",
		mods = "ALT|SHIFT",
		action = wezterm.action.MoveTabRelative(1)
	},
}

-- ALT + number to activate that tab
for i = 1, 9 do
	table.insert(config.keys, { key = tostring(i), mods = "ALT", action = wezterm.action.ActivateTab(i - 1) })
end

------------------------------------------------------------------------------------------------------------------------
-- Events
------------------------------------------------------------------------------------------------------------------------

wezterm.on("update-right-status", function(window, pane)
	local cells = {}

	-- Add hostname
	local uri = pane:get_current_working_dir()

	if uri then
		local hostname = uri.host or wezterm.hostname()

		local dot = hostname:find("[.]")

		if dot then hostname = hostname:sub(1, dot - 1) end

		if hostname == "" then hostname = wezterm.hostname() end

		cells["hostname"] = hostname
	end

	-- Add date/time
	cells["date"] = wezterm.strftime("%Y-%m-%d  %H:%M:%S")

	-- Add process icon
	cells["icon"] = lookup_icon(process_name(pane))

	-- The elements to be formatted
	local elements = {}

	-- Translate a cell into elements
	local function push(text, color_current, color_next)
		if not text then return end

		table.insert(elements, { Foreground = { Color = color_current } })
		table.insert(elements, { Text = CHAR_SOLID_LEFT })
		table.insert(elements, { Foreground = { Color = "white" } })
		table.insert(elements, { Background = { Color = color_current } })
		table.insert(elements, { Text = " " .. text .. " " })
		table.insert(elements, { Foreground = { Color = color_next } })
	end

	-- Start with background color
	table.insert(elements, { Background = { Color = COLOR_BACKGROUND } })

	push(cells["hostname"], "#434c5e", "#4c566a")
	push(cells["date"], "#4c566a", "#bf616a")
	push(cells["icon"], "#bf616a", "#434c5e")

	window:set_right_status(wezterm.format(elements))
end)

local function tab_title(tab)
	local title = tab.tab_title

	-- If the tab title is explicitly set, take that
	if title and #title > 0 then return title end

	local icon = lookup_icon(tab.active_pane.foreground_process_name)
	title = string.format("%-15s", string.format(" %d: %s ", tab.tab_index + 1, icon))

	-- Format specified tabs specially
	local color = lookup_color(tab.active_pane.foreground_process_name)
	if color then
		return {
			{ Background = { Color = color } },
			{ Foreground = { Color = "#e0e0e0" } },
			{ Text = title },
		}
	else
		return title
	end
end

wezterm.on("format-tab-title", function(tab, _, _, _, _, _) return tab_title(tab) end)

------------------------------------------------------------------------------------------------------------------------
-- Host spesific
------------------------------------------------------------------------------------------------------------------------

-- Example local.lua:
--
-- 	return {
-- 		update = function(config)
-- 			config.front_end = "OpenGL"
-- 		end
-- 	}

local ok, host = pcall(require, "local")
if ok then host.update(config) end

return config
