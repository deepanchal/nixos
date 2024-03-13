{ pkgs, ... }: {
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
        opacity = 0.9;
      };

      scrolling.history = 20000;

      # font = {
      #   normal.family = "JetBrains Mono";
      #   bold.family = "JetBrains Mono";
      #   italic.family = "JetBrains Mono";
      #   size = 10;
      # };

      font = {
        size = 9;
        normal = {
          family = "FiraCode Nerd Font";
        };
        # built_in_box_drawing = true;
      };

      cursor = {
        style = {
          shape = "Block";
        };
      };

      mouse = {
        hide_when_typing = true;
      };
      
      keyboard.bindings = [
        { key = "L"; mods = "Control|Shift"; action = "ClearHistory"; }
        { key = "Q"; mods = "Control|Shift"; action = "Quit"; }
        { key = "Z"; mods = "Control|Shift"; action = "ToggleFullscreen"; }
        { key = "Equals"; mods = "Control"; action = "ResetFontSize"; }
        { key = "NumpadAdd"; mods = "Control|Shift"; action = "IncreaseFontSize"; }
        { key = "NumpadSubtract"; mods = "Control"; action = "DecreaseFontSize"; }
        { key = "V"; mods = "Control|Shift"; action = "Paste"; }
        { key = "C"; mods = "Control|Shift"; action = "Copy"; }
        { key = "Return"; mods = "Shift"; chars = "\e[13;2u"; }
        { key = "Return"; mods = "Control"; chars = "\e[13;5u"; }
      ];

      colors = {
        draw_bold_text_with_bright_colors = true;
      };

      imports = [
        (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/catppuccin/alacritty/3c808cbb4f9c87be43ba5241bc57373c793d2f17/catppuccin-macchiato.yml";
          hash = "sha256-+m8FyPStdh1A1xMVBOkHpfcaFPcyVL99tIxHuDZ2zXI=";
        })
      ];
    };
  };
}
