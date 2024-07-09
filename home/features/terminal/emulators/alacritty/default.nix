{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  flavor = lib.toLower config.theme.name;
  catppuccin-alacritty = inputs.catppuccin-alacritty;
in {
  programs.alacritty = {
    enable = true;
    settings = {
      # Note: Alacritty's setting key for importing files is 'import' not 'imports'
      import = [
        "${catppuccin-alacritty}/${flavor}.toml"
      ];

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
        opacity = 0.9;
      };

      scrolling.history = 20000;

      font = {
        size = 10;
        normal = {
          # family = "FiraCode Nerd Font";
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
      };

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
