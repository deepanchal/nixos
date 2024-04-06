{
  lib,
  pkgs,
  config,
  ...
}: let
  flavor = config.theme.flavor;
  accentName = config.theme.accentName;
  flavorLower = lib.toLower flavor;
  accentNameLower = lib.toLower accentName;
in {
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Compact-${accentName}-Dark";
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
      name = "Lexend";
      size = 11;
    };
    gtk3.extraConfig = {
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";
      gtk-xft-rgba = "rgb";
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
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
      name = "Catppuccin-Mocha-Dark";
      package = pkgs.catppuccin-kde.override {
        flavour = [flavorLower];
        accents = [accentNameLower];
      };
    };
  };
  xdg.configFile = {
    "Kvantum/catppuccin/catppuccin.kvconfig".source = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/Kvantum/main/src/Catppuccin-Mocha-${accentName}/Catppuccin-Mocha-${accentName}.kvconfig";
      sha256 = "sha256:1kzlb0vgy22dh5jhbba6pmaf7jxx7ab18g4ns2r6nxw2l3i4sdjq";
    };
    "Kvantum/catppuccin/catppuccin.svg".source = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/Kvantum/main/src/Catppuccin-Mocha-${accentName}/Catppuccin-Mocha-${accentName}.svg";
      sha256 = "sha256:1fny82l3m9334f64qlxz4s7l6dqgqiahsk2pj9srfwv8cql1jmv1";
    };
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=catppuccin

      [Applications]
      catppuccin=qt5ct, org.qbittorrent.qBittorrent, hyprland-share-picker
    '';
  };
}
