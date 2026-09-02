{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.generators) mkLuaInline;

  cursorTheme = config.home.pointerCursor.name;
  cursorSize = toString config.home.pointerCursor.size;
  colors = config.colorScheme.palette;

  primaryColor = "rgb(${colors.primary})";
  inactiveColor = "rgb(${colors.base02})";
  shadowColor = "rgba(${colors.base02}ee)";
  fontFamily = "JetBrainsMono Nerd Font";

  primaryMonitor = lib.lists.findSingle (monitor: monitor.primary == true) null null config.monitors;
  secondaryMonitor = lib.lists.findSingle (monitor: monitor.primary == false) null null config.monitors;
  primary = lib.optionalString (primaryMonitor != null) primaryMonitor.name;
  secondary = lib.optionalString (secondaryMonitor != null) secondaryMonitor.name;

  onMonitor = name: lib.optionalAttrs (name != "") {monitor = name;};

  scratchpadRules = "[float; size monitor_w*0.75 monitor_h*0.75; center]";
in {
  wayland.windowManager.hyprland.settings = {
    # https://wiki.hypr.land/Configuring/Basics/Variables/
    config = {
      general = {
        border_size = 2;
        gaps_in = 4;
        gaps_out = 4;
        col = {
          active_border = primaryColor;
          inactive_border = inactiveColor;
        };
        # which layout to use. [dwindle/master/scrolling/monocle]
        layout = "dwindle";
        # Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false;
      };

      decoration = {
        rounding = 8;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        # enables dimming of inactive windows
        dim_inactive = false;
        # how much inactive windows should be dimmed [0.0 - 1.0]
        dim_strength = 0.05;

        blur = {
          enabled = true;
          size = 8;
          passes = 2;
          # make the blur layer ignore the opacity of the window
          ignore_opacity = true;
          # whether to enable further optimizations to the blur. Recommended to leave on, as it will massively improve performance.
          new_optimizations = true;
          # if enabled, floating windows will ignore tiled windows in their blur. Only available if new_optimizations is true. Will reduce overhead on floating blur significantly.
          xray = false;
          # whether to blur behind the special workspace (note: expensive)
          special = false;
        };

        shadow = {
          enabled = true;
          # Shadow range ("size") in layout px
          range = 20;
          # shadow's color. Alpha dictates shadow's opacity.
          color = shadowColor;
        };
      };

      animations.enabled = true;

      input = {
        kb_layout = "us";
        sensitivity = 0.0;
        accel_profile = "flat"; # flat | adaptive | custom
        # Specify if and how cursor movement should affect window focus [0/1/2/3]
        follow_mouse = 1;

        touchpad = {
          disable_while_typing = true;
          natural_scroll = true;
          clickfinger_behavior = true;
          tap_to_click = true;
        };
      };

      gestures = {
        # if enabled, swiping will not clamp at the neighboring workspaces but continue to the further ones
        workspace_swipe_forever = true;
        # whether a swipe right on the last workspace should create a new one
        workspace_swipe_create_new = true;
      };

      group = {
        # whether new windows in a group spawn after current or at group tail
        insert_after_current = true;
        # whether Hyprland should focus on the window that has just been moved out of the group
        focus_removed_window = true;
        col = {
          border_active = primaryColor;
          border_inactive = inactiveColor;
        };

        groupbar = {
          enabled = true;
          height = 20;
          render_titles = true;
          font_family = fontFamily;
          font_size = 10;
          col = {
            active = primaryColor;
            inactive = inactiveColor;
          };
        };
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = false;
        font_family = fontFamily;
        # Enforce any of the 3 default wallpapers. Setting this to 0 or 1 disables the anime background. -1 means "random". [-1/0/1/2]
        force_default_wallpaper = 0;
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
        focus_on_activate = true;
        # close the special workspace if the last window is removed
        close_special_on_empty = true;
        # controls behavior when a new window is opened while another is fullscreen
        # 0 - do nothing (new window stays behind), 1 - focus new window, 2 - unfullscreen the fullscreen window
        on_focus_under_fullscreen = 0;
      };

      binds = {
        # If enabled, an attempt to switch to the currently focused workspace will
        # instead switch to the previous workspace. Akin to i3's auto_back_and_forth.
        workspace_back_and_forth = false;
        # Whether switching workspaces should center the cursor on the workspace (0) or on the last active window for that workspace (1)
        workspace_center_on = 0;
        # sets the preferred focus finding method when using focus/window.move with a direction.
        # 0 - history (recent have priority), 1 - length (longer shared edges have priority)
        focus_preferred_method = 1;
        movefocus_cycles_fullscreen = false;
        # If enabled, moving a window or focus over the edge of a monitor with a direction will move it to the next monitor in that direction.
        window_direction_monitor_fallback = true;
      };

      xwayland = {
        # forces a scale of 1 on xwayland windows on scaled displays
        force_zero_scaling = false;
      };

      cursor = {
        # 0 - use hw cursors if possible, 1 - don't use hw cursors, 2 - auto (disable when tearing)
        no_hardware_cursors = 1;
        enable_hyprcursor = false;
      };

      debug = {
        # overlay = true;
        disable_logs = false;
        disable_time = false;
        enable_stdout_logs = true;
        # controls the VFR status of Hyprland. Heavily recommended to leave enabled to conserve resources.
        vfr = true;
      };

      # See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
      dwindle = {
        # 0 -> split follows mouse, 1 -> always split to the left (new = left or top) 2 -> always split to the right (new = right or bottom)
        force_split = 2;
        # if enabled, the split (side/top) will not change regardless of what happens to the container
        preserve_split = true;
        # if enabled, allows a more precise control over the window split direction based on the cursor's position.
        # The window is conceptually divided into four triangles, and cursor's triangle determines the split direction.
        # This feature also turns on preserve_split
        smart_split = false;
        # if enabled, resizing direction will be determined by the mouse's position on the window (nearest to which corner).
        # Else, it is based on the window's tiling position.
        smart_resizing = false;
      };
    };

    # https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
    curve = [
      {_args = ["overshot" {type = "bezier"; points = [[0.05 0.9] [0.1 1.05]];}];}
    ];

    animation = [
      {leaf = "windows"; enabled = true; speed = 7; bezier = "overshot";}
      {leaf = "windowsOut"; enabled = true; speed = 7; bezier = "default"; style = "popin 80%";}
      {leaf = "border"; enabled = true; speed = 10; bezier = "default";}
      {leaf = "borderangle"; enabled = true; speed = 8; bezier = "default";}
      {leaf = "fade"; enabled = true; speed = 7; bezier = "default";}
      {leaf = "workspaces"; enabled = true; speed = 6; bezier = "default";}
    ];

    # https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/
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

    # https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
    env = map (arg: {_args = arg;}) [
      ["XDG_CURRENT_DESKTOP" "Hyprland"]
      ["XCURSOR_THEME" cursorTheme]
      ["XCURSOR_SIZE" cursorSize]
      ["HYPRCURSOR_THEME" cursorTheme]
      ["HYPRCURSOR_SIZE" cursorSize]
    ];

    # https://wiki.hypr.land/Configuring/Basics/Monitors/
    monitor =
      [
        {
          output = "";
          mode = "highrr";
          position = "auto";
          scale = 1;
        }
      ]
      ++ map (
        monitor:
          {output = monitor.name;}
          // (
            if monitor.enabled
            then {
              mode = "${toString monitor.width}x${toString monitor.height}@${toString monitor.refreshRate}";
              position = "${toString monitor.x}x${toString monitor.y}";
              scale = monitor.scaleFactor;
            }
            else {disabled = true;}
          )
      ) (config.monitors);

    # https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
    workspace_rule =
      map (rule: rule // onMonitor primary) [
        {workspace = "1"; }
        {workspace = "2"; }
        {workspace = "3"; }
        {workspace = "4"; }
        {workspace = "7"; }
        {workspace = "8"; }
      ]
      ++ map (rule: rule // onMonitor secondary) [
        {workspace = "5"; }
        {workspace = "6"; }
      ]
      # Workspaces 9 and 10 are not explicitly assigned to allow them to appear on the active monitor
      ++ [
        {
          workspace = "special:scratchpad";
          on_created_empty = "${scratchpadRules} alacritty --working-directory=$HOME/projects/nixos && hyprctl dispatch 'hl.dsp.cursor.move({ x = 800, y = 800 })'";
        }
        {
          workspace = "special:notes";
          on_created_empty = "${scratchpadRules} alacritty -e dnote-tui";
        }
        {
          workspace = "special:procs";
          on_created_empty = "${scratchpadRules} alacritty -e btop";
        }
        {
          workspace = "special:magic";
          on_created_empty = "${scratchpadRules} alacritty -e tmux new -A -s scratchpad";
        }
      ];

    # https://wiki.hypr.land/Configuring/Basics/Autostart/
    on = {
      _args = [
        "hyprland.start"
        (mkLuaInline ''
          function()
            -- https://github.com/hyprwm/xdg-desktop-portal-hyprland/issues/251#issuecomment-2357925548
            hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
            hl.exec_cmd("dbus-update-activation-environment --systemd --all")
            hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

            hl.exec_cmd("hyprctl setcursor ${cursorTheme} ${cursorSize}")
            hl.exec_cmd("wl-paste --watch cliphist store")

            hl.exec_cmd("${lib.getExe pkgs.alacritty}", { workspace = "3 silent" })
          end'')
      ];
    };
  };
}
