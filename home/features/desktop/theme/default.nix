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
    pkgs.swww

    (pkgs.writeShellScriptBin "wallpaper-chooser" ''
      swww img ~/Pictures/wallpapers/"$(fd . ~/Pictures/wallpapers --format {/} | fuzzel --dmenu)" && notify-send "Wallpaper changed" || notify-send "Failed to change wallpaper!"
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

    # A Solution to your Wayland Wallpaper Woes (SWWW) services
    # Also see: https://github.com/LGFae/swww/blob/main/example_scripts/README.md
    swww-daemon = mkService {
      Unit.Description = "Efficient animated wallpaper daemon for wayland, controlled at runtime";
      Service = {
        Type = "simple";
        ExecStart = ''
          ${pkgs.swww}/bin/swww-daemon
        '';
        ExecStop = "${pkgs.swww}/bin/swww kill";
        Restart = "on-failure";
      };
    };
    swww = mkService {
      Unit = {
        Description = "Set default wallpaper with swww";
        Requires = ["swww-daemon.service"];
        After = ["swww-daemon.service"];
        PartOf = ["swww-daemon.service"];
      };
      Install.WantedBy = ["swww-daemon.service"];
      Service = {
        Type = "oneshot";
        ExecStart = ''
          ${pkgs.swww}/bin/swww img "${config.wallpaper}" --transition-type random
        '';
        Restart = "on-failure";
      };
    };
  };
}
