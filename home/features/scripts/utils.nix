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

    (pkgs.writeShellScriptBin "restart-xdpw" ''
      delay=2
      services=(
        "xdg-desktop-portal-wlr"
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
      echo "xdpw services have been restarted."
    '')

    (pkgs.writeShellScriptBin "screenshot" ''
      [[ -f ~/.config/user-dirs.dirs ]] && source ~/.config/user-dirs.dirs
      OUTPUT_DIR="''${XDG_PICTURES_DIR:-$HOME/Pictures}"

      if [[ ! -d "$OUTPUT_DIR" ]]; then
        notify-send "Screenshot directory does not exist: $OUTPUT_DIR" -u critical -t 3000
        exit 1
      fi

      pkill slurp || hyprshot -m ''${1:-region} --raw |
        satty --filename - \
          --output-filename "$OUTPUT_DIR/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png" \
          --early-exit \
          --actions-on-enter save-to-clipboard \
          --save-after-copy \
          --copy-command 'wl-copy'
    '')
  ];
}
