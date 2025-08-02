{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  nixosRepoDir = "${config.home.homeDirectory}/projects/nixos";
  vscodeSettingsDir = "${nixosRepoDir}/home/features/editors/vscode";
  cursorSettingsDir = vscodeSettingsDir;
in
{
  home.packages = [
    pkgs.vscode
    pkgs.code-cursor
  ];

  xdg.configFile."Code/User/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${vscodeSettingsDir}/settings.jsonc";

  xdg.configFile."Cursor/User/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${cursorSettingsDir}/settings.jsonc";
}

