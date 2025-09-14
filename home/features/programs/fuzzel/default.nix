{
  lib,
  pkgs,
  config,
  ...
}:
let
  colors = config.colorScheme.palette;
in
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size 10";
        layer = "overlay";
        terminal = "${lib.getExe pkgs.alacritty} -e";
        prompt = "\"󰅂 \"";
        lines = 20;
        width = 64;
        vertical-pad = 8;
        horizontal-pad = 8;
        inner-pad = 8;
        dpi-aware = "no";
      };

      border = {
        width = 1;
        radius = 16;
        selection-radius = 0;
      };

      dmenu = {
        exit-immediately-if-empty = true;
      };
    };
  };
}
