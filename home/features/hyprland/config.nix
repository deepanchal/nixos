{
  config,
  pkgs,
  lib,
  ...
}: let
  colors = config.colorscheme.palette;
  accent = config.theme.accent;

  # TODO: Move this config to something like this https://github.com/vimjoyer/nixconf/blob/a54eaf9a66d503e665229994bebd5d8803ea5cc9/homeManagerModules/features/hyprland/monitors.nix
  primaryMonitor = {
    name = "HDMI-A-1"; # or "DP-1"; # external monitor w/ usb-c
    width = 2560;
    height = 1440;
    x = 0;
    y = 0;
    refreshRate = 144.;
    # NOTE: Using any other than 1, 1.066666, 1.25 scaleFactor shows
    # Invalid scale passed to monitor _, failed to find a clean divisor. Suggested nearest scale: _
    scaleFactor = 1.25;
    # scaleFactor = 1.;
    # scaleFactor = 1.066666;
  };
  secondaryMonitor = rec {
    name = "eDP-1"; # laptop screen
    width = 2560;
    height = 1440;
    x = 0;
    # y = 1152;
    # center monitor horizontally below primary monitor (not working)
    # x = builtins.floor (primaryMonitor.width * primaryMonitor.scaleFactor - width * scaleFactor);
    # stack below primary monitor
    y = builtins.floor (primaryMonitor.height / primaryMonitor.scaleFactor);
    refreshRate = 165.;
    scaleFactor = 1.25;
  };
  pM = primaryMonitor;
  sM = secondaryMonitor;
  pointer = config.home.pointerCursor;

  wl-paste = "${pkgs.cliphist}/bin/wl-paste";
  rog-control-center = "${pkgs.asusctl}/bin/rog-control-center";
in {
  wayland.windowManager.hyprland = {
    settings = {
      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor = [
        # monitor=name,resolution,position,scale
        # monitor=,preferred,auto,1.25
        ",highrr,auto,1"

        "${pM.name},${toString pM.width}x${toString pM.height}@${toString pM.refreshRate},${toString pM.x}x${toString pM.y},${toString pM.scaleFactor}"
        "${sM.name},${toString sM.width}x${toString sM.height}@${toString sM.refreshRate},${toString sM.x}x${toString sM.y},${toString sM.scaleFactor}"
      ];

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

        "${rog-control-center}"

        # "waybar"
        # "[workspace 1 silent] ${lib.getExe pkgs.wezterm}"
        "[workspace 2 silent] ${lib.getExe pkgs.firefox}"
        "[workspace 3 silent] ${lib.getExe pkgs.alacritty}"
      ];

      env = [
        # "XDG_CURRENT_DESKTOP,GNOME"
        # "XDG_SESSION_DESKTOP,gnome"
      ];

      # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
      input = {
        # keyboard layout
        kb_layout = "us";
        # kb_variant = "";
        # kb_model = "";
        # kb_options = "";
        # kb_rules = "";

        follow_mouse = 1;
        sensitivity = 0.0;
        touchpad = {
          natural_scroll = true;
          clickfinger_behavior = true;
          tap-to-click = true;
          # scroll_factor = 0.5;
        };
      };

      general = {
        # https://github.com/outfoxxed/hy3?tab=readme-ov-file#configuration
        layout = "hy3"; # i3 / sway like layout for hyprland.

        # gaps
        gaps_in = 4;
        gaps_out = 4;

        # border thiccness
        border_size = 2;

        # active border color
        "col.active_border" = "rgb(${accent})";
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
        # workspace_back_and_forth = true;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
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

      plugin = {
        hy3 = {
          tabs = {
            height = 16;
            padding = 2;
            from_top = true;
            rounding = 2;
            render_text = true;
            text_font = "JetBrainsMono Nerd Font";
            "col.active" = "0xff${accent}";
            "col.urgent" = "0xff${colors.base09}";
            "col.inactive" = "0xff${colors.base02}";
            "col.text.active" = "0xff${colors.base00}";
            "col.text.urgent" = "0xff${colors.base00}";
            "col.text.inactive" = "0xff${colors.base05}";
          };
          autotile = {
            enable = true;
            trigger_width = 800;
            trigger_height = 500;
          };
          no_gaps_when_only = false;
          node_collapse_policy = 1;
          tab_first_window = false;
        };
      };

      "$kw" = "dwindle:no_gaps_when_only";

      workspace = [
        "1, name:coding, monitor:${pM.name}"
        "2, name:browsing, monitor:${pM.name}"
        "3, name:terminal, monitor:${pM.name}"
        "4, name:misc1, monitor:${pM.name}"
        "5, name:slack, monitor:${sM.name}"
        "6, name:misc2, monitor:${sM.name}"
        "7, name:misc3, monitor:${sM.name}"
        "8, name:misc4, monitor:${sM.name}"
        # Workspaces 9 and 10 are not explicitly assigned to allow them to appear on the active monitor

        "special:scratchpad, on-created-empty:${lib.getExe pkgs.wezterm}"
      ];
    };
  };
}
