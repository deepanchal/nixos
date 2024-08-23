{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  cursorThemeName = "Bibata-Modern-Classic";
in {
  gtk = {
    enable = true;
    catppuccin = {
      enable = true;
      # Type: list of (one of “black”, “rimless”, “normal”)
      tweaks = ["rimless"];
      icon = {
        enable = true;
      };
    };
    cursorTheme = {
      name = cursorThemeName;
      size = 16;
    };
    font = {
      name = "Noto Sans";
      size = 12;
    };
    gtk3 = {
      # Bookmarks in the sidebar of GTK file browser
      bookmarks = let 
        userHome = config.home.homeDirectory;
      in [
        "file:///tmp"
        "file://${userHome}/projects"
        "file://${userHome}/Pictures"
        "file://${userHome}/Downloads"
        "file://${userHome}/Documents"
        "file:///btr_pool"
        "file:///btr_pool/@dumps"
      ];
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
    pointerCursor = {
      package = pkgs.bibata-cursors;
      name = cursorThemeName;
      size = 16;
      gtk.enable = true;
      x11.enable = true;
    };

    sessionVariables = {
      XCURSOR_SIZE = "16";
      GTK_USE_PORTAL = "1";
    };
  };
  qt = {
    enable = true;
    platformTheme = {
      name = "kvantum";
    };
    style = {
      name = "kvantum";
      catppuccin = {
        enable = true;
      };
    };
  };
}
