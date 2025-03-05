{
  pkgs,
  config,
  ...
}: {
  config = {
    programs.zellij = {
      enable = true;
      enableZshIntegration = false;
      enableFishIntegration = false;
      settings = {
        # custom defined layouts
        layout_dir = "${./layouts}";

        # clipboard provider
        # copy_command = "wl-copy";

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
      };
    };
  };
}
