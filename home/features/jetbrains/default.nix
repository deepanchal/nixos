{
  config,
  lib,
  pkgs,
  flake,
  ...
}: {
  home.file = {
    ".ideavimrc".source = ./.ideavimrc;
  };

  home.packages = [
    pkgs.android-studio
    pkgs.jetbrains.webstorm
    pkgs.jetbrains.datagrip
    pkgs.jetbrains.pycharm-professional
  ];
}
