{config, ...}: let
  colors = config.colorScheme.palette;
in {
  programs.waybar.style =
    # css
    ''
      * {
        font-size: 14px;
        font-family: JetBrainsMono Nerd Font, Material Design Icons;
        font-weight: bold;
        min-height: 0px;
      }

      #workspaces {
        border-radius: 1rem;
        background-color: #${colors.base02};
        margin-left: 1rem;
      }
      #workspaces button {
        color: #${colors.base07};
        border-radius: 1rem;
        padding: 2px 6px;
      }
      #workspaces button.active  {
        color: #${colors.base02};
        background-color: #${colors.primary};
        border-radius: 1rem;
      }
      #workspaces button.empty {
        color: #${colors.overlay1};
      }
      #workspaces button:hover {
        color: #${colors.base02};
        background-color: #${colors.primary};
        border-radius: 1rem;
      }

      .modules-left {
      }
      .modules-center {
        border-radius: 1rem;
        background-color: #${colors.base02};
        color: #${colors.base07};
        padding-left: 1rem;
        padding-right: 1rem;
      }
      .modules-right {
      }

      #tray {
        border-radius: 1rem;
        background-color: #${colors.base02};
        color: #${colors.base07};
        padding-left: 1rem;
        padding-right: 1rem;
      }

      #submap {
        border-radius: 1rem;
        background-color: #${colors.primary};
        color: #${colors.base02};
        padding-left: 1rem;
        padding-right: 1rem;
      }

      tooltip {
        background: #${colors.base00};
        border: 1px solid #${colors.primary};
      }

      tooltip label {
        color: #${colors.base05};
      }

      #custom-search,
      #custom-power,
      #custom-notification,
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
      #disk {
        color: #${colors.base07};
        margin-left: 8px;
        margin-right: 8px;
      }

      #custom-power {
        padding-right: 8px;
      }
      #custom-launcher {
        font-size: 18px;
        padding-left: 8px;
      }

      #backlight {
        padding-right: 2px;
        color: #e5c890;
      }

      #battery {
        color: #${colors.success};
      }
      #battery.warning {
        color: #${colors.warning};
      }
      #battery.critical:not(.charging) {
        color: #${colors.danger};
      }
    '';
}
