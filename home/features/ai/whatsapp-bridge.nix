{
  config,
  pkgs,
  ...
}: let
  label = "org.nix-community.home.whatsapp-bridge";
  logFile = "${config.home.homeDirectory}/Library/Logs/whatsapp-bridge.log";

  wa-bridge = pkgs.writeShellApplication {
    name = "wa-bridge";
    runtimeInputs = [pkgs.whatsapp-mcp];
    text = ''
      domain="gui/$(id -u)"
      service="$domain/${label}"
      plist="$HOME/Library/LaunchAgents/${label}.plist"

      is_running() {
        launchctl print "$service" >/dev/null 2>&1
      }

      case "''${1:-status}" in
        start)
          is_running || launchctl bootstrap "$domain" "$plist"
          ;;
        stop)
          ! is_running || launchctl bootout "$service"
          ;;
        restart)
          launchctl kickstart -k "$service"
          ;;
        status)
          if is_running; then
            launchctl print "$service" | grep -E '^\s+(state|pid) = '
          else
            echo "stopped"
          fi
          ;;
        logs)
          tail -n 50 -f "${logFile}"
          ;;
        link)
          ! is_running || launchctl bootout "$service"
          echo "Scan the QR code from WhatsApp > Settings > Linked Devices, wait for history to sync, then Ctrl+C and run: wa-bridge start"
          exec whatsapp-bridge
          ;;
        *)
          echo "usage: wa-bridge [start|stop|restart|status|logs|link]" >&2
          exit 2
          ;;
      esac
    '';
  };
in {
  home.packages = [
    pkgs.whatsapp-mcp
    wa-bridge
  ];

  launchd.agents.whatsapp-bridge = {
    enable = true;
    config = {
      ProgramArguments = ["${pkgs.whatsapp-mcp}/bin/whatsapp-bridge"];
      RunAtLoad = true;
      KeepAlive = true;
      ThrottleInterval = 30;
      StandardOutPath = logFile;
      StandardErrorPath = logFile;
    };
  };
}
