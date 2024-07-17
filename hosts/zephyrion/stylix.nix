{
  inputs,
  config,
  pkgs,
  ...
}: {
  stylix = {
    enable = true;
    autoEnable = true;

    image = ../../home/features/theme/wallpapers/yosemite.png;
    # image = ../../home/features/theme/wallpapers/Cloudsnight.jpg;

    # base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/material.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic"; # Bibata-Modern-Amber | Bibata-Modern-Ice | Bibata-Original-Classic, etc.
      size = 16;
    };

    fonts = {
      serif = {
        # package = pkgs.dejavu_fonts;
        # name = "DejaVu Serif";
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };

      sansSerif = {
        # package = pkgs.dejavu_fonts;
        # name = "DejaVu Sans";
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };

      monospace = {
        package = pkgs.nerdfonts.override {
          fonts = ["FiraCode" "JetBrainsMono"];
        };
        name = "JetbrainsMono Nerd Font";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        applications = 10;
        desktop = 10;
        popups = 10;
        terminal = 10;
      };
    };

    opacity = {
      applications = 1.0;
      desktop = 1.0;
      popups = 1.0;
      terminal = 0.9;
    };
  };
}
