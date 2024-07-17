{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
in {
  programs.alacritty = {
    enable = true;
    settings = {
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
      };

      scrolling.history = 20000;

      # cursor = {
      #   style = {
      #     shape = "Block";
      #   };
      # };

      # mouse = {
      #   hide_when_typing = true;
      # };

      keyboard.bindings = [
        {
          key = "N";
          mods = "Control|Shift";
          action = "SpawnNewInstance";
        }
        {
          key = "0";
          mods = "Control";
          action = "ResetFontSize";
        }
        {
          key = "NumpadAdd";
          mods = "Control|Shift";
          action = "IncreaseFontSize";
        }
        {
          key = "NumpadSubtract";
          mods = "Control|Shift";
          action = "DecreaseFontSize";
        }
        # {
        #   key = "Return";
        #   mods = "Shift";
        #   chars = "\e[13;2u";
        # }
        # {
        #   key = "Return";
        #   mods = "Control";
        #   chars = "\e[13;5u";
        # }
      ];
    };
  };
}
