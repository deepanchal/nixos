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
    settings.mainBar = {
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
        "backlight"
        "battery"
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
        show-special = true;
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
          # "*" = [ ];
          "1" = [ ];
          "2" = [ ];
          "3" = [ ];
          "4" = [ ];
          "5" = [ ];
          "6" = [ ];
          "7" = [ ];
          "8" = [ ];
          "9" = [ ];
          "10" = [ ];
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
    };
  };
}
