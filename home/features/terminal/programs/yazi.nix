{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  catppuccin-yazi = inputs.catppuccin-yazi;
  catppuccin-bat = inputs.catppuccin-bat;
  flavor = config.theme.flavor;
in {
  home.packages = [pkgs.exiftool];
  xdg.configFile."yazi/Catppuccin-${lib.toLower flavor}.tmTheme".source = "${catppuccin-bat}/themes/Catppuccin ${flavor}.tmTheme";

  programs.yazi = {
    enable = true;
    theme = lib.importTOML "${catppuccin-yazi}/themes/${lib.toLower flavor}.toml";
    settings = {
      manager = {
        layout = [1 4 3];
        sort_by = "alphabetical";
        sort_sensitive = true;
        sort_reverse = false;
        sort_dir_first = true;
        linemode = "none";
        show_hidden = true;
        show_symlink = true;
      };
      preview = {
        tab_size = 2;
        # max_width = 600;
        # max_height = 900;
        # cache_dir = "${config.xdg.cacheHome}/yazi";
      };
    };
  };
}

