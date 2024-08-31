{
  config,
  pkgs,
  lib,
  ...
}: let
  cursorTheme = config.home.pointerCursor.name;
  cursorSize = toString config.home.pointerCursor.size;
  colors = config.colorScheme.palette;
  pointer = config.home.pointerCursor;
  rog-control-center = "${pkgs.asusctl}/bin/rog-control-center";
in {
  wayland.windowManager.hyprland = {
    settings = {
      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor =
        [
          # monitor=name,resolution,position,scale
          # monitor=,preferred,auto,1.25
          ",highrr,auto,1"
        ]
        ++ map (
          monitor: let
            resolution = "${toString monitor.width}x${toString monitor.height}";
            refreshRate = "${toString monitor.refreshRate}";
            position = "${toString monitor.x}x${toString monitor.y}";
            scale = "${toString monitor.scaleFactor}";
            # https://wiki.hyprland.org/Configuring/Monitors/#extra-args
            extraArgs = "bitdepth,10"; # See: https://github.com/hyprwm/xdg-desktop-portal-hyprland/issues/172#issuecomment-2163262338
          in "${monitor.name},${
            if monitor.enabled
            then "${resolution}@${refreshRate},${position},${scale}"
            else "disable"
          }"
        ) (config.monitors);

      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"

        ## Fix anyrun
        ## https://github.com/anyrun-org/anyrun/issues/153
        "ln -s $XDG_RUNTIME_DIR/hypr /tmp/hypr"

        # set cursor for HL itself
        "hyprctl setcursor ${pointer.name} ${toString pointer.size}"

        # "${wl-paste} --type text --watch cliphist store" # Stores only text data
        # "${wl-paste} --type image --watch cliphist store" # Stores only text data
        "wl-paste --watch cliphist store"

        # "${rog-control-center}"

        # "waybar"
        # "[workspace 1 silent] ${lib.getExe pkgs.wezterm}"
        # "[workspace 2 silent] ${lib.getExe pkgs.firefox}"
        "[workspace 3 silent] ${lib.getExe pkgs.alacritty}"
      ];

      env = [
        "XCURSOR_THEME,${cursorTheme}"
        "XCURSOR_SIZE,${cursorSize}"
        "HYPRCURSOR_THEME,${cursorTheme}"
        "HYPRCURSOR_SIZE,${cursorSize}"
      ];

      # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
      input = {
        # keyboard layout
        kb_layout = "us";
        # kb_variant = "";
        # kb_model = "";
        # kb_options = "";
        # kb_rules = "";

        # See: https://wiki.hyprland.org/Configuring/Variables/#input
        follow_mouse = 1;
        sensitivity = 0.0;
        # accel_profile = "flat"; # flat | adaptive | custom
        touchpad = {
          natural_scroll = true;
          clickfinger_behavior = true;
          tap-to-click = true;
          # scroll_factor = 0.5;
        };
      };

      device = {
        name = "logitech-usb-receiver";
        sensitivity = 0.0;
        accel_profile = "adaptive";
      };

      general = {
        # gaps
        gaps_in = 4;
        gaps_out = 4;

        # border thiccness
        border_size = 2;

        # active border color
        "col.active_border" = "rgb(${colors.primary})";
        "col.inactive_border" = "rgb(${colors.base02})";

        # whether to apply the sensitivity to raw input (e.g. used by games where you aim using your mouse)
        apply_sens_to_raw = 0;

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;
      };

      # See: https://wiki.hyprland.org/Nvidia/#environment-variables
      cursor = {
        no_hardware_cursors = true;
      };

      debug = {
        # overlay = true;
        disable_logs = false;
        disable_time = false;
        enable_stdout_logs = true;
      };

      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 3;
          passes = 3;
          ignore_opacity = false;
          new_optimizations = 1;
          xray = true;
          contrast = 0.7;
          brightness = 0.8;
        };

        # shadow config
        drop_shadow = true;
        shadow_range = 20;
        shadow_render_power = 5;
        "col.shadow" = "rgba(292c3cee)";
      };

      # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
      animations = {
        enabled = true;
        first_launch_animation = false;

        # Default animations
        bezier = [
          "myBezier, 0.05, 0.9, 0.1, 1.05"
        ];
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];

        # Top-bottom animations
        # bezier = [
        #   "smoothOut, 0.36, 0, 0.66, -0.56"
        #   "smoothIn, 0.25, 1, 0.5, 1"
        #   "overshot, 0.4,0.8,0.2,1.2"
        # ];
        # animation = [
        #   "windows, 1, 4, overshot, slide"
        #   "windowsOut, 1, 4, smoothOut, slide"
        #   "border,1,10,default"
        #
        #   "fade, 1, 10, smoothIn"
        #   "fadeDim, 1, 10, smoothIn"
        #   "workspaces,1,4,overshot,slidevert"
        # ];
      };

      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      dwindle = {
        pseudotile = true;
        preserve_split = false;
        smart_split = false;
        force_split = 2; # 0 -> split follows mouse, 1 -> always split to the left (new = left or top) 2 -> always split to the right (new = right or bottom)
        smart_resizing = false;
        no_gaps_when_only = false;
        # permanent_direction_override = true;
      };

      # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      master = {
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_forever = true;
      };

      binds = {
        workspace_back_and_forth = false;
        movefocus_cycles_fullscreen = false;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = false;
        force_default_wallpaper = 0; # Set to 0 to disable the anime mascot wallpapers

        vfr = true;

        # window swallowing
        enable_swallow = true; # hide windows that spawn other windows
        swallow_regex = "^(foot)$";

        # dpms
        mouse_move_enables_dpms = true; # enable dpms on mouse/touchpad action
        key_press_enables_dpms = true; # enable dpms on keyboard action
        disable_autoreload = true; # autoreload is unnecessary on nixos, because the config is readonly anyway
      };

      xwayland = {
        force_zero_scaling = true;
      };

      plugin = {};

      workspace = let
        primaryMonitor = lib.lists.findSingle (monitor: monitor.primary == true) null null config.monitors;
        secondaryMonitor = lib.lists.findSingle (monitor: monitor.primary == false) null null config.monitors;
        primary = lib.optionalString (primaryMonitor != null) primaryMonitor.name;
        secondary = lib.optionalString (secondaryMonitor != null) secondaryMonitor.name;
      in [
        "1, name:coding, monitor:${primary}"
        "2, name:browsing, monitor:${primary}"
        "3, name:terminal, monitor:${primary}"
        "4, name:misc1, monitor:${primary}"
        "5, name:slack, monitor:${secondary}"
        "6, name:misc2, monitor:${secondary}"
        "7, name:misc3, monitor:${secondary}"
        "8, name:misc4, monitor:${secondary}"
        # Workspaces 9 and 10 are not explicitly assigned to allow them to appear on the active monitor

        "special:scratchpad, on-created-empty: [float; size 75% 75%; move center] alacritty --working-directory=$HOME/projects/nixos"
        "special:notes, on-created-empty: [float; size 75% 75%; move center] alacritty -e dnote-tui"
        "special:procs, on-created-empty: [float; size 75% 75%; move center] alacritty -e btop"
        "special:magic, on-created-empty: [float; size 75% 75%; move center] alacritty -e tmux new -A -s scratchpad"
      ];
    };
  };
}