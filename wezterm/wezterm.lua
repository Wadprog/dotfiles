local wezterm = require ('wezterm')

config = wezterm.config_builder()

config = {

    automatically_reload_config = true,
    font_size = 16.0,
    enable_scroll_bar = false,
    enable_tab_bar = false,
    window_close_confirmation = 'NeverPrompt',
    window_decorations= 'RESIZE',
    color_scheme = 'Batman'

}


return config
