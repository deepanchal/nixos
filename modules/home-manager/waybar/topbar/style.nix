{ config, ... }:
let
  colors = config.colorScheme.palette;
  custom = {
    font = "JetBrainsMono Nerd Font";
    font_size = "15px";
    font_weight = "bold";
    text_color = colors.base05;
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
        border-radius: 15px;
        background: #${colors.base00};
    }

    #workspaces {
        font-size: 18px;
        padding-left: 15px;
        
    }
    #workspaces button {
        color: #${custom.text_color};
        padding-left:  6px;
        padding-right: 6px;
    }
    #workspaces button.empty {
        color: #${colors.base03};
    }
    #workspaces button.active {
        color: #${colors.base0D};
    }

    #tray, #pulseaudio, #network, #cpu, #memory, #disk, #clock {
        font-size: ${custom.font_size};
        color: #${custom.text_color};
    }

    #cpu {
        padding-left: 15px;
        padding-right: 9px;
        margin-left: 7px;
    }
    #memory {
        padding-left: 9px;
        padding-right: 9px;
    }
    #disk {
        padding-left: 9px;
        padding-right: 15px;
    }

    #tray {
        padding: 0 20px;
        margin-left: 7px;
    }

    #pulseaudio {
        padding-left: 15px;
        padding-right: 9px;
        margin-left: 7px;
    }
    #network {
        padding-left: 9px;
        padding-right: 15px;
    }
    
    #clock {
        padding-left: 9px;
        padding-right: 15px;
    }

    #custom-launcher {
        font-size: 20px;
        color: #${colors.base07};
        font-weight: ${custom.font_weight};
        padding-left: 10px;
        padding-right: 15px;
    }
  '';
}
