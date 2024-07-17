{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: let
in {
  # home.file."${bat-theme-dir}/${themeName}.tmTheme".source = "${catppuccin-bat}/themes/Catppuccin\ ${flavor}.tmTheme";
  programs.bat = {
    enable = true;
    config = {
      pager = "less -FR"; # frfr
    };
    extraPackages = with pkgs.bat-extras; [batman];
  };
}
