{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        TERM = "xterm-256color";
      };
      window = {
        decorations = "none";
        dynamic_padding = true;
        dimensions = {
          columns = 100;
          lines = 25;
        };
        padding = {
          x = 0;
          y = 0;
        };
        startup_mode = "Maximized";
        opacity = 0.85;
        option_as_alt = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin "Both";
      };

      scrolling.history = 32000;

      font = {
        size = if pkgs.stdenv.hostPlatform.isDarwin then 13 else 10;
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
      };

      keyboard.bindings = [
        {
          key = "N";
          mods = "Control|Shift";
          action = "SpawnNewInstance";
        }
        {
          key = "K";
          mods = "Control";
          action = "ClearHistory";
        }
        {
          key = "Backslash";
          mods = "Control";
          chars = "\\u001c";
        }
        {
          key = "Tab";
          mods = "Control";
          chars = "\\u001c";
        }
      ];
    };
  };
}
