local wezterm = require ('wezterm')

config = wezterm.config_builder()

config = {
    automatically_reload_config = true,
    font = wezterm.font("FiraCode Nerd Font"),
    font_size = 18.0,
    color_scheme = "batman",
    enable_tab_bar = false,
    hide_tab_bar_if_only_one_tab = true,
    window_close_confirmation = "NeverPrompt",
    background = {
        {
            source = { File = "/Users/wadsonvaval/.config/wezterm/logo.png" },
            opacity = 0.5,
            hsb = {
                brightness = 0.1,
                saturation = 1.0,
                hue = 1.0,
            },
            width = "100%",
            height = "100%",
        },
        { 
        
            source = {
                Color = "Black"
            },
            width = "100%",
            height = "100%",
            opacity = 0.7
    },
    },
}


return config