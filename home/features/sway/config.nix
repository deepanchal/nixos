{
  config,
  pkgs,
  lib,
  ...
}: let
  colors = config.colorScheme.palette;
in {
  wayland.windowManager.sway = {
    config = {
      modifier = "Mod4";
      up = "k";
      down = "j";
      left = "h";
      right = "l";

      terminal = "alacritty";
      menu = "anyrun";

      workspaceLayout = "default"; # “default” | “stacking” | “tabbed”
      workspaceAutoBackAndForth = false;

      colors = with colors; {
        # client.focused #4c7899 #285577 #ffffff #2e9ef4 #285577
        # focused = {
        #   border = "#4c7899";
        #   background = "#285577";
        #   text = "#ffffff";
        #   indicator = "#2e9ef4";
        #   childBorder = "#285577";
        # };
        focused = {
          border = "#${primary}";
          background = "#${primary}";
          text = "#${base01}";
          indicator = "#${secondary}";
          childBorder = "#${primary}";
        };
        focusedInactive = {
          border = "#${base04}";
          background = "#${base00}";
          text = "#${base05}";
          indicator = "#${secondary}";
          childBorder = "#${base04}";
        };
        unfocused = {
          border = "#${base04}";
          background = "#${base00}";
          text = "#${base05}";
          indicator = "#${secondary}";
          childBorder = "#${base04}";
        };
        urgent = {
          border = "#${danger}";
          background = "#${base00}";
          text = "#${danger}";
          indicator = "#${secondary}";
          childBorder = "#${danger}";
        };
        placeholder = {
          border = "#${base04}";
          background = "#${base00}";
          text = "#${base05}";
          indicator = "#${base04}";
          childBorder = "#${base04}";
        };
        background = "#${base00}";
      };

      fonts = {
        names = ["JetBrainsMono Nerd Font"];
        size = 9.0;
      };

      # Extending keybindings defaults from
      # https://github.com/nix-community/home-manager/blob/c2cd2a52e02f1dfa1c88f95abeb89298d46023be/modules/services/window-managers/i3-sway/sway.nix#L48
      keybindings = let
        cfg = config.wayland.windowManager.sway.config;
        mod = cfg.modifier;
        mod2 = "Alt";
        left = cfg.left;
        right = cfg.right;
        up = cfg.up;
        down = cfg.down;
      in {
        "${mod}+Return" = "exec ${cfg.terminal}";
        "${mod}+Shift+q" = "kill";
        "${mod}+d" = "exec ${cfg.menu}";

        "${mod}+${left}" = "focus left";
        "${mod}+${down}" = "focus down";
        "${mod}+${up}" = "focus up";
        "${mod}+${right}" = "focus right";

        "${mod}+Left" = "focus left";
        "${mod}+Down" = "focus down";
        "${mod}+Up" = "focus up";
        "${mod}+Right" = "focus right";

        "${mod}+Shift+${left}" = "move left";
        "${mod}+Shift+${down}" = "move down";
        "${mod}+Shift+${up}" = "move up";
        "${mod}+Shift+${right}" = "move right";

        "${mod}+Shift+Left" = "move left";
        "${mod}+Shift+Down" = "move down";
        "${mod}+Shift+Up" = "move up";
        "${mod}+Shift+Right" = "move right";

        "${mod}+b" = "splith";
        "${mod}+v" = "splitv";
        "${mod}+f" = "fullscreen toggle";
        "${mod}+a" = "focus parent";

        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";

        "${mod}+Shift+space" = "floating toggle";
        "${mod}+space" = "focus mode_toggle";

        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";
        "${mod}+0" = "workspace number 10";

        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";
        "${mod}+Shift+0" = "move container to workspace number 10";

        "${mod}+Shift+minus" = "move scratchpad";
        "${mod}+minus" = "scratchpad show";

        "${mod}+Shift+c" = "reload, exec notify-send 'Reloaded sway config'";
        "${mod}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

        "${mod}+r" = "mode resize";
        "${mod}+o" = "mode launch";

        # Launcher
        "${mod2}+Space" = "exec ${cfg.menu}";

        # Clipboard
        "${mod2}+c" = "exec cliphist list | anyrun-dmenu | cliphist decode | wl-copy";

        # Screenshots
        "F6" = "exec grimblast --notify save area - | satty -f -";

        # Utilities
        "--locked XF86AudioMute" = "exec swayosd-client --output-volume mute-toggle";
        "--locked XF86AudioLowerVolume" = "exec swayosd-client --output-volume -5 && play-vol-change-sound";
        "--locked XF86AudioRaiseVolume" = "exec swayosd-client --output-volume +5 && play-vol-change-sound";
        "--locked XF86AudioMicMute" = "exec swayosd-client --input-volume mute-toggle";
        "--locked XF86MonBrightnessDown" = "exec swayosd-client --brightness -10";
        "--locked XF86MonBrightnessUp" = "exec swayosd-client --brightness +10";

        # Media
        "--locked XF86AudioPlay" = "exec playerctl play-pause";
        "--locked XF86AudioPrev" = "exec playerctl previous";
        "--locked XF86AudioNext" = "exec playerctl next";
        "${mod}+Shift+m" = "exec playerctl -p spotify play-pause";
        "${mod}+Shift+n" = "exec playerctl -p spotify next";
        "${mod}+Shift+b" = "exec playerctl -p spotify previous";

        # Other
        "--locked --release Caps_Lock" = "exec swayosd-client --caps-lock";
        "--locked --release Num_Lock" = "exec swayosd-client --num-lock";
        "XF86Launch1" = "exec rog-control-center";
        "XF86Launch3" = "exec asusctl led-mode -n";
        "XF86Launch4" = "exec asusctl profile -n";
      };

      keycodebindings = {};
      bars = [];
      gaps = {
        smartBorders = "off"; # "on" | "off" | "no_gaps"
        smartGaps = false;
        outer = 4;
        inner = 4;
      };

      modes = let
        resetMode = "mode default";
      in {
        resize = {
          Down = "resize grow height 10 px";
          Left = "resize shrink width 10 px";
          Right = "resize grow width 10 px";
          Up = "resize shrink height 10 px";
          h = "resize shrink width 10 px";
          j = "resize grow height 10 px";
          k = "resize shrink height 10 px";
          l = "resize grow width 10 px";
          Escape = resetMode;
          Return = resetMode;
        };

        launch = {
          f = "exec firefox, ${resetMode}";
          g = "exec google-chrome-stable, ${resetMode}";
          b = "exec brave, ${resetMode}";
          s = "exec slack, ${resetMode}";
          d = "exec thunar, ${resetMode}";
          Escape = resetMode;
          Return = resetMode;
        };
      };

      focus = {
        followMouse = "always"; # "yes" | "no" | "always"
        newWindow = "focus"; # "smart" | "urgent" | "focus" | "none"
      };

      window = {
        titlebar = false;
        border = 2;
        hideEdgeBorders = "none"; # “none” | “vertical” | "horizontal” | “both” | “smart”
        commands = [
          {
            command = "floating enable; sticky toggle; resize 35ppt 10ppt";
            criteria = {
              title = "^Picture-in-Picture$";
              app_id = "firefox";
            };
          }
          {
            command = "focus; sticky toggle";
            criteria = {app_id = "gcr-prompter";};
          }
          {
            command = "focus; sticky toggle";
            criteria = {app_id = "polkit-gnome-authentication-agent-1";};
          }
          {
            command = "floating enable; resize set 40ppt 20ppt; move position center";
            criteria = {title = "File Operation Progress";};
          }
          {
            command = "resize set 40ppt 60ppt; move position center";
            criteria = {title = "Open Folder";};
          }
          {
            command = "resize set 40ppt 60ppt; move position center";
            criteria = {title = "Open File";};
          }
          {
            command = "resize set 60ppt 80ppt; move position center";
            criteria = {app_id = "wdisplays";};
          }
          {
            command = "resize set 60ppt 80ppt; move position center";
            criteria = {app_id = "solaar";};
          }
          {
            command = "resize set 40ppt 60ppt; move position center";
            criteria = {app_id = ".blueman-manager-wrapped";};
          }
          {
            command = "resize set 40ppt 60ppt; move position center";
            criteria = {app_id = "nm-connection-editor";};
          }
          {
            command = "resize set 40ppt 60ppt; move position center";
            criteria = {app_id = "pavucontrol";};
          }
        ];
      };

      floating = {
        border = 2;
        titlebar = true;
        criteria = [
          {app_id = ".blueman-manager-wrapped";}
          {app_id = "nm-connection-editor";}
          {app_id = "pavucontrol";}
          {app_id = "solaar";}
          {app_id = "imv";}
          {app_id = "mpv";}
          {app_id = "swappy";}
          {app_id = "wlogout";}
          {app_id = "wdisplays";}
          {title = "Open File";}
          {title = "Open Folder";}
          {window_role = "bubble";}
          {window_role = "dialog";}
          {window_role = "pop-up";}
          {window_type = "dialog";}
        ];
      };

      output = builtins.listToAttrs (map (monitor: {
          name = monitor.name;
          value = {
            pos = "${toString monitor.x} ${toString monitor.y}";
            resolution = "${toString monitor.width}x${toString monitor.height}@${toString monitor.refreshRate}Hz";
            scale = toString monitor.scaleFactor;
          };
        })
        config.monitors);

      workspaceOutputAssign = let
        primaryMonitor = lib.lists.findSingle (monitor: monitor.primary == true) null null config.monitors;
        secondaryMonitor = lib.lists.findSingle (monitor: monitor.primary == false) null null config.monitors;
        primary = lib.optionalString (primaryMonitor != null) primaryMonitor.name;
        secondary = lib.optionalString (secondaryMonitor != null) secondaryMonitor.name;
        createWorkspaceAssignments = monitor: workspaces:
          map (workspace: {
            workspace = toString workspace;
            output = monitor;
          })
          workspaces;
        primaryWorkspaces = [1 2 3 4];
        secondaryWorkspaces = [5 6 7 8];
        primaryAssignments = createWorkspaceAssignments primary primaryWorkspaces;
        secondaryAssignments = createWorkspaceAssignments secondary secondaryWorkspaces;
      in
        primaryAssignments
        ++ secondaryAssignments
        ++ [
          # Workspaces 9 and 10 are not explicitly assigned to allow them to appear on the active monitor
        ];

      startup = [
        {command = "dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY";}
        {command = "wl-paste --watch cliphist store";}
        # Disabling bc https://github.com/nwg-piotr/autotiling/issues/28
        # {
        #   command = "${lib.getExe pkgs.autotiling}";
        #   always = true;
        # }
      ];

      input = {
        "type:pointer" = {
          accel_profile = "flat";
          pointer_accel = "0";
        };
        "type:touchpad" = {
          middle_emulation = "enabled";
          natural_scroll = "enabled";
          tap = "enabled";
        };
        "type:keyboard" = {
          xkb_layout = "us";
        };
      };
    };

    extraOptions = [
      "--verbose"
      # "--debug"
      # "--unsupported-gpu"
      # "--my-next-gpu-wont-be-nvidia"
    ];

    wrapperFeatures = {
      base = true;
      gtk = true;
    };

    extraSessionCommands =
      # bash
      ''
        export SDL_VIDEODRIVER=wayland
        # needs qt5.qtwayland in systemPackages
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        # Fix for some Java AWT applications (e.g. Android Studio),
        # use this if they aren't displayed properly:
        export _JAVA_AWT_WM_NONREPARENTING=1
        # Consistent cursor size maybe?
        export XCURSOR_THEME=Bibata-Modern-Classic
        export XCURSOR_SIZE=16
      '';

    extraConfigEarly = ''
    '';

    extraConfig =
      ''
        bindgesture swipe:left workspace next
        bindgesture swipe:right workspace prev
      ''
      + lib.strings.optionalString (config.wayland.windowManager.sway.package == pkgs.swayfx) ''

        #############################
        # SwayFx Config
        # https://github.com/WillPower3309/swayfx?tab=readme-ov-file#new-configuration-options
        #############################
        blur enable
        blur_passes 2
        blur_radius 8

        corner_radius 4
        shadows enable
        shadow_blur_radius 8
        shadow_color #${colors.base01}
        shadow_offset 4 4
        shadows_on_csd disable

        default_dim_inactive 0.1

        layer_effects gtk-layer-shell blur enable
        layer_effects gtk-layer-shell blur_ignore_transparent enable
        layer_effects launcher blur enable
        layer_effects launcher blur_ignore_transparent enable
        layer_effects logout_dialog blur enable
        layer_effects notifications blur enable
        layer_effects notifications blur_ignore_transparent enable
        layer_effects rofi blur enable
        layer_effects rofi blur_ignore_transparent enable
        layer_effects anyrun blur enable
        layer_effects anyrun blur_ignore_transparent enable
        layer_effects swaybar blur enable
        layer_effects swaybar blur_ignore_transparent enable
        layer_effects swayosd blur enable
        layer_effects swayosd blur_ignore_transparent enable
        layer_effects waybar blur enable
        layer_effects waybar blur_ignore_transparent enable

      '';
  };
}
