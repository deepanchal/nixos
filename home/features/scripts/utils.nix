{
  lib,
  pkgs,
  config,
  ...
}: {
  home.packages = [
    (pkgs.writeShellScriptBin "restart-xdph" ''
      delay=2
      services=(
        "xdg-desktop-portal-hyprland"
        "xdg-desktop-portal-gtk"
        "xdg-desktop-portal"
      )
      for service in "''${services[@]}"; do
        echo "Stopping $service..."
        systemctl --user stop "$service"
      done
      echo "Waiting for $delay seconds before starting..."
      sleep "$delay"
      for service in "''${services[@]}"; do
        echo "Starting $service..."
        systemctl --user start "$service"
      done
      echo "xdph services have been restarted."
    '')
  ];
}
