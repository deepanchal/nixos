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
  wayland.windowManager.hyprland.catppuccin.enable = false;
  programs.swaylock.catppuccin.enable = false;
  programs.hyprlock.catppuccin.enable = false;
  programs.git.delta.catppuccin.enable = false;

  # nix-colors also exposes helper functions
  # This function is used internally to convert base16's schemes to nix-colors format,
  # but is exposed so you can absolutely do the same.
  # https://github.com/Misterio77/nix-colors?tab=readme-ov-file#schemefromyaml
  # colorScheme = inputs.nix-colors.lib.schemeFromYAML "cool-scheme" (builtins.readFile ./cool-scheme.yaml);

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
      error = red;
      danger = error;

      # All theme colors
      # NOTE: `#` prefix gets removed by nix-colors `colorscheme.nix` module.
      # I have kept the prefix here so that I can visualize colors with nvim-colorizer (https://github.com/norcalli/nvim-colorizer.lua)
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
