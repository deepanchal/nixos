{ pkgs, lib, theme, ... }:
{
  programs.fish = {
    enable = true;
    # interactiveShellInit = ''
    #   eval "$(${lib.getExe pkgs.starship} init fish)"
    # '';
  };
}

