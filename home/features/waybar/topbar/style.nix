{config, ...}: {
  programs.waybar.style = with config.colorScheme.palette;
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
        background-color: #${base02};
        margin-left: 1rem;
      }
      /* For sway workspace buttons */
      #workspaces button.text-button {
        margin: 0;
        padding: 0;
      }
      #workspaces button {
        color: #${base07};
        border-radius: 1rem;
        padding: 2px 6px;
      }
      #workspaces button.active,
      #workspaces button.focused {
        color: #${base02};
        background-color: #${primary};
        border-radius: 1rem;
      }
      #workspaces button.urgent {
        color: #${base02};
        background-color: #${danger};
        border-radius: 1rem;
      }
      #workspaces button.empty {
        color: #${overlay1};
      }
      #workspaces button:hover {
        color: #${base02};
        background-color: #${primary};
      }

      .modules-left {
      }
      .modules-center {
        border-radius: 1rem;
        background-color: #${base02};
        color: #${base07};
        padding-left: 1rem;
        padding-right: 1rem;
      }
      .modules-right {
      }

      #tray {
        border-radius: 1rem;
        background-color: #${base02};
        color: #${base07};
        padding-left: 1rem;
        padding-right: 1rem;
      }

      #submap,
      #mode {
        border-radius: 1rem;
        background-color: #${primary};
        color: #${base02};
        padding-left: 1rem;
        padding-right: 1rem;
      }

      tooltip {
        background: #${base00};
        border: 1px solid #${primary};
      }

      tooltip label {
        color: #${base05};
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
        color: #${base07};
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
        color: #${warning};
      }

      #battery {
        color: #${success};
      }
      #battery.warning {
        color: #${warning};
      }
      #battery.critical:not(.charging) {
        color: #${danger};
      }
    '';
}
