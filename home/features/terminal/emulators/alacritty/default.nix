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
        decorations =
          if pkgs.stdenv.hostPlatform.isDarwin
          then "Buttonless"
          else "none";
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
        opacity =
          if pkgs.stdenv.hostPlatform.isDarwin
          then 0.94
          else 0.85;
        blur = pkgs.stdenv.hostPlatform.isDarwin;
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
          key = "Space";
          mods = "Control|Shift";
          mode = "~Alt|~Search";
          action = "ToggleViMode";
        }
        {
          key = "Space";
          mods = "Control|Shift";
          mode = "Alt|~Search";
          chars = "\\u001b[32;6u";
        }
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
