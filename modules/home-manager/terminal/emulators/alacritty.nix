{ pkgs, ... }: {
  programs.alacritty = {
    enable = true;
    settings = {
      # Note: Alacritty's setting key for importing files is 'import' not 'imports'
      import = [
        (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/catppuccin/alacritty/832787d6cc0796c9f0c2b03926f4a83ce4d4519b/catppuccin-mocha.toml";
          hash = "sha256-nmVaYJUavF0u3P0Qj9rL+pzcI9YQOTGPyTvi+zNVPhg=";
        })
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
          family = "JetBrains Mono";
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
      
      # keyboard.bindings = [
      #   { key = "L"; mods = "Control|Shift"; action = "ClearHistory"; }
      #   { key = "Q"; mods = "Control|Shift"; action = "Quit"; }
      #   { key = "Z"; mods = "Control|Shift"; action = "ToggleFullscreen"; }
      #   { key = "Equals"; mods = "Control"; action = "ResetFontSize"; }
      #   { key = "NumpadAdd"; mods = "Control|Shift"; action = "IncreaseFontSize"; }
      #   { key = "NumpadSubtract"; mods = "Control"; action = "DecreaseFontSize"; }
      #   { key = "V"; mods = "Control|Shift"; action = "Paste"; }
      #   { key = "C"; mods = "Control|Shift"; action = "Copy"; }
      #   { key = "Return"; mods = "Shift"; chars = "\e[13;2u"; }
      #   { key = "Return"; mods = "Control"; chars = "\e[13;5u"; }
      # ];
    };
  };
}
