{
  lib,
  pkgs,
  config,
  ...
}: let
  mkService = lib.recursiveUpdate {
    Unit.PartOf = ["graphical-session.target"];
    Unit.After = ["graphical-session.target"];
    Install.WantedBy = ["graphical-session.target"];
  };
in {
  imports = [
    ./catppuccin.nix
  ];

  wallpaper = ./wallpapers/kurzgesagt-cosmic-islands.png; # Comes from custom `wallpaper` hm-module

  home.packages = [
    pkgs.swaybg
    pkgs.awww

    (pkgs.writeShellScriptBin "wallpaper-chooser" ''
      awww img ~/Pictures/wallpapers/"$(fd . ~/Pictures/wallpapers --format {/} | fuzzel --dmenu)" && notify-send "Wallpaper changed" || notify-send "Failed to change wallpaper!"
    '')
  ];

  systemd.user.services = {
    # swaybg = mkService {
    #   Unit.Description = "Wallpaper chooser";
    #   Service = {
    #     ExecStart = "${lib.getExe pkgs.swaybg} -i ${config.wallpaper}";
    #     Restart = "always";
    #   };
    # };

    # Animated Wayland Wallpaper Woes (AWWW) services
    # Also see: https://codeberg.org/LGFae/awww
    awww-daemon = mkService {
      Unit.Description = "Efficient animated wallpaper daemon for wayland, controlled at runtime";
      Service = {
        Type = "simple";
        ExecStart = ''
          ${pkgs.awww}/bin/awww-daemon
        '';
        ExecStop = "${pkgs.awww}/bin/awww kill";
        Restart = "on-failure";
      };
    };
    awww = mkService {
      Unit = {
        Description = "Set default wallpaper with awww";
        Requires = ["awww-daemon.service"];
        After = ["awww-daemon.service"];
        PartOf = ["awww-daemon.service"];
      };
      Install.WantedBy = ["awww-daemon.service"];
      Service = {
        Type = "oneshot";
        ExecStart = ''
          ${pkgs.awww}/bin/awww img "${config.wallpaper}" --transition-type random
        '';
        Restart = "on-failure";
      };
    };
  };
}
