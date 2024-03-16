{ pkgs, config, ... }:
{
  config = {
    programs.zellij = {
      enable = true;
      enableFishIntegration = false; # do NOT auto-start, thank you
      settings = {
        # custom defined layouts
        layout_dir = "${./layouts}";

        # clipboard provider
        copy_command = "wl-copy";

        auto_layouts = true;

        default_layout = "system"; # or compact
        # default_layout = "compact";
        # default_mode = "locked";

        # on_force_close = "quit";
        pane_frames = true;
        session_serialization = false;

        ui.pane_frames = {
          rounded_corners = true;
          # hide_session_name = true;
        };

        # load internal plugins from built-in paths
        plugins = {
          tab-bar.path = "tab-bar";
          status-bar.path = "status-bar";
          strider.path = "strider";
          compact-bar.path = "compact-bar";
        };

        themes = {
          "currentTheme" = with config.colorScheme.palette; {
            bg = "#${base04}";
            fg = "#${base05}";
            red = "#${base08}";
            green = "#${base0B}";
            blue = "#${base0D}";
            yellow = "#${base0A}";
            magenta = "#${base0E}";
            orange = "#${base09}";
            cyan = "#${base0C}";
            black = "#${base00}";
            white = "#${base05}";
          };
        };

        theme = "currentTheme";
      };
    };
  };
}
