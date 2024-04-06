{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: let
  bat-theme-dir = ".config/bat/themes";
  catppuccin-bat = inputs.catppuccin-bat;
  themeName = lib.toLower config.theme.name;
  flavor = config.theme.flavor;
in {
  # home.file."${bat-theme-dir}/${themeName}.tmTheme".source = "${catppuccin-bat}/themes/Catppuccin\ ${flavor}.tmTheme";

  xdg.configFile = {
    catppuccin-bat = {
      source = "${inputs.catppuccin-bat}/themes";
      target = "bat/themes";
      recursive = true;
    };
  };
  programs.bat = {
    enable = true;
    config = {
      theme = "Catppuccin ${flavor}";
      pager = "less -FR"; # frfr
    };
    extraPackages = with pkgs.bat-extras; [batman];
  };
}
