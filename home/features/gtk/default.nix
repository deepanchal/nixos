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
  catppuccin-kvantum = inputs.catppuccin-kvantum;
in {
  dconf = {
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "${themeName}-Compact-${accentName}-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [accentNameLower];
        tweaks = ["rimless"];
        size = "compact";
        variant = flavorLower;
      };
    };

    iconTheme = {
      package = pkgs.catppuccin-papirus-folders.override {
        accent = accentNameLower;
        flavor = flavorLower;
      };
      name = "Papirus-Dark";
    };
    font = {
      name = "Noto Sans";
      size = 11;
    };
    gtk3.extraConfig = {
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";
      gtk-xft-rgba = "rgb";
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk2.extraConfig = ''
      gtk-xft-antialias=1
      gtk-xft-hinting=1
      gtk-xft-hintstyle="hintslight"
      gtk-xft-rgba="rgb"
    '';
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
      name = "Bibata-Modern-Classic";
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
    platformTheme = "qtct";
    style = {
      name = "${themeName}-Dark";
      package = pkgs.catppuccin-kde.override {
        flavour = [flavorLower];
        accents = [accentNameLower];
      };
    };
  };
  xdg.configFile = {
    "Kvantum/catppuccin/catppuccin.kvconfig".source = "${catppuccin-kvantum}/src/${themeName}-${accentName}/${themeName}-${accentName}.kvconfig";
    "Kvantum/catppuccin/catppuccin.svg".source = "${catppuccin-kvantum}/src/${themeName}-${accentName}/${themeName}-${accentName}.svg";
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=catppuccin

      [Applications]
      catppuccin=qt5ct, org.qbittorrent.qBittorrent, hyprland-share-picker
    '';
  };
}
