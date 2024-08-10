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
    pkgs.jetbrains.pycharm-professional
  ];
}
