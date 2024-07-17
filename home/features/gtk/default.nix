{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  themeName = config.theme.name;
  flavor = config.theme.flavor;
  accentName = config.theme.accentName;
  flavorLower = lib.toLower flavor;
  accentNameLower = lib.toLower accentName;
in {
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.catppuccin-papirus-folders.override {
        accent = accentNameLower;
        flavor = flavorLower;
      };
      name = "Papirus-Dark";
    };
  };

  home = {
    packages = with pkgs; [
      qt5.qttools
      qt6Packages.qtstyleplugin-kvantum
      libsForQt5.qtstyleplugin-kvantum
      libsForQt5.qt5ct
      breeze-icons
    ];
    sessionVariables = {
      XCURSOR_SIZE = "16";
      GTK_USE_PORTAL = "1";
    };
  };
  qt = {
    enable = true;
  };
}
