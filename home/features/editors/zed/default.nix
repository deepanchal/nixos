{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  nixosRepoDir = "${config.home.homeDirectory}/projects/nixos";
  zedSettingsDir = "${nixosRepoDir}/home/features/editors/zed";
in
{
  home.packages = [
    pkgs.zed-editor
  ];

  xdg.configFile."zed/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${zedSettingsDir}/settings.jsonc";
  xdg.configFile."zed/keymap.json".source =
    config.lib.file.mkOutOfStoreSymlink "${zedSettingsDir}/keymap.jsonc";
}
