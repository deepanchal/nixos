{
  pkgs,
  inputs,
  config,
  ...
}: {
  # NOTE: Using a mix of nix-colors (https://github.com/Misterio77/nix-colors)
  # and catppucin nix (https://github.com/catppuccin/nix)
  # I plan on migrating away from catppuccin nix to nix-colors
  # eventually to keep theming more generic
  imports = [
    inputs.nix-colors.homeManagerModule
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  catppuccin = let
    # Type: one of “latte”, “frappe”, “macchiato”, “mocha”
    flavor = "mocha";
    # Type: one of “blue”, “flamingo”, “green”, “lavender”, “maroon”, “mauve”, “peach”, “pink”, “red”, “rosewater”, “sapphire”, “sky”, “teal”, “yellow”
    accent = "blue";
  in {
    # enable for all programs
    enable = true;
    flavor = flavor;
    accent = accent;
    pointerCursor = {
      enable = false;
    };
  };

  # Disable catppuccin theme on some apps
  wayland.windowManager.sway.catppuccin.enable = false;

  # nix-colors also exposes helper functions
  # This function is used internally to convert base16's schemes to nix-colors format,
  # but is exposed so you can absolutely do the same.
  # https://github.com/Misterio77/nix-colors?tab=readme-ov-file#schemefromyaml
  # colorScheme = inputs.nix-colors.lib.schemeFromYAML "cool-scheme" (builtins.readFile ./cool-scheme.yaml);

  # ***********************************
  # Catppuccin Mocha Theme
  # ***********************************
  # --------------------------------------------------------------------------
  # | Labels    | base16 | Hex     | RGB                | HSL                |
  # |-----------|--------|---------|--------------------|--------------------|
  # | rosewater | base06 | #f5e0dc | rgb(245, 224, 220) | hsl(10, 56%, 91%)  |
  # | flamingo  | base0F | #f2cdcd | rgb(242, 205, 205) | hsl(0, 59%, 88%)   |
  # | pink      |        | #f5c2e7 | rgb(245, 194, 231) | hsl(316, 72%, 86%) |
  # | mauve     | base0E | #cba6f7 | rgb(203, 166, 247) | hsl(267, 84%, 81%) |
  # | red       | base08 | #f38ba8 | rgb(243, 139, 168) | hsl(343, 81%, 75%) |
  # | maroon    |        | #eba0ac | rgb(235, 160, 172) | hsl(350, 65%, 77%) |
  # | peach     | base09 | #fab387 | rgb(250, 179, 135) | hsl(23, 92%, 75%)  |
  # | yellow    | base0A | #f9e2af | rgb(249, 226, 175) | hsl(41, 86%, 83%)  |
  # | green     | base0B | #a6e3a1 | rgb(166, 227, 161) | hsl(115, 54%, 76%) |
  # | teal      | base0C | #94e2d5 | rgb(148, 226, 213) | hsl(170, 57%, 73%) |
  # | sky       |        | #89dceb | rgb(137, 220, 235) | hsl(189, 71%, 73%) |
  # | sapphire  |        | #74c7ec | rgb(116, 199, 236) | hsl(199, 76%, 69%) |
  # | blue      | base0D | #89b4fa | rgb(137, 180, 250) | hsl(217, 92%, 76%) |
  # | lavender  | base07 | #b4befe | rgb(180, 190, 254) | hsl(232, 97%, 85%) |
  # | text      | base05 | #cdd6f4 | rgb(205, 214, 244) | hsl(226, 64%, 88%) |
  # | subtext1  |        | #bac2de | rgb(186, 194, 222) | hsl(227, 35%, 80%) |
  # | subtext0  |        | #a6adc8 | rgb(166, 173, 200) | hsl(228, 24%, 72%) |
  # | overlay2  |        | #9399b2 | rgb(147, 153, 178) | hsl(228, 17%, 64%) |
  # | overlay1  |        | #7f849c | rgb(127, 132, 156) | hsl(230, 13%, 55%) |
  # | overlay0  |        | #6c7086 | rgb(108, 112, 134) | hsl(231, 11%, 47%) |
  # | surface2  | base04 | #585b70 | rgb(88, 91, 112)   | hsl(233, 12%, 39%) |
  # | surface1  | base03 | #45475a | rgb(69, 71, 90)    | hsl(234, 13%, 31%) |
  # | surface0  | base02 | #313244 | rgb(49, 50, 68)    | hsl(237, 16%, 23%) |
  # | base      | base00 | #1e1e2e | rgb(30, 30, 46)    | hsl(240, 21%, 15%) |
  # | mantle    | base01 | #181825 | rgb(24, 24, 37)    | hsl(240, 21%, 12%) |
  # | crust     |        | #11111b | rgb(17, 17, 27)    | hsl(240, 23%, 9%)  |
  # --------------------------------------------------------------------------

  # NOTE: Redefining the catppuccin-mocha theme, despite its availability
  # in nix-colors under `config.colorSchemes.catppuccin-mocha`, to incorporate
  # additional theme colors not provided by base16 for better theming
  # https://github.com/tinted-theming/base16-schemes/blob/main/catppuccin-mocha.yaml

  # Can be `colorscheme` or `colorScheme` since there's an alias in nix-colors module
  colorScheme = {
    name = "Catppuccin Mocha";
    slug = "catppuccin-mocha";
    author = "Catppuccin";
    description = ''
      Catppuccin Mocha Theme
      https://github.com/catppuccin/catppuccin?tab=readme-ov-file#-palette
    '';
    variant = "dark";
    palette = rec {
      # Base16 Colors
      base00 = base;
      base01 = mantle;
      base02 = surface0;
      base03 = surface1;
      base04 = surface2;
      base05 = text;
      base06 = rosewater;
      base07 = lavender;
      base08 = red;
      base09 = peach;
      base0A = yellow;
      base0B = green;
      base0C = teal;
      base0D = blue;
      base0E = mauve;
      base0F = flamingo;

      # Other helpful color vars named in tailwind/bootstrap css style
      primary = blue;
      secondary = mauve;
      accent = peach;
      light = text;
      dark = base;
      success = green;
      info = sapphire;
      warning = yellow;
      danger = red;

      # All theme colors
      # NOTE: `#` prefix gets removed by nix-colors `colorscheme.nix` module
      # https://github.com/Misterio77/nix-colors/blob/b01f024090d2c4fc3152cd0cf12027a7b8453ba1/module/colorscheme.nix#L66
      rosewater = "#f5e0dc";
      flamingo = "#f2cdcd";
      pink = "#f5c2e7";
      mauve = "#cba6f7";
      red = "#f38ba8";
      maroon = "#eba0ac";
      peach = "#fab387";
      yellow = "#f9e2af";
      green = "#a6e3a1";
      teal = "#94e2d5";
      sky = "#89dceb";
      sapphire = "#74c7ec";
      blue = "#89b4fa";
      lavender = "#b4befe";
      text = "#cdd6f4";
      subtext1 = "#bac2de";
      subtext0 = "#a6adc8";
      overlay2 = "#9399b2";
      overlay1 = "#7f849c";
      overlay0 = "#6c7086";
      surface2 = "#585b70";
      surface1 = "#45475a";
      surface0 = "#313244";
      base = "#1e1e2e";
      mantle = "#181825";
      crust = "#11111b";
    };
  };
}
