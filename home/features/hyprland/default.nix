{ pkgs, lib, inputs, ... }:
with lib; let
  wallpaper = ../theme/wallpapers/Rainnight.jpg;
  mkService = lib.recursiveUpdate {
    Unit.PartOf = [ "graphical-session.target" ];
    Unit.After = [ "graphical-session.target" ];
    Install.WantedBy = [ "graphical-session.target" ];
  };
in
{
  imports = [
    ./config.nix
    ./binds.nix
    ./rules.nix
  ];
  home.packages = with pkgs;
    with inputs.hyprcontrib.packages.${pkgs.system}; [
      libnotify
      wf-recorder
      brightnessctl
      pamixer
      python39Packages.requests
      slurp
      grim
      hyprpicker
      swappy
      grimblast
      hyprpicker
      wl-clip-persist
      wl-clipboard
      wdisplays
      pngquant
      cliphist
      (
        writeShellScriptBin
          "pauseshot"
          ''
            ${hyprpicker}/bin/hyprpicker -r -z &
            picker_proc=$!

            ${grimblast}/bin/grimblast save area - | tee ~/pics/ss$(date +'screenshot-%F') | wl-copy

            kill $picker_proc
          ''
      )
      (
        writeShellScriptBin "micmute"
          ''
            #!/bin/sh

            # shellcheck disable=SC2091
            if $(pamixer --default-source --get-mute); then
              pamixer --default-source --unmute
              sudo mic-light-off
            else
              pamixer --default-source --mute
              sudo mic-light-on
            fi
          ''
      )
    ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.default;
    plugins = [
      inputs.hy3.packages.${pkgs.system}.hy3
    ];
    systemd = {
      variables = [ "--all" ];
      extraCommands = [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };
  };

  # fake a tray to let apps start
  # https://github.com/nix-community/home-manager/issues/2064
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

  systemd.user.services = {
    swaybg = mkService {
      Unit.Description = "Wallpaper chooser";
      Service = {
        ExecStart = "${lib.getExe pkgs.swaybg} -i ${wallpaper}";
        Restart = "always";
      };
    };
  };
}
