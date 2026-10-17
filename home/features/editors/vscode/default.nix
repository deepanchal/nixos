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
  appConfigDir =
    if pkgs.stdenv.hostPlatform.isDarwin then "Library/Application Support" else ".config";
in
{
  home.packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    pkgs.vscode
    pkgs.code-cursor
  ];

  home.file."${appConfigDir}/Code/User/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${vscodeSettingsDir}/settings.jsonc";

  home.file."${appConfigDir}/Cursor/User/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${cursorSettingsDir}/settings.jsonc";
}

