{
  programs.wezterm = {
    enable = true;

    extraConfig = ''
      local wezterm = require 'wezterm'
      local act = wezterm.action

      return {
        color_scheme = 'Catppuccin Mocha',
        enable_tab_bar = false,
        enable_scroll_bar = false,

        -- See:
        -- https://www.reddit.com/r/archlinux/comments/18rf5t1/psa_on_hyprland_wezterm_will_not_start_anymore/?rdt=54570
        -- https://github.com/wez/wezterm/issues/4483
        enable_wayland = false,

        window_background_opacity = 0.85,
        window_padding = {
          top = "0cell",
          right = "0cell",
          bottom = "0cell",
          left = "0cell",
        },

        font_size = 11;
        font = wezterm.font 'JetBrains Mono',
        -- font = wezterm.font_with_fallback {
        --   'JetBrains Mono',
        --   'FiraCode Nerd Font',
        --   'Noto Color Emoji',
        -- },
      };
    '';
  };
}
