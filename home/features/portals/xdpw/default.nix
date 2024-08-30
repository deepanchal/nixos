{
  lib,
  pkgs,
  ...
}: {
  # Screen recording/sharing with pipewire
  # Portal is installed with hyprland | sway
  # See: `man 5 xdg-desktop-portal-wlr`
  xdg.configFile."xdg-desktop-portal-wlr/config".text = lib.generators.toINI {} {
    screencast = {
      max_fps = 60;
      chooser_type = "simple";
      chooser_cmd = "slurp -f %o -or";
    };
  };
}
