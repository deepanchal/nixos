{ ... }:
{
  programs.waybar.settings.mainBar = {
    position = "top";
    layer = "top";
    height = 30;
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
    ];
    clock = {
      format = " {:%H:%M}";
      tooltip = "true";
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      format-alt = " {:%d/%m}";
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
      tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
      format-linked = "{ifname} (No IP)";
      format-disconnected = "󰖪 ";
    };
    tray = {
      icon-size = 20;
      spacing = 8;
    };
    pulseaudio = {
      format = "{icon} {volume}%";
      format-muted = "󰖁 ";
      format-icons = {
        default = [ " " ];
      };
      scroll-step = 5;
      on-click = "pamixer -t";
    };
    "custom/launcher" = {
      format = "";
      on-click = "pkill rofi || rofi -show drun";
      on-click-right = "pkill rofi || wallpaper-picker";
      tooltip = "false";
    };
  };
}
