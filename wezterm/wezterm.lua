local wezterm = require('wezterm')

local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font = wezterm.font('FiraCode Nerd Font Mono')
config.font_size = 17.0
config.enable_scroll_bar = false
config.enable_tab_bar = false
config.window_close_confirmation = 'NeverPrompt'
config.window_decorations = 'RESIZE'
config.color_scheme = 'Batman'


return config
