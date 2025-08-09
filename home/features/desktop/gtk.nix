{
  lib,
  pkgs,
  config,
  ...
}:
{
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-GTK-Purple-Dark-Compact";
      package = pkgs.magnetic-catppuccin-gtk.override {
        accent = [ "purple" ]; # "default" | "purple" | "pink" | "red" | "orange" | "yellow" | "green" | "teal" | "grey" | "all"
        shade = "dark"; # "light" | "dark"
        size = "compact"; # "standard" | "compact"
        # tweaks = [ "macchiato" ]; # "frappe" | "macchiato" | "black" | "float" | "outline" | "macos"
      };
    };
    cursorTheme = {
      name = config.home.pointerCursor.name;
      size = config.home.pointerCursor.size;
    };
    font = {
      name = "Noto Sans";
      size = 12;
    };
    gtk3 = {
      # Bookmarks in the sidebar of GTK file browser
      bookmarks =
        let
          userHome = config.home.homeDirectory;
        in
        [
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
    sessionVariables = {
      GTK_USE_PORTAL = "1";
    };
  };
}
