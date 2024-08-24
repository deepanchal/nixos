{config, ...}: let
  colors = config.colorScheme.palette;
in {
  services.dunst = {
    enable = true;
    # iconTheme = {
    #   package = config.gtk.iconTheme.package;
    #   name = "Papirus-Dark";
    # };

    settings = {
      global = {
        follow = "mouse";
        width = 320;
        height = 200;
        origin = "top-right";
        alignment = "center";
        vertical_alignment = "center";
        ellipsize = "middle";
        offset = "10x32";
        padding = 8;
        horizontal_padding = 20;
        text_icon_padding = 20;
        icon_position = "left";
        min_icon_size = 40;
        max_icon_size = 64;
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 2;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;
        separator_height = 1;
        frame_width = 2;
        frame_color = "#${colors.primary}";
        separator_color = "frame";
        corner_radius = 12;
        transparency = 0;
        gap_size = 10;
        line_height = 0;
        notification_limit = 3;
        idle_threshold = 120;
        history_length = 20;
        show_age_threshold = 60;
        markup = "full";
        font = "JetBrainsMonoNerdFont 10";
        word_wrap = "yes";
        sort = "yes";
        shrink = "no";
        indicate_hidden = "yes";
        sticky_history = "yes";
        ignore_newline = "no";
        show_indicators = "no";
        stack_duplicates = true;
        always_run_script = true;
        hide_duplicate_count = false;
        ignore_dbusclose = false;
        force_xwayland = false;
        force_xinerama = false;
        mouse_left_click = "do_action";
        mouse_middle_click = "close_all";
        mouse_right_click = "close_current";
      };

      fullscreen_delay_everything = {fullscreen = "delay";};

      urgency_low = {
        timeout = 5; # Adjusted for a more uniform experience
        background = "#${colors.base02}";
        foreground = "#${colors.base05}";
        highlight = "#${colors.base0C}";
      };

      urgency_normal = {
        timeout = 10; # Standardized timeout for normal urgency
        background = "#${colors.base02}";
        foreground = "#${colors.base05}";
        highlight = "#${colors.base0C}";
      };

      urgency_critical = {
        timeout = 0; # Keeping critical notifications until dismissed
        background = "#${colors.base02}";
        foreground = "#${colors.base05}";
        highlight = "#${colors.base08}";
      };
    };
  };
}
