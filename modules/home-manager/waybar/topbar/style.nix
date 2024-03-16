{ config, ... }:
let
  colors = config.colorScheme.palette;
  custom = {
    font = "JetBrainsMono Nerd Font, Material Design Icons";
    font_size = "15px";
    font_weight = "bold";
    text_color = colors.base05;
    active_color = colors.base0C;
    inactive_color = colors.base05;
    secondary_accent = colors.base0C;
    tertiary_accent = colors.base0E;
    background = colors.base00;
    opacity = "0.98";
  };
in
{
  programs.waybar.style = ''
    * {
        border: none;
        border-radius: 0px;
        padding: 0;
        margin: 0;
        min-height: 0px;
        font-family: ${custom.font};
        font-weight: ${custom.font_weight};
        opacity: ${custom.opacity};
    }

    window#waybar {
        border-radius: 8px;
        background: #${custom.background};
    }

    #workspaces {
        font-size: 14px;
    }
    #workspaces button {
        color: #${custom.text_color};
        padding-left:  6px;
        padding-right: 6px;
    }
    #workspaces button.empty {
        color: #${custom.inactive_color};
    }
    #workspaces button.active {
        color: #${custom.active_color};
    }

    #custom-search,
    #custom-power,
    #custom-todo,
    #custom-lock,
    #custom-weather,
    #custom-btc,
    #custom-eth,
    #bluetooth,
    #battery,
    #backlight,
    #volume,
    #tray,
    #pulseaudio,
    #network,
    #cpu,
    #memory,
    #disk,
    #clock {
        font-size: ${custom.font_size};
        color: #${custom.text_color};
        margin: 0px 8px 0px 8px;
    }
    
    #custom-power {
        padding-right: 6px;
    }
    
    #backlight {
      padding-right: 2px;
      color: #e5c890;
    }
    #battery {
      color: #a6d189;
    }
  
    #battery.warning {
      color: #ef9f76;
    }
  
    #battery.critical:not(.charging) {
      color: #e78284;
    }

    #custom-launcher {
        font-size: 20px;
        color: #${custom.text_color};
        font-weight: ${custom.font_weight};
        padding-left: 10px;
        padding-right: 18px;
    }
  '';
}
