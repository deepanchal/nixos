{ pkgs, ... }:
{
  imports = [
    ./style.nix
  ];

  programs.waybar = {
    enable = true;
    # style = import ./style.nix;
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
    settings.mainBar =
      {
        position = "top";
        layer = "top";
        height = 30;
        # spacing = 8;
        margin-top = 4;
        margin-bottom = 0;
        margin-left = 4;
        margin-right = 4;
        modules-left = [
          "custom/launcher"
          "hyprland/workspaces"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "tray"
          "cpu"
          "memory"
          "disk"
          "pulseaudio"
          "network"
          "bluetooth"
          "backlight"
          "battery"
          "custom/notification"
          "custom/lock"
          "custom/power"
        ];
        clock = {
          format = " {:%H:%M}";
          tooltip = "true";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = " {:%m/%d}";
        };
        "hyprland/workspaces" = {
          active-only = false;
          disable-scroll = true;
          format = "{icon}";
          on-click = "activate";
          # show-special = true;
          # format-icons = {
          #   "1" = "󰈹";
          #   "2" = "";
          #   "3" = "󰘙";
          #   "4" = "󰙯";
          #   "5" = "";
          #   "6" = "";
          #   urgent = "";
          #   default = "";
          #   sort-by-number = true;
          # };
          persistent-workspaces = {
            "1" = [ "DP-1" ];
            "2" = [ "DP-1" ];
            "3" = [ "DP-1" ];
            "4" = [ "DP-1" ];
            "5" = [ "eDP-1" ];
            "6" = [ "eDP-1" ];
            "7" = [ "eDP-1" ];
            "8" = [ "eDP-1" ];
          };
        };
        memory = {
          format = "󰟜 {}%";
          format-alt = "󰟜 {used} GiB"; # 
          interval = 2;
        };
        cpu = {
          format = "  {usage}%";
          format-alt = "  {avg_frequency} GHz";
          interval = 2;
        };
        disk = {
          # path = "/";
          format = "󰋊 {percentage_used}%";
          interval = 60;
        };
        network = {
          format-wifi = "  {signalStrength}%";
          format-ethernet = "󰀂 ";
          tooltip-format = "{ipaddr}/{ifname} via {gwaddr} ({signalStrength}%)";
          format-linked = "{ifname} (No IP)";
          format-disconnected = "󰖪 ";
          on-click = "XDG_CURRENT_DESKTOP=GNOME XDG_SESSION_DESKTOP=gnome gnome-control-center wifi";
        };
        tray = {
          icon-size = 20;
          spacing = 8;
        };
        pulseaudio = {
          scroll-step = 5;
          tooltip = true;
          tooltip-format = "{volume}% {format_source}";
          on-click = "${pkgs.killall}/bin/killall pavucontrol || ${pkgs.pavucontrol}/bin/pavucontrol";
          format = " {icon} {volume}%";
          format-bluetooth = "󰂯 {icon} {volume}%";
          format-muted = "󰝟 ";
          format-icons = {
            default = [ "" "" " " ];
          };
        };
        bluetooth = {
          format = " {status}";
          format-connected = " {device_alias}";
          format-connected-battery = " {device_alias} {device_battery_percentage}%";
          # format-device-preference = [ "device1", "device2" ]; # preference list deciding the displayed device
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
        };
        backlight = {
          format = "{icon}";
          format-icons = [ "" "" "" "" "" "" "" "" "" ];
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "{icon} {capacity}% 󰚥";
          tooltip-format = "{timeTo} {capacity}% 󱐋{power}";
          format-icons = [ "󰂃" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        };
        "custom/launcher" = {
          format = "";
          on-click = "pkill rofi || ${pkgs.rofi}/bin/rofi -show combi";
          tooltip = "false";
        };
        "custom/lock" = {
          tooltip = false;
          on-click = "sh -c '(sleep 0.5s; swaylock)' & disown";
          format = "";
        };
        "custom/power" = {
          tooltip = false;
          on-click = "wlogout &";
          format = "";
        };
        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };
      };
  };
}
