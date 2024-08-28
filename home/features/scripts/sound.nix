{
  lib,
  pkgs,
  config,
  ...
}: let
  mpv = "${lib.getExe pkgs.mpv}";
  getFreeDesktopSound = file: "${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/${file}";
  getKdeSound = file: "${pkgs.kdePackages.ocean-sound-theme}/share/sounds/ocean/stereo/${file}";
  sounds = {
    notify = getFreeDesktopSound "message.oga";
    vol-change = getFreeDesktopSound "audio-volume-change.oga";
    bell = getFreeDesktopSound "bell.oga";
    ding = getFreeDesktopSound "complete.oga";
    warning = getFreeDesktopSound "dialog-warning.oga";
    info = getFreeDesktopSound "dialog-information.oga";
    device-added = getKdeSound "device-added.oga";
    device-removed = getKdeSound "device-removed.oga";
    power-plug = getKdeSound "power-plug.oga";
    power-unplug = getKdeSound "power-unplug.oga";
  };
in {
  home.packages = [
    (pkgs.writeShellScriptBin "play-notification-sound" "${mpv} ${sounds.notify}")
    (pkgs.writeShellScriptBin "play-vol-change-sound" "${mpv} ${sounds.vol-change}")
    (pkgs.writeShellScriptBin "play-bell-sound" "${mpv} ${sounds.bell}")
    (pkgs.writeShellScriptBin "play-ding-sound" "${mpv} ${sounds.ding}")
    (pkgs.writeShellScriptBin "play-warning-sound" "${mpv} ${sounds.warning}")
    (pkgs.writeShellScriptBin "play-info-sound" "${mpv} ${sounds.info}")
    (pkgs.writeShellScriptBin "play-device-added-sound" "${mpv} ${sounds.device-added}")
    (pkgs.writeShellScriptBin "play-device-removed-sound" "${mpv} ${sounds.device-removed}")
    (pkgs.writeShellScriptBin "play-power-plug-sound" "${mpv} ${sounds.power-plug}")
    (pkgs.writeShellScriptBin "play-power-unplug-sound" "${mpv} ${sounds.power-unplug}")
  ];
}
