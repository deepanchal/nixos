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
}
