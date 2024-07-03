-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

----------------------------------------------------------------
-- customize config
----------------------------------------------------------------

-- This is where you actually apply your config choices

-- Term Settings
----------------------------------------------------------------
-- For example, changing the color scheme:
-- config.color_scheme = 'Flexoki'
config.color_scheme = 'Dracula'

-- Fonts
config.font_size = 12.0
config.font = wezterm.font("SourceCodePro-Regular")

-- Tab/frame
config.hide_tab_bar_if_only_one_tab	= true	
config.use_fancy_tab_bar = false 
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.integrated_title_button_color = "Auto"

-- Performance settings
-- config.front_end = "OpenGL"
config.front_end = "WebGpu"

-- Lab
-- OpenGL/WebGpu/Software

-- Key Mapping
----------------------------------------------------------------
-- timeout_milliseconds defaults to 1000 and can be omitted
-- for this example use `setxkbmap -option caps:none` in your terminal.
-- config.leader = { key = 'VoidSymbol', mods = '', timeout_milliseconds = 1000 }
config.keys = {
    {
        key = 'C',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.CopyTo 'ClipboardAndPrimarySelection',
    },
    -- paste from the clipboard
    { key = 'v', mods = 'CTRL|SHIFT', action = wezterm.action.PasteFrom 'Clipboard' },

    -- paste from the primary selection
    { key = 'v', mods = 'CTRL|SHIFT', action = wezterm.action.PasteFrom 'PrimarySelection' },
}
-- Activate tab
for i = 1, 8 do
    -- CTRL+ALT + number to activate that tab
    table.insert(config.keys, {
        key = tostring(i),
        mods = 'CTRL|ALT',
        action = wezterm.action.ActivateTab(i - 1),
    })
end
-- Move tab
-- FIXME, not working
--[[
for i = 1, 9 do
    -- CTRL+ALT + number to move to that position
    table.insert(config.keys, {
        key = tostring(i),
        mods = 'ALT|SHIFT',
        action = wezterm.action.MoveTab(i - 1),
    })
end
--]]


-- Start Program
----------------------------------------------------------------
-- for wsl please use thsi start config to run bash.
-- --config default_prog={'bash'}
-- config.default_prog = { 'bash'}

-- command to list wsl: wsl -l -v
-- config.default_domain = 'WSL:Ubuntu-20.04'


-- and finally, return the configuration to wezterm
return config
