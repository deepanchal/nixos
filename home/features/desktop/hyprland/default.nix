{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
with lib; let
  mkService = lib.recursiveUpdate {
    Unit.PartOf = ["graphical-session.target"];
    Unit.After = ["graphical-session.target"];
    Install.WantedBy = ["graphical-session.target"];
  };
in {
  imports = [
    ./config.nix
    ./binds.nix
    ./rules.nix
  ];
  home.packages = with pkgs; [
    libnotify
    wl-screenrec
    brightnessctl
    pamixer
    slurp
    grim
    hyprpicker
    swappy
    grimblast
    hyprpicker
    wl-clip-persist
    wl-clipboard
    wdisplays
    wev
    # watershot # Simple wayland native screenshot tool in Rust
    # ironbar # Wayland gtk bar in Rust
    cliphist
  ];

  # https://github.com/nix-community/home-manager/blob/master/modules/services/window-managers/hyprland.nix
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [
    ];
    # systemd = {
    #   variables = ["--all"];
    #   extraCommands = [
    #     "systemctl --user stop graphical-session.target"
    #     "systemctl --user start hyprland-session.target"
    #   ];
    # };
  };

  # programs.hyprlock = {
  #   enable = true;
  # };
  # services.hypridle = {
  #   enable = true;
  # };
  # services.hyprpaper = {
  #   enable = true;
  # };

  # fake a tray to let apps start
  # https://github.com/nix-community/home-manager/issues/2064
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = ["graphical-session-pre.target"];
    };
  };

  systemd.user.services = {
    swaybg = mkService {
      Unit.Description = "Wallpaper chooser";
      Service = {
        ExecStart = "${lib.getExe pkgs.swaybg} -i ${config.wallpaper}";
        Restart = "always";
      };
    };
  };
}
