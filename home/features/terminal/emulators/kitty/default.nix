{
  config,
  pkgs,
  ...
}: {
  programs.kitty = {
    enable = true;
    font = {
      size = 12;
      name = "JetBrainsMono Nerd Font";
    };

    # https://sw.kovidgoyal.net/kitty/conf/
    # Config modified from https://github.com/redyf/nixdots/blob/8999f985fc685b5adb91152420ddd78276266d35/home/desktop/addons/kitty/default.nix
    settings = {
      term = "xterm-256color";
      window_padding_width = "0 0 0 0";
      background_opacity = "0.85";
      cursor_shape = "block";
      cursor_blink_interval = 0;
      copy_on_select = "clipboard";
      clear_all_shortcuts = true;
      draw_minimal_borders = "yes";
      input_delay = 0;
      kitty_mod = "ctrl+shift";

      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";

      text_composition_strategy = "platform"; # platform or legacy
      sync_to_monitor = "yes";

      # Mouse
      mouse_hide_wait = 10;
      url_style = "double";

      # Disable audio
      enable_audio_bell = false;
      visual_bell_duration = 0;
      window_alert_on_bell = false;
      bell_on_tab = false;
      command_on_bell = "none";

      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      active_tab_title_template = "{index}: {title}";
      active_tab_font_style = "bold-italic";
      inactive_tab_font_style = "normal";

      confirm_os_window_close = 0;
      disable_ligatures = "never";
      scrollback_lines = 20000;
      placement_strategy = "center";
    };
    keybindings = {
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
      "ctrl+shift+s" = "paste_from_selection";
      "ctrl+shift+e" = "open_url";
      "ctrl+shift+=" = "increase_font_size";
      "ctrl+shift+-" = "decrease_font_size";
      "ctrl+shift+backspace" = "restore_font_size";
      "ctrl+shift+up" = "scroll_line_up";
      "ctrl+shift+k" = "scroll_line_up";
      "ctrl+shift+down" = "scroll_line_down";
      "ctrl+shift+j" = "scroll_line_down";
      "ctrl+shift+home" = "scroll_home";
      "ctrl+shift+n" = "new_os_window";
      "ctrl+shift+]" = "next_window";
      "ctrl+shift+[" = "previous_window";
      "ctrl+shift+right" = "next_tab";
      "ctrl+tab" = "next_tab";
      "ctrl+shift+tab" = "previous_tab";
      "ctrl+shift+left" = "previous_tab";
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+q" = "close_tab";
    };
  };
}
