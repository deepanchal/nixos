{
  programs.wezterm = {
    enable = true;

    extraConfig = ''
      local wezterm = require 'wezterm'
      local act = wezterm.action

      return {
        color_scheme = 'Catppuccin Macchiato',
        enable_tab_bar = false,
        -- See:
        -- https://www.reddit.com/r/archlinux/comments/18rf5t1/psa_on_hyprland_wezterm_will_not_start_anymore/?rdt=54570
        -- https://github.com/wez/wezterm/issues/4483
        enable_wayland = false,
        inactive_pane_hsb = {
          saturation = 0.9,
          brightness = 0.7,
        },
        font_size = 12;
        font = wezterm.font_with_fallback {
          'JetBrains Mono',
          'FiraCode Nerd Font',
          'Noto Color Emoji',
        },
        -- enable_scroll_bar = true,
        background = {
          {
            source = {
              Color="#24273a"
            },
            height = "100%",
            width = "100%",
            opacity = 0.9,
          },
        },
        launch_menu = {
          {
            args = { 'btop' },
          },
          {
            args = { 'cmatrix' },
          },
          {
            args = { 'pipes-rs' },
          },
        },
        keys = {
          {
            key = 'j',
            mods = 'CTRL|SHIFT',
            action = act.ScrollByPage(1)
          },
          {
            key = 'k',
            mods = 'CTRL|SHIFT',
            action = act.ScrollByPage(-1)
          },
          {
            key = 'g',
            mods = 'CTRL|SHIFT',
            action = act.ScrollToTop
          },
          {
            key = 'e',
            mods = 'CTRL|SHIFT',
            action = act.ScrollToBottom
          },
          {
            key = 'p',
            mods = 'CTRL|SHIFT|SUPER',
            action = act.PaneSelect
          },
          {
            key = 'o',
            mods = 'CTRL|SHIFT|SUPER',
            action = act.PaneSelect { mode = "SwapWithActive" }
          },
          {
            key = '%',
            mods = 'CTRL|SHIFT|SUPER',
            action = act.SplitVertical { domain = 'CurrentPaneDomain' }
          },
          {
            key = '"',
            mods = 'CTRL|SHIFT|SUPER',
            action = act.SplitHorizontal { domain = 'CurrentPaneDomain' }
          },
          {
            key = 'LeftArrow',
            mods = 'CTRL|SHIFT|SUPER',
            action = act.AdjustPaneSize { 'Left', 1 }
          },
          {
            key = 'RightArrow',
            mods = 'CTRL|SHIFT|SUPER',
            action = act.AdjustPaneSize { 'Right', 1 }
          },
          {
            key = 'UpArrow',
            mods = 'CTRL|SHIFT|SUPER',
            action = act.AdjustPaneSize { 'Up', 1 }
          },
          {
            key = 'DownArrow',
            mods = 'CTRL|SHIFT|SUPER',
            action = act.AdjustPaneSize { 'Down', 1 }
          },
          {
            key = 'h',
            mods = 'CTRL|SHIFT|SUPER',
            action = act.ActivatePaneDirection 'Left'
          },
          {
            key = 'l',
            mods = 'CTRL|SHIFT|SUPER',
            action = act.ActivatePaneDirection 'Right'
          },
          {
            key = 'k',
            mods = 'CTRL|SHIFT|SUPER',
            action = act.ActivatePaneDirection 'Up'
          },
          {
            key = 'j',
            mods = 'CTRL|SHIFT|SUPER',
            action = act.ActivatePaneDirection 'Down'
          },
          {
            key = 'z',
            mods = 'CTRL|SHIFT|SUPER',
            action = act.TogglePaneZoomState
          },
          {
            key = 'q',
            mods = 'CTRL|SHIFT|SUPER',
            action = act.CloseCurrentPane { confirm = true }
          },
          {
            key = 'b',
            mods = 'CTRL|SHIFT|SUPER',
            action = act.RotatePanes 'CounterClockwise'
          },
          {
            key = 'n',
            mods = 'CTRL|SHIFT|SUPER',
            action = act.RotatePanes 'Clockwise'
          },
          {
            key = 'd',
            mods = 'CTRL|SHIFT',
            action = act.ShowLauncher
          },
          {
            key = ':',
            mods = 'CTRL|SHIFT',
            action = act.ClearSelection
          },
        },
      }
    '';
  };
}
