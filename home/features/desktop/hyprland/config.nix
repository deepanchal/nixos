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
in {
  wayland.windowManager.hyprland = {
    settings = {
      # https://wiki.hyprland.org/Configuring/Keywords/#defining-variables
      "$mod" = "SUPER";
      "$mod2" = "ALT";
      "$modShift" = "$mod_SHIFT";
      "$modAlt" = "$mod_ALT";
      "$ctrlAlt" = "CTRL_ALT";
      "$left" = "H";
      "$right" = "L";
      "$up" = "K";
      "$down" = "J";
      "$primaryColor" = "rgb(${colors.primary})";
      "$secondaryColor" = "rgb(${colors.secondary})";
      "$inactiveColor" = "rgb(${colors.base02})";
      "$shadowColor" = "rgba(${colors.base02}ee)";
      "$fontFamily" = "JetBrainsMono Nerd Font";

      # https://wiki.hyprland.org/Configuring/Variables/#general
      general = {
        border_size = 2;
        no_border_on_floating = false;
        gaps_in = 4;
        gaps_out = 4;
        "col.active_border" = "$primaryColor";
        "col.inactive_border" = "$inactiveColor";
        # which layout to use. [dwindle/master]
        layout = "dwindle";
        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;
      };

      # https://wiki.hyprland.org/Configuring/Variables/#decoration
      decoration = {
        rounding = 8;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        # enables dimming of inactive windows
        dim_inactive = false;
        # how much inactive windows should be dimmed [0.0 - 1.0]
        dim_strength = 0.05;

        # https://wiki.hyprland.org/Configuring/Variables/#blur
        blur = {
          enabled = true;
          size = 8;
          passes = 2;
          # make the blur layer ignore the opacity of the window
          ignore_opacity = true;
          # whether to enable further optimizations to the blur. Recommended to leave on, as it will massively improve performance.
          new_optimizations = true;
          # if enabled, floating windows will ignore tiled windows in their blur. Only available if blur_new_optimizations is true. Will reduce overhead on floating blur significantly.
          xray = false;
          # whether to blur behind the special workspace (note: expensive)
          special = false;
        };

        shadow = {
          enabled = true;
          # Shadow range (“size”) in layout px
          range = 20;
          # shadow’s color. Alpha dictates shadow’s opacity.
          color = "$shadowColor";
        };
      };

      # https://wiki.hyprland.org/Configuring/Variables/#animations
      # https://wiki.hyprland.org/Configuring/Animations
      animations = {
        enabled = true;
        bezier = [
          "overshot, 0.05, 0.9, 0.1, 1.05"
        ];
        animation = [
          "windows, 1, 7, overshot"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      # https://wiki.hyprland.org/Configuring/Variables/#input
      input = {
        kb_layout = "us";
        sensitivity = 0.0;
        accel_profile = "flat"; # flat | adaptive | custom
        # Specify if and how cursor movement should affect window focus [0/1/2/3]
        follow_mouse = 1;

        # https://wiki.hyprland.org/Configuring/Variables/#touchpad
        touchpad = {
          disable_while_typing = true;
          natural_scroll = true;
          clickfinger_behavior = true;
          tap-to-click = true;
        };
      };

      # https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs
      # Get device list with `hyprctl devices`
      device = [
        {
          # Laptop touchpad
          name = "asue1209:00-04f3:319f-touchpad";
          accel_profile = "adaptive";
        }
        {
          # Logitech GPX Superlight Mouse
          name = "logitech-usb-receiver";
          accel_profile = "flat";
        }
      ];

      # https://wiki.hyprland.org/Configuring/Variables/#gestures
      gestures = {
        # if enabled, swiping will not clamp at the neighboring workspaces but continue to the further ones
        workspace_swipe_forever = true;
        # whether a swipe right on the last workspace should create a new one
        workspace_swipe_create_new = true;
      };

      # https://wiki.hyprland.org/Configuring/Variables/#group
      group = {
        # whether new windows in a group spawn after current or at group tail
        insert_after_current = true;
        # whether Hyprland should focus on the window that has just been moved out of the group
        focus_removed_window = true;
        # colors
        "col.border_active" = "$primaryColor";
        "col.border_inactive" = "$inactiveColor";

        groupbar = {
          enabled = true;
          height = 20;
          render_titles = true;
          font_family = "$fontFamily";
          font_size = 10;
          "col.active" = "$primaryColor";
          "col.inactive" = "$inactiveColor";
        };
      };

      # https://wiki.hyprland.org/Configuring/Variables/#misc
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = false;
        font_family = "$fontFamily";
        # Enforce any of the 3 default wallpapers. Setting this to 0 or 1 disables the anime background. -1 means “random”. [-1/0/1/2]
        force_default_wallpaper = 0;
        # controls the VFR status of Hyprland. Heavily recommended to leave enabled to conserve resources.
        vfr = true;
        # dpms
        mouse_move_enables_dpms = true; # enable dpms on mouse/touchpad action
        key_press_enables_dpms = true; # enable dpms on keyboard action
        # If true, will animate manual window resizes/moves
        animate_manual_resizes = true;
        # If true, will animate windows being dragged by mouse, note that this can cause weird behavior on some curves
        animate_mouse_windowdragging = false;
        # If true, the config will not reload automatically on save, and instead needs to be reloaded with hyprctl reload. Might save on battery.
        disable_autoreload = true; # autoreload is unnecessary on nixos, bc of readonly config
        # Whether Hyprland should focus an app that requests to be focused (an activate request)
        focus_on_activate = 1;
        # close the special workspace if the last window is removed
        close_special_on_empty = true;
        # if there is a fullscreen or maximized window, decide whether a new tiled window opened should replace it,
        # stay behind or disable the fullscreen/maximized state. 0 - behind, 1 - takes over, 2 - unfullscreen/unmaxize [0/1/2]
        new_window_takes_over_fullscreen = 0;
      };

      # https://wiki.hyprland.org/Configuring/Variables/#binds
      binds = {
        # If enabled, an attempt to switch to the currently focused workspace will
        # instead switch to the previous workspace. Akin to i3’s auto_back_and_forth.
        workspace_back_and_forth = false;
        # Whether switching workspaces should center the cursor on the workspace (0) or on the last active window for that workspace (1)
        workspace_center_on = 0;
        # sets the preferred focus finding method when using focuswindow/movewindow/etc with a direction.
        # 0 - history (recent have priority), 1 - length (longer shared edges have priority)
        focus_preferred_method = 1;
        movefocus_cycles_fullscreen = false;
        # If enabled, moving a window or focus over the edge of a monitor with a direction will move it to the next monitor in that direction.
        window_direction_monitor_fallback = true;
      };

      # https://wiki.hyprland.org/Configuring/Variables/#xwayland
      xwayland = {
        # forces a scale of 1 on xwayland windows on scaled displays
        force_zero_scaling = false;
      };

      # https://wiki.hyprland.org/Configuring/Variables/#cursor
      cursor = {
        no_hardware_cursors = true;
      };

      # https://wiki.hyprland.org/Configuring/Variables/#debug
      debug = {
        # overlay = true;
        disable_logs = false;
        disable_time = false;
        enable_stdout_logs = true;
      };

      # https://wiki.hyprland.org/Configuring/Keywords/#executing
      exec-once = [
        # https://github.com/hyprwm/xdg-desktop-portal-hyprland/issues/251#issuecomment-2357925548
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "dbus-update-activation-environment --systemd --all"
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"

        # set cursor for HL itself
        "hyprctl setcursor ${cursorTheme} ${cursorSize}"

        # "${wl-paste} --type text --watch cliphist store" # Stores only text data
        # "${wl-paste} --type image --watch cliphist store" # Stores only text data
        "wl-paste --watch cliphist store"

        # "[workspace 1 silent] ${lib.getExe pkgs.wezterm}"
        # "[workspace 2 silent] ${lib.getExe pkgs.firefox}"
        "[workspace 3 silent] ${lib.getExe pkgs.alacritty}"
      ];

      # See https://wiki.hyprland.org/Configuring/Monitors
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

      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XCURSOR_THEME,${cursorTheme}"
        "XCURSOR_SIZE,${cursorSize}"
        "HYPRCURSOR_THEME,${cursorTheme}"
        "HYPRCURSOR_SIZE,${cursorSize}"
      ];

      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      dwindle = {
        # enable pseudotiling. Pseudotiled windows retain their floating size when tiled
        pseudotile = true;
        # 0 -> split follows mouse, 1 -> always split to the left (new = left or top) 2 -> always split to the right (new = right or bottom)
        force_split = 2;
        # if enabled, the split (side/top) will not change regardless of what happens to the container
        preserve_split = true;
        # if enabled, allows a more precise control over the window split direction based on the cursor’s position.
        # The window is conceptually divided into four triangles, and cursor’s triangle determines the split direction.
        # This feature also turns on preserve_split
        smart_split = false;
        # if enabled, resizing direction will be determined by the mouse’s position on the window (nearest to which corner).
        # Else, it is based on the window’s tiling position.
        smart_resizing = false;
        # if enabled, makes the preselect direction persist until either this mode is turned off,
        # another direction is specified, or a non-direction is specified (anything other than l,r,u/t,d/b)	
        permanent_direction_override = true;
      };

      # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      master = {};

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
        "7, name:misc3, monitor:${primary}"
        "8, name:misc4, monitor:${primary}"
        # Workspaces 9 and 10 are not explicitly assigned to allow them to appear on the active monitor

        "special:scratchpad, on-created-empty: [float; size 75% 75%; move center] alacritty --working-directory=$HOME/projects/nixos && hyprctl dispatch movecursor 800 800"
        "special:notes, on-created-empty: [float; size 75% 75%; move center] alacritty -e dnote-tui"
        "special:procs, on-created-empty: [float; size 75% 75%; move center] alacritty -e btop"
        "special:magic, on-created-empty: [float; size 75% 75%; move center] alacritty -e tmux new -A -s scratchpad"
      ];
    };
  };
}
