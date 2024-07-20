{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: {
  programs.bat = {
    enable = true;
    config = {
      pager = "less -FR"; # frfr
    };
    extraPackages = with pkgs.bat-extras; [batman];
  };
}
